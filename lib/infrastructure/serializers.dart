import '../domain/models/app_settings_model.dart';
import '../models/category.dart';
import '../models/session.dart';
import '../models/stats.dart';
import 'dto/category_dto.dart';
import 'dto/session_dto.dart';
import 'dto/settings_dto.dart';
import 'dto/stats_dto.dart';

/// Serializadores centrales para mantener un único punto de conversión entre
/// los modelos de dominio y los `Map<String, dynamic>` usados en persistencia.

// ---------------------------------------------------------------------------
// Sessions
// ---------------------------------------------------------------------------

List<Session> deserializeSessions(List<Map<String, dynamic>>? raw) {
  if (raw == null) {
    return const <Session>[];
  }
  return SessionDTO.fromMapList(
    raw,
  ).map((dto) => dto.toDomain()).toList(growable: false);
}

Session? deserializeSession(Map<String, dynamic>? raw) {
  if (raw == null) {
    return null;
  }
  return SessionDTO.fromMap(raw).toDomain();
}

Map<String, dynamic> serializeSession(Session session) {
  return SessionDTO.fromDomain(session).toMap();
}

List<Map<String, dynamic>> serializeSessionList(Iterable<Session> sessions) {
  return SessionDTO.toMapList(sessions.map(SessionDTO.fromDomain));
}

// ---------------------------------------------------------------------------
// Categories
// ---------------------------------------------------------------------------

List<Category> deserializeCategories(List<Map<String, dynamic>>? raw) {
  if (raw == null) {
    return const <Category>[];
  }
  return CategoryDTO.fromMapList(
    raw,
  ).map((dto) => dto.toDomain()).toList(growable: false);
}

Category? deserializeCategory(Map<String, dynamic>? raw) {
  if (raw == null) {
    return null;
  }
  return CategoryDTO.fromMap(raw).toDomain();
}

Map<String, dynamic> serializeCategory(Category category) {
  return CategoryDTO.fromDomain(category).toMap();
}

List<Map<String, dynamic>> serializeCategoryList(
  Iterable<Category> categories,
) {
  return CategoryDTO.toMapList(categories.map(CategoryDTO.fromDomain));
}

// ---------------------------------------------------------------------------
// Settings
// ---------------------------------------------------------------------------

AppSettingsModel? deserializeSettings(Map<String, dynamic>? raw) {
  if (raw == null) {
    return null;
  }
  return SettingsDTO.fromMap(raw).toDomain();
}

Map<String, dynamic> serializeSettings(AppSettingsModel model) {
  return SettingsDTO.fromDomain(model).toMap();
}

// ---------------------------------------------------------------------------
// Stats
// ---------------------------------------------------------------------------

Stats? deserializeStats(Map<String, dynamic>? raw) {
  if (raw == null) {
    return null;
  }
  return StatsDTO.fromMap(raw).toDomain();
}

Map<String, dynamic> serializeStats(Stats stats) {
  return StatsDTO.fromDomain(stats).toMap();
}

List<Stats> deserializeStatsList(List<Map<String, dynamic>>? raw) {
  if (raw == null) {
    return const <Stats>[];
  }
  return StatsDTO.fromMapList(
    raw,
  ).map((dto) => dto.toDomain()).toList(growable: false);
}
