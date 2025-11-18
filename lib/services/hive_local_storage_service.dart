import 'dart:async';

import 'package:hive/hive.dart';

import 'local_storage_service.dart';
import 'hive_init.dart';

class HiveLocalStorageService<T> implements ILocalStorageService<T> {
  HiveLocalStorageService({
    required HiveInterface hive,
    required HiveInit hiveInit,
    SchemaValidator<T>? defaultValidator,
    StorageLogger? logger,
  }) : _hive = hive,
       _hiveInit = hiveInit,
       _defaultValidator = defaultValidator,
       _logger = logger ?? _silentLogger;

  final HiveInterface _hive;
  final HiveInit _hiveInit;
  final SchemaValidator<T>? _defaultValidator;
  final StorageLogger _logger;

  final _boxCache = <String, Box<T>>{};
  final _boxOpenFutures = <String, Future<Box<T>>>{};
  final _boxQueues = <String, _AsyncQueue>{};

  bool _disposed = false;

  @override
  Future<StorageResult<void>> ensureInitialized() async {
    if (_disposed) {
      return StorageResult.fromFailure(
        StorageFailure(
          type: StorageFailureType.concurrency,
          message: 'Storage service disposed',
        ),
      );
    }

    try {
      await _hiveInit.ensureInitialized();
      return StorageResult.emptySuccess();
    } catch (error, stackTrace) {
      return StorageResult.fromFailure(
        StorageFailure(
          type: StorageFailureType.hive,
          message: 'Failed to initialize Hive',
          cause: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<StorageResult<void>> openBox(
    String boxName, {
    bool preload = false,
  }) async {
    final initResult = await ensureInitialized();
    if (!initResult.isSuccess) {
      return initResult;
    }

    if (_boxCache[boxName]?.isOpen ?? false) {
      return StorageResult.emptySuccess();
    }

    _boxOpenFutures[boxName] ??= _hive.openBox<T>(boxName);

    try {
      final box = await _boxOpenFutures[boxName]!;
      _boxCache[boxName] = box;
      if (preload) {
        await Future.microtask(() => box.values.toList());
      }
      return StorageResult.emptySuccess();
    } catch (error, stackTrace) {
      _boxOpenFutures.remove(boxName);
      _logger(
        'Failed to open Hive box $boxName',
        error: error,
        stackTrace: stackTrace,
      );
      return StorageResult.fromFailure(
        _mapFailure(
          'Unable to open Hive box $boxName',
          StorageFailureType.boxUnavailable,
          error,
          stackTrace,
        ),
      );
    }
  }

  @override
  Future<StorageResult<void>> closeBox(String boxName) async {
    final box = _boxCache.remove(boxName);
    if (box == null || !box.isOpen) {
      return StorageResult.emptySuccess();
    }

    try {
      await box.close();
      _boxOpenFutures.remove(boxName);
      _boxQueues.remove(boxName);
      return StorageResult.emptySuccess();
    } catch (error, stackTrace) {
      return StorageResult.fromFailure(
        _mapFailure(
          'Unable to close Hive box $boxName',
          StorageFailureType.hive,
          error,
          stackTrace,
        ),
      );
    }
  }

  @override
  Future<StorageResult<bool>> isBoxOpen(String boxName) async {
    final initResult = await ensureInitialized();
    if (!initResult.isSuccess) {
      return StorageResult.fromFailure(initResult.failure!);
    }
    final isOpen = _boxCache[boxName]?.isOpen ?? false;
    return StorageResult.success(isOpen);
  }

  @override
  Future<StorageResult<T?>> get(String boxName, String key) {
    return _scheduleOnBox<T?>(boxName, (box) async {
      return StorageResult.success(box.get(key));
    });
  }

  @override
  Future<StorageResult<List<T>>> getAll(String boxName) {
    return _scheduleOnBox<List<T>>(boxName, (box) async {
      return StorageResult.success(box.values.toList(growable: false));
    });
  }

  @override
  Future<StorageResult<void>> put(
    String boxName, {
    required String key,
    required T value,
    SchemaValidator<T>? validator,
  }) {
    return _scheduleOnBox<void>(boxName, (box) async {
      final failure = _validateValue(value, validator ?? _defaultValidator);
      if (failure != null) {
        return StorageResult.fromFailure(failure);
      }
      await box.put(key, value);
      return StorageResult.emptySuccess();
    });
  }

  @override
  Future<StorageResult<void>> putAll(
    String boxName, {
    required Map<String, T> values,
    SchemaValidator<T>? validator,
  }) {
    return _scheduleOnBox<void>(boxName, (box) async {
      for (final entry in values.entries) {
        final failure = _validateValue(
          entry.value,
          validator ?? _defaultValidator,
        );
        if (failure != null) {
          return StorageResult.fromFailure(failure);
        }
      }
      await box.putAll(values);
      return StorageResult.emptySuccess();
    });
  }

  @override
  Future<StorageResult<void>> delete(String boxName, String key) {
    return _scheduleOnBox<void>(boxName, (box) async {
      if (!box.containsKey(key)) {
        return StorageResult.fromFailure(
          StorageFailure(
            type: StorageFailureType.notFound,
            message: 'Key $key not found in $boxName',
          ),
        );
      }
      await box.delete(key);
      return StorageResult.emptySuccess();
    });
  }

  @override
  Future<StorageResult<void>> deleteAll(String boxName, Iterable<String> keys) {
    return _scheduleOnBox<void>(boxName, (box) async {
      await box.deleteAll(keys);
      return StorageResult.emptySuccess();
    });
  }

  @override
  Future<StorageResult<void>> clear(String boxName) {
    return _scheduleOnBox<void>(boxName, (box) async {
      await box.clear();
      return StorageResult.emptySuccess();
    });
  }

  @override
  Future<StorageResult<List<T>>> query(
    String boxName, {
    StoragePredicate<T>? where,
    Comparator<T>? sort,
    int? limit,
  }) {
    return _scheduleOnBox<List<T>>(boxName, (box) async {
      Iterable<T> values = box.values;
      if (where != null) {
        values = values.where(where);
      }
      final list = values.toList(growable: false);
      if (sort != null) {
        list.sort(sort);
      }
      if (limit != null && limit < list.length) {
        return StorageResult.success(list.sublist(0, limit));
      }
      return StorageResult.success(list);
    });
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;

    for (final box in _boxCache.values) {
      if (box.isOpen) {
        await box.close();
      }
    }

    _boxCache.clear();
    _boxOpenFutures.clear();
    _boxQueues.clear();
  }

  StorageFailure? _validateValue(T value, SchemaValidator<T>? validator) {
    final failure = validator?.call(value);
    if (failure != null) {
      return failure;
    }
    return null;
  }

  Future<StorageResult<R>> _scheduleOnBox<R>(
    String boxName,
    Future<StorageResult<R>> Function(Box<T> box) action,
  ) async {
    if (_disposed) {
      return StorageResult.fromFailure(
        StorageFailure(
          type: StorageFailureType.concurrency,
          message: 'Storage service disposed',
        ),
      );
    }

    final queue = _boxQueues.putIfAbsent(boxName, () => _AsyncQueue());
    return queue.enqueue(() async {
      final boxResult = await _resolveBox(boxName);
      if (!boxResult.isSuccess) {
        return StorageResult.fromFailure(boxResult.failure!);
      }

      try {
        return await action(boxResult.data!);
      } catch (error, stackTrace) {
        _logger(
          'Hive operation failed on $boxName',
          error: error,
          stackTrace: stackTrace,
        );
        return StorageResult.fromFailure(
          _mapFailure(
            'Hive operation failed on $boxName',
            StorageFailureType.hive,
            error,
            stackTrace,
          ),
        );
      }
    });
  }

  Future<StorageResult<Box<T>>> _resolveBox(String boxName) async {
    final existing = _boxCache[boxName];
    if (existing != null && existing.isOpen) {
      return StorageResult.success(existing);
    }

    final openResult = await openBox(boxName);
    if (!openResult.isSuccess) {
      return StorageResult.fromFailure(openResult.failure!);
    }

    final reloaded = _boxCache[boxName];
    if (reloaded == null || !reloaded.isOpen) {
      return StorageResult.fromFailure(
        StorageFailure(
          type: StorageFailureType.boxUnavailable,
          message: 'Hive box $boxName could not be resolved after opening',
        ),
      );
    }

    return StorageResult.success(reloaded);
  }

  StorageFailure _mapFailure(
    String message,
    StorageFailureType type,
    Object error,
    StackTrace stackTrace,
  ) {
    return StorageFailure(
      type: type,
      message: message,
      cause: error,
      stackTrace: stackTrace,
    );
  }
}

class _AsyncQueue {
  Future<void> _tail = Future.value();

  Future<R> enqueue<R>(Future<R> Function() task) {
    final Future<R> result = _tail.then((_) => task());
    _tail = result.then((_) {}, onError: (_, __) {});
    return result;
  }
}

void _silentLogger(String message, {Object? error, StackTrace? stackTrace}) {}
