import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

/// 课程模型
@JsonSerializable()
class Course {
  final String id;
  final String name;
  final String teacher;
  final String location;
  final String credit;

  /// 星期几（1=周一，7=周日）
  final int weekday;

  /// 第几节开始（1-based）
  final int startSection;

  /// 占几节课
  final int sectionCount;

  /// 上课周次列表（如 [1,2,3,4,5,6,7,8]）
  final List<int> weeks;

  /// 课程颜色（hex，如 #4A90D9）
  final String color;

  const Course({
    required this.id,
    required this.name,
    required this.teacher,
    required this.location,
    required this.credit,
    required this.weekday,
    required this.startSection,
    required this.sectionCount,
    required this.weeks,
    required this.color,
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);

  /// 结束节次
  int get endSection => startSection + sectionCount - 1;

  /// 是否在指定周上课
  bool isInWeek(int week) => weeks.contains(week);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Course && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
