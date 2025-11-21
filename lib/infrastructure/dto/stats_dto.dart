import '../../models/stats.dart';

/// DTO para la entidad [Stats], encargado de la serialización segura y de la
/// compatibilidad entre versiones.
class StatsDTO {
  const StatsDTO({
    required this.totalSessions,
    required this.totalCycles,
    required this.productiveMinutes,
    required this.totalBreaks,
    required this.lastUpdated,
    this.categoryMinutes,
    this.weeklyTrends,
  });

  final int totalSessions;
  final int totalCycles;
  final int productiveMinutes;
  final int totalBreaks;
  final DateTime lastUpdated;
  final Map<String, int>? categoryMinutes;
  final List<int>? weeklyTrends;

  factory StatsDTO.fromMap(Map<String, dynamic>? map) {
    final data = _ensureMap(map);
    return StatsDTO(
      totalSessions: _readInt(data, 'totalSessions'),
      totalCycles: _readInt(data, 'totalCycles'),
      productiveMinutes: _readInt(data, 'productiveMinutes'),
      totalBreaks: _readInt(data, 'totalBreaks'),
      lastUpdated: _readDate(data, 'lastUpdated'),
      categoryMinutes: _readCategoryMap(data['categoryMinutes']),
      weeklyTrends: _readIntList(data['weeklyTrends']),
    );
  }

  factory StatsDTO.fromDomain(Stats stats) {
    return StatsDTO(
      totalSessions: stats.totalSessions,
      totalCycles: stats.totalCycles,
      productiveMinutes: stats.productiveMinutes,
      totalBreaks: stats.totalBreaks,
      lastUpdated: stats.lastUpdated,
    );
  }

  Stats toDomain() {
    return Stats(
      totalSessions: totalSessions,
      totalCycles: totalCycles,
      productiveMinutes: productiveMinutes,
      totalBreaks: totalBreaks,
      lastUpdated: lastUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalSessions': totalSessions,
      'totalCycles': totalCycles,
      'productiveMinutes': productiveMinutes,
      'totalBreaks': totalBreaks,
      'lastUpdated': lastUpdated.toIso8601String(),
      if (categoryMinutes != null) 'categoryMinutes': categoryMinutes,
      if (weeklyTrends != null) 'weeklyTrends': weeklyTrends,
    };
  }

  StatsDTO copyWith({
    int? totalSessions,
    int? totalCycles,
    int? productiveMinutes,
    int? totalBreaks,
    DateTime? lastUpdated,
    Map<String, int>? categoryMinutes,
    List<int>? weeklyTrends,
  }) {
    return StatsDTO(
      totalSessions: totalSessions ?? this.totalSessions,
      totalCycles: totalCycles ?? this.totalCycles,
      productiveMinutes: productiveMinutes ?? this.productiveMinutes,
      totalBreaks: totalBreaks ?? this.totalBreaks,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      categoryMinutes: categoryMinutes ?? this.categoryMinutes,
      weeklyTrends: weeklyTrends ?? this.weeklyTrends,
    );
  }

  static List<StatsDTO> fromMapList(dynamic raw) {
    if (raw is Iterable) {
      return raw
          .map((entry) => StatsDTO.fromMap(_ensureMap(entry)))
          .toList(growable: false);
    }
    return const <StatsDTO>[];
  }

  static List<Map<String, dynamic>> toMapList(Iterable<StatsDTO> list) {
    return list.map((dto) => dto.toMap()).toList(growable: false);
  }

  @override
  String toString() => 'StatsDTO(totalSessions: $totalSessions)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StatsDTO &&
            other.totalSessions == totalSessions &&
            other.totalCycles == totalCycles &&
            other.productiveMinutes == productiveMinutes &&
            other.totalBreaks == totalBreaks &&
            other.lastUpdated == lastUpdated &&
            _mapEquals(other.categoryMinutes, categoryMinutes) &&
            _listEquals(other.weeklyTrends, weeklyTrends));
  }

  @override
  int get hashCode => Object.hash(
    totalSessions,
    totalCycles,
    productiveMinutes,
    totalBreaks,
    lastUpdated,
    _mapHash(categoryMinutes),
    _listHash(weeklyTrends),
  );

  static Map<String, dynamic> _ensureMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, dynamic v) => MapEntry(key.toString(), v));
    }
    return <String, dynamic>{};
  }

  static int _readInt(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static DateTime _readDate(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? _kEpoch;
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true).toLocal();
    }
    return _kEpoch;
  }

  static Map<String, int>? _readCategoryMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value.map((key, dynamic v) => MapEntry(key, _toInt(v)));
    }
    if (value is Map) {
      final result = <String, int>{};
      value.forEach((key, dynamic v) {
        result[key.toString()] = _toInt(v);
      });
      return result;
    }
    return null;
  }

  static List<int>? _readIntList(dynamic value) {
    if (value is Iterable) {
      return value.map(_toInt).toList(growable: false);
    }
    return null;
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static bool _mapEquals(Map<String, int>? a, Map<String, int>? b) {
    if (identical(a, b)) {
      return true;
    }
    if (a == null || b == null) {
      return false;
    }
    if (a.length != b.length) {
      return false;
    }
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) {
        return false;
      }
    }
    return true;
  }

  static bool _listEquals(List<int>? a, List<int>? b) {
    if (identical(a, b)) {
      return true;
    }
    if (a == null || b == null) {
      return false;
    }
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i += 1) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  static int _mapHash(Map<String, int>? map) {
    if (map == null) {
      return 0;
    }
    return Object.hashAll(map.entries);
  }

  static int _listHash(List<int>? list) {
    if (list == null) {
      return 0;
    }
    return Object.hashAll(list);
  }

  static final DateTime _kEpoch = DateTime.fromMillisecondsSinceEpoch(
    0,
    isUtc: true,
  ).toLocal();
}
