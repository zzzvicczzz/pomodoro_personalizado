/// Contrato (interfaz) para el repositorio de estadísticas.
///
/// Define únicamente los métodos necesarios para acceder y modificar
/// las `Stats` en la capa de dominio. No contiene implementaciones.
import '../../models/stats.dart';

abstract class StatsRepository {
  /// Recupera las estadísticas agregadas del usuario.
  Future<Stats?> getStats();

  /// Guarda o actualiza las estadísticas.
  Future<void> saveStats(Stats model);
}
