import '../domain/repositories/i_category_repository.dart';
import '../infrastructure/serializers.dart';
import '../models/category.dart';
import '../services/local_storage_service.dart';

/// Implementación de [CategoryRepository] que persiste categorías en Hive
/// a través de [ILocalStorageService]. Solo gestiona operaciones básicas.
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this.storage);

  final ILocalStorageService<Map<String, dynamic>> storage;

  static const String _boxName = 'categories';

  @override
  Future<List<Category>> getAllCategories() async {
    final result = await storage.getAll(_boxName);
    if (!result.isSuccess || result.data == null) {
      return const <Category>[];
    }

    return deserializeCategories(result.data);
  }

  @override
  Future<void> saveCategory(Category model) async {
    _validateCategory(model);
    await storage.put(_boxName, key: model.id, value: serializeCategory(model));
  }

  @override
  Future<void> deleteCategory(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError('El identificador de la categoría es obligatorio.');
    }

    final existing = await storage.get(_boxName, id);
    if (!existing.isSuccess || existing.data == null) {
      throw StateError('No existe una categoría con el id proporcionado.');
    }

    await storage.delete(_boxName, id);
  }

  void _validateCategory(Category model) {
    if (model.id.trim().isEmpty) {
      throw ArgumentError('Las categorías deben tener un identificador.');
    }
    if (model.name.trim().isEmpty) {
      throw ArgumentError('El nombre de la categoría no puede estar vacío.');
    }
  }
}
