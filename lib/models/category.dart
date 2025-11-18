/// Modelo que representa una categoría de sesión Pomodoro.
import '../config/constants.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

/// Adaptador Hive y modelo que representa una categoría de sesión Pomodoro.
@HiveType(typeId: 0)
class Category {
  /// Identificador único de la categoría.
  @HiveField(0)
  final String id;

  /// Nombre descriptivo de la categoría (ej: Trabajo, Estudio, Descanso).
  @HiveField(1)
  final String name;

  /// Color asociado a la categoría para la UI.
  @HiveField(2)
  final int color;

  /// Icono representativo de la categoría.
  @HiveField(3)
  final String icon;

  /// Constructor de la clase Category.
  Category({required this.id, required this.name, int? color, String? icon})
    : color = color ?? AppColors.work.value,
      icon = icon ?? AppIcons.work;

  /// Método para copiar la categoría con cambios.
  Category copyWith({String? id, String? name, int? color, String? icon}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

  /// Conversión a Map para persistencia.
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'color': color, 'icon': icon};
  }

  /// Creación desde Map (persistencia).
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      color: map['color'] as int,
      icon: map['icon'] as String,
    );
  }
}
