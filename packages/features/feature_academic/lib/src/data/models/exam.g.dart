// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exam _$ExamFromJson(Map<String, dynamic> json) => Exam(
      id: json['id'] as String,
      courseName: json['courseName'] as String,
      courseCode: json['courseCode'] as String,
      location: json['location'] as String,
      seatNumber: json['seatNumber'] as String,
      examTime: DateTime.parse(json['examTime'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$ExamToJson(Exam instance) => <String, dynamic>{
      'id': instance.id,
      'courseName': instance.courseName,
      'courseCode': instance.courseCode,
      'location': instance.location,
      'seatNumber': instance.seatNumber,
      'examTime': instance.examTime.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'type': instance.type,
    };
