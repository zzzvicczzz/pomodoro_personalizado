/// Contrato (interfaz) para el repositorio de sesiones.
///
/// Define únicamente los métodos necesarios para acceder y modificar
/// entidades `Session` en la capa de dominio. No contiene implementaciones.
import '../../models/session.dart';

abstract class SessionRepository {
  /// Recupera todas las sesiones almacenadas.
  Future<List<Session>> getAllSessions();

  /// Recupera una sesión por su identificador.
  Future<Session?> getSessionById(String id);

  /// Guarda o actualiza una sesión.
  Future<void> saveSession(Session model);

  /// Elimina una sesión por su identificador.
  Future<void> deleteSession(String id);
}
