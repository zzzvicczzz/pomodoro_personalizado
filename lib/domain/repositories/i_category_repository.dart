/// Contrato (interfaz) para el repositorio de categorías.
///
/// Define únicamente los métodos necesarios para acceder y modificar
/// entidades `Category` en la capa de dominio. No contiene implementaciones.
import '../../models/category.dart';

abstract class CategoryRepository {
  /// Recupera todas las categorías.
  Future<List<Category>> getAllCategories();

  /// Guarda o actualiza una categoría.
  Future<void> saveCategory(Category model);

  /// Elimina una categoría por su identificador.
  Future<void> deleteCategory(String id);
}
