import 'package:json_annotation/json_annotation.dart';

part 'grade.g.dart';

/// 成绩模型
@JsonSerializable()
class Grade {
  final String id;
  final String courseName;
  final String courseCode;
  final String credit;
  final String semester;

  /// 成绩（可能是数字或等级如 A/B/C）
  final String score;

  /// 绩点
  final double? gpa;

  /// 成绩类型（normal/retake/makeup）
  final String type;

  const Grade({
    required this.id,
    required this.courseName,
    required this.courseCode,
    required this.credit,
    required this.semester,
    required this.score,
    this.gpa,
    required this.type,
  });

  factory Grade.fromJson(Map<String, dynamic> json) => _$GradeFromJson(json);
  Map<String, dynamic> toJson() => _$GradeToJson(this);

  /// 是否通过
  bool get isPassed {
    final numScore = double.tryParse(score);
    if (numScore != null) return numScore >= 60;
    return score != 'F' && score != '不及格';
  }

  /// 成绩等级颜色标识
  String get level {
    final numScore = double.tryParse(score);
    if (numScore == null) return score;
    if (numScore >= 90) return 'A';
    if (numScore >= 80) return 'B';
    if (numScore >= 70) return 'C';
    if (numScore >= 60) return 'D';
    return 'F';
  }

  String get typeText {
    switch (type) {
      case 'retake':
        return '重修';
      case 'makeup':
        return '补考';
      default:
        return '正常';
    }
  }
}
