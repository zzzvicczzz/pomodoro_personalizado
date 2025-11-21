## Informe de Progreso – Tarea 6.1

### 1. Resumen de avances
Se han creado las interfaces (contratos) de repositorio solicitadas, ubicadas en `lib/domain/repositories/`:
- `i_session_repository.dart`
- `i_category_repository.dart`
- `i_settings_repository.dart`
- `i_stats_repository.dart`

Cada archivo contiene únicamente la interfaz abstracta correspondiente, las importaciones a los modelos existentes y documentación mínima del contrato. No se realizaron implementaciones ni se modificaron modelos existentes.

### 2. Código entregado
```dart
// lib/domain/repositories/i_session_repository.dart
import '../../models/session.dart';
abstract class SessionRepository {
  Future<List<Session>> getAllSessions();
  Future<Session?> getSessionById(String id);
  Future<void> saveSession(Session model);
  Future<void> deleteSession(String id);
}
```

```dart
// lib/domain/repositories/i_category_repository.dart
import '../../models/category.dart';
abstract class CategoryRepository {
  Future<List<Category>> getAllCategories();
  Future<void> saveCategory(Category model);
  Future<void> deleteCategory(String id);
}
```

```dart
// lib/domain/repositories/i_settings_repository.dart
import '../models/app_settings_model.dart';
abstract class SettingsRepository {
  Future<AppSettingsModel?> loadSettings();
  Future<void> saveSettings(AppSettingsModel model);
}
```

```dart
// lib/domain/repositories/i_stats_repository.dart
import '../../models/stats.dart';
abstract class StatsRepository {
  Future<Stats?> getStats();
  Future<void> saveStats(Stats model);
}
```

### 3. Pendientes o limitaciones
- No hay implementaciones — solo contratos, tal como especifica la tarea.
- Se usaron los modelos tal como existen en el repositorio (`Session`, `Category`, `Stats`, `AppSettingsModel`). Si se exige usar nombres distintos (p. ej. `SessionModel`) deberán mapearse o renombrarse fuera de esta tarea.

### 4. Errores o bloqueos
- No se encontraron bloqueos técnicos. Todas las rutas de importación usan rutas relativas dentro de `lib/` y coinciden con los archivos de modelo existentes.

### 5. Recomendaciones o próximos pasos
- Implementar las clases concretas de repositorio que usen `ILocalStorageService` (T6.3), respetando estos contratos.
- Añadir tests unitarios para cada implementación en `test/repositories/` (T6.4) cuando las implementaciones estén listas.


---

Tarea 6.1 completada.
