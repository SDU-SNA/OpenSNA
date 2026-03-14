// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Grade _$GradeFromJson(Map<String, dynamic> json) => Grade(
      id: json['id'] as String,
      courseName: json['courseName'] as String,
      courseCode: json['courseCode'] as String,
      credit: json['credit'] as String,
      semester: json['semester'] as String,
      score: json['score'] as String,
      gpa: (json['gpa'] as num?)?.toDouble(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$GradeToJson(Grade instance) => <String, dynamic>{
      'id': instance.id,
      'courseName': instance.courseName,
      'courseCode': instance.courseCode,
      'credit': instance.credit,
      'semester': instance.semester,
      'score': instance.score,
      'gpa': instance.gpa,
      'type': instance.type,
    };
