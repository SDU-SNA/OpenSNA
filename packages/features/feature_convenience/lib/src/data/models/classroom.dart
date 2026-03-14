import 'package:json_annotation/json_annotation.dart';

part 'classroom.g.dart';

/// 教室模型
@JsonSerializable()
class Classroom {
  final String id;
  final String name;
  final String building;
  final int capacity;
  final String type;

  /// 当前是否空闲
  final bool isAvailable;

  /// 下次有课时间（null 表示今天没课了）
  final DateTime? nextOccupiedTime;

  /// 当前课程名称（如果有课）
  final String? currentCourse;

  const Classroom({
    required this.id,
    required this.name,
    required this.building,
    required this.capacity,
    required this.type,
    required this.isAvailable,
    this.nextOccupiedTime,
    this.currentCourse,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) =>
      _$ClassroomFromJson(json);
  Map<String, dynamic> toJson() => _$ClassroomToJson(this);

  String get typeText {
    switch (type) {
      case 'lecture':
        return '普通教室';
      case 'lab':
        return '实验室';
      case 'seminar':
        return '研讨室';
      case 'computer':
        return '机房';
      default:
        return '教室';
    }
  }
}
