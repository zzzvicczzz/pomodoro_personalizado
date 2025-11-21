import '../domain/repositories/i_stats_repository.dart';
import '../infrastructure/serializers.dart';
import '../models/stats.dart';
import '../services/local_storage_service.dart';

/// Implementación de [StatsRepository] que aprovecha
/// [ILocalStorageService] para guardar y recuperar estadísticas agregadas.
class StatsRepositoryImpl implements StatsRepository {
  StatsRepositoryImpl(this.storage);

  final ILocalStorageService<Map<String, dynamic>> storage;

  static const String _boxName = 'stats';
  static const String _entryKey = 'current';

  @override
  Future<Stats?> getStats() async {
    final result = await storage.get(_boxName, _entryKey);
    if (!result.isSuccess) {
      return null;
    }

    return deserializeStats(result.data);
  }

  @override
  Future<void> saveStats(Stats model) async {
    _validateStats(model);
    await storage.put(_boxName, key: _entryKey, value: serializeStats(model));
  }

  void _validateStats(Stats model) {
    if (model.totalSessions < 0 || model.totalCycles < 0) {
      throw ArgumentError(
        'Las estadísticas no pueden contener contadores negativos.',
      );
    }
    if (model.productiveMinutes < 0 || model.totalBreaks < 0) {
      throw ArgumentError(
        'Los acumulados de tiempo o descansos no pueden ser negativos.',
      );
    }
  }
}
