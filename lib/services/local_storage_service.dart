import 'dart:async';

/// Signature used to validate the schema of an entity before persisting it.
typedef SchemaValidator<T> = StorageFailure? Function(T value);

/// Signature used to filter/query entries from a storage box.
typedef StoragePredicate<T> = bool Function(T value);

/// Signature used to log storage-level information and failures.
typedef StorageLogger =
    void Function(String message, {Object? error, StackTrace? stackTrace});

/// Represents well-known storage failure categories.
enum StorageFailureType {
  notInitialized,
  boxUnavailable,
  notFound,
  validation,
  migration,
  concurrency,
  hive,
  unknown,
}

/// Domain-specific failure description for storage operations.
class StorageFailure {
  const StorageFailure({
    required this.type,
    required this.message,
    this.cause,
    this.stackTrace,
  });

  final StorageFailureType type;
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;
}

/// Result wrapper that encodes either the expected value or a failure.
class StorageResult<T> {
  const StorageResult._({this.data, this.failure});

  final T? data;
  final StorageFailure? failure;

  bool get isSuccess => failure == null;

  static StorageResult<T> success<T>(T data) => StorageResult._(data: data);

  static StorageResult<T> emptySuccess<T>() => const StorageResult._();

  static StorageResult<T> fromFailure<T>(StorageFailure failure) =>
      StorageResult._(failure: failure);
}

/// Contract for a generic local storage service backed by Hive boxes.
abstract class ILocalStorageService<T> {
  /// Ensures the underlying storage layer is initialized.
  Future<StorageResult<void>> ensureInitialized();

  /// Opens (or reuses) the box identified by [boxName].
  Future<StorageResult<void>> openBox(String boxName, {bool preload = false});

  /// Closes the in-memory reference for [boxName].
  Future<StorageResult<void>> closeBox(String boxName);

  /// Returns whether [boxName] is currently open.
  Future<StorageResult<bool>> isBoxOpen(String boxName);

  /// Retrieves a single entry identified by [key].
  Future<StorageResult<T?>> get(String boxName, String key);

  /// Retrieves all entries currently persisted in [boxName].
  Future<StorageResult<List<T>>> getAll(String boxName);

  /// Persists a single entity using the provided [key].
  Future<StorageResult<void>> put(
    String boxName, {
    required String key,
    required T value,
    SchemaValidator<T>? validator,
  });

  /// Persists a batch of entities atomically.
  Future<StorageResult<void>> putAll(
    String boxName, {
    required Map<String, T> values,
    SchemaValidator<T>? validator,
  });

  /// Removes the entity identified by [key].
  Future<StorageResult<void>> delete(String boxName, String key);

  /// Removes a batch of entities identified by [keys].
  Future<StorageResult<void>> deleteAll(String boxName, Iterable<String> keys);

  /// Clears the entire box.
  Future<StorageResult<void>> clear(String boxName);

  /// Query helper that optionally filters, sorts and limits the results.
  Future<StorageResult<List<T>>> query(
    String boxName, {
    StoragePredicate<T>? where,
    Comparator<T>? sort,
    int? limit,
  });

  /// Releases resources held by the service.
  Future<void> dispose();
}
