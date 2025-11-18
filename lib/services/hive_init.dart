import 'dart:async';

import 'package:hive/hive.dart';

import 'local_storage_service.dart';

typedef HiveInitializer = Future<void> Function();
typedef HiveAdapterRegistrar = void Function();
typedef HiveMigrationRunner = Future<void> Function(HiveInterface hive);

class HiveMigration {
  const HiveMigration({
    required this.id,
    required this.version,
    required this.run,
  });

  final String id;
  final int version;
  final HiveMigrationRunner run;
}

class HiveInit {
  HiveInit({
    required HiveInterface hive,
    required HiveInitializer initializer,
    required HiveAdapterRegistrar registerAdapters,
    List<HiveMigration> migrations = const [],
    StorageLogger? logger,
    this.metadataBox = '__hive_meta__',
  }) : _hive = hive,
       _initializer = initializer,
       _registerAdapters = registerAdapters,
       _migrations = migrations,
       _logger = logger ?? _silentLogger;

  final HiveInterface _hive;
  final HiveInitializer _initializer;
  final HiveAdapterRegistrar _registerAdapters;
  final List<HiveMigration> _migrations;
  final StorageLogger _logger;
  final String metadataBox;

  bool _initialized = false;
  Future<void>? _initFuture;

  Future<void> ensureInitialized() async {
    if (_initialized) return;

    _initFuture ??= _initialize();

    try {
      await _initFuture;
      _initialized = true;
    } catch (error, stackTrace) {
      _initFuture = null;
      _logger(
        'Failed to initialize Hive',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> _initialize() async {
    await _initializer();
    _registerAdapters();
    await _runMigrations();
  }

  Future<void> _runMigrations() async {
    if (_migrations.isEmpty) {
      return;
    }

    final ordered = [..._migrations]
      ..sort((a, b) => a.version.compareTo(b.version));

    Box<int>? metaBox;
    try {
      metaBox = await _hive.openBox<int>(metadataBox);
      for (final migration in ordered) {
        final appliedVersion = metaBox.get(migration.id, defaultValue: 0) ?? 0;
        if (migration.version <= appliedVersion) {
          continue;
        }
        _logger('Running Hive migration ${migration.id}');
        await migration.run(_hive);
        await metaBox.put(migration.id, migration.version);
      }
    } on HiveError catch (error, stackTrace) {
      _logger('Hive migration failed', error: error, stackTrace: stackTrace);
      rethrow;
    } finally {
      if (metaBox != null && metaBox.isOpen) {
        await metaBox.close();
      }
    }
  }
}

void _silentLogger(String message, {Object? error, StackTrace? stackTrace}) {}
