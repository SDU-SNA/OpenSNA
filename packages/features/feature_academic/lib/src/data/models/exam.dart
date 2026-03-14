import 'package:json_annotation/json_annotation.dart';

part 'exam.g.dart';

/// 考试安排模型
@JsonSerializable()
class Exam {
  final String id;
  final String courseName;
  final String courseCode;
  final String location;
  final String seatNumber;
  final DateTime examTime;
  final int durationMinutes;
  final String type;

  const Exam({
    required this.id,
    required this.courseName,
    required this.courseCode,
    required this.location,
    required this.seatNumber,
    required this.examTime,
    required this.durationMinutes,
    required this.type,
  });

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);
  Map<String, dynamic> toJson() => _$ExamToJson(this);

  DateTime get endTime =>
      examTime.add(Duration(minutes: durationMinutes));

  /// 距离考试的天数（负数表示已过）
  int get daysUntilExam =>
      examTime.difference(DateTime.now()).inDays;

  bool get isUpcoming => examTime.isAfter(DateTime.now());

  bool get isToday {
    final now = DateTime.now();
    return examTime.year == now.year &&
        examTime.month == now.month &&
        examTime.day == now.day;
  }

  String get typeText {
    switch (type) {
      case 'final':
        return '期末考试';
      case 'midterm':
        return '期中考试';
      case 'makeup':
        return '补考';
      default:
        return '考试';
    }
  }
}
