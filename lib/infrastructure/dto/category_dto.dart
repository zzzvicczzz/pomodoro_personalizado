import '../../models/category.dart';

/// DTO para la entidad [Category], responsable de la serialización hacia
/// mapas y la restauración segura desde datos dinámicos.
class CategoryDTO {
  const CategoryDTO({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    this.description,
    this.isPinned,
  });

  final String id;
  final String name;
  final int color;
  final String icon;
  final String? description;
  final bool? isPinned;

  factory CategoryDTO.fromMap(Map<String, dynamic>? map) {
    final data = _ensureMap(map);
    return CategoryDTO(
      id: _readString(data, 'id', _kFallbackId),
      name: _readString(data, 'name', _kFallbackName),
      color: _readInt(data, 'color', _kDefaultColor),
      icon: _readString(data, 'icon', _kFallbackIcon),
      description: _readStringOrNull(data, 'description'),
      isPinned: _readBoolOrNull(data, 'isPinned'),
    );
  }

  factory CategoryDTO.fromDomain(Category category) {
    return CategoryDTO(
      id: category.id,
      name: category.name,
      color: category.color,
      icon: category.icon,
    );
  }

  Category toDomain() {
    return Category(id: id, name: name, color: color, icon: icon);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
      if (description != null) 'description': description,
      if (isPinned != null) 'isPinned': isPinned,
    };
  }

  CategoryDTO copyWith({
    String? id,
    String? name,
    int? color,
    String? icon,
    String? description,
    bool? isPinned,
  }) {
    return CategoryDTO(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  static List<CategoryDTO> fromMapList(dynamic raw) {
    if (raw is Iterable) {
      return raw
          .map((entry) => CategoryDTO.fromMap(_ensureMap(entry)))
          .toList(growable: false);
    }
    return const <CategoryDTO>[];
  }

  static List<Map<String, dynamic>> toMapList(Iterable<CategoryDTO> list) {
    return list.map((dto) => dto.toMap()).toList(growable: false);
  }

  @override
  String toString() => 'CategoryDTO(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CategoryDTO &&
            other.id == id &&
            other.name == name &&
            other.color == color &&
            other.icon == icon &&
            other.description == description &&
            other.isPinned == isPinned);
  }

  @override
  int get hashCode => Object.hash(id, name, color, icon, description, isPinned);

  static Map<String, dynamic> _ensureMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, dynamic v) => MapEntry(key.toString(), v));
    }
    return <String, dynamic>{};
  }

  static String _readString(
    Map<String, dynamic> data,
    String key,
    String fallback,
  ) {
    final value = data[key];
    if (value is String && value.isNotEmpty) {
      return value;
    }
    if (value != null) {
      return value.toString();
    }
    return fallback;
  }

  static String? _readStringOrNull(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null) {
      return null;
    }
    if (value is String && value.isNotEmpty) {
      return value;
    }
    return value.toString();
  }

  static int _readInt(Map<String, dynamic> data, String key, int fallback) {
    final value = data[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }
    return fallback;
  }

  static bool? _readBoolOrNull(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.toLowerCase();
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }
    return null;
  }

  static const String _kFallbackId = 'category_undefined';
  static const String _kFallbackName = 'Unnamed Category';
  static const String _kFallbackIcon = 'default';
  static const int _kDefaultColor = 0xFF000000;
}
