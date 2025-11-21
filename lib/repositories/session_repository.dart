import '../domain/repositories/i_session_repository.dart';
import '../infrastructure/serializers.dart';
import '../models/session.dart';
import '../services/local_storage_service.dart';

/// Implementación concreta de [SessionRepository] respaldada por Hive
/// mediante [ILocalStorageService]. Se limita a operaciones CRUD simples
/// sin exponer lógica de negocio.
class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(this.storage);

  final ILocalStorageService<Map<String, dynamic>> storage;

  static const String _boxName = 'sessions';

  @override
  Future<List<Session>> getAllSessions() async {
    final result = await storage.getAll(_boxName);
    if (!result.isSuccess || result.data == null) {
      return const <Session>[];
    }

    return deserializeSessions(result.data);
  }

  @override
  Future<Session?> getSessionById(String id) async {
    if (id.trim().isEmpty) {
      return null;
    }

    final result = await storage.get(_boxName, id);
    if (!result.isSuccess) {
      return null;
    }

    return deserializeSession(result.data);
  }

  @override
  Future<void> saveSession(Session model) async {
    _validateSession(model);
    await storage.put(_boxName, key: model.id, value: serializeSession(model));
  }

  @override
  Future<void> deleteSession(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError('El identificador de sesión es obligatorio.');
    }

    final existing = await storage.get(_boxName, id);
    if (!existing.isSuccess || existing.data == null) {
      throw StateError('No existe una sesión con el id proporcionado.');
    }

    await storage.delete(_boxName, id);
  }

  void _validateSession(Session model) {
    if (model.id.trim().isEmpty) {
      throw ArgumentError('Las sesiones deben tener un identificador.');
    }
    if (model.categoryId.trim().isEmpty) {
      throw ArgumentError('Las sesiones deben incluir una categoría asociada.');
    }
    if (model.duration <= 0) {
      throw ArgumentError('La duración de la sesión debe ser mayor a cero.');
    }
    if (!model.endTime.isAfter(model.startTime)) {
      throw ArgumentError(
        'La hora de fin debe ser posterior a la hora de inicio.',
      );
    }
  }
}
