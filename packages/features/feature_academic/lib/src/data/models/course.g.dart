// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      id: json['id'] as String,
      name: json['name'] as String,
      teacher: json['teacher'] as String,
      location: json['location'] as String,
      credit: json['credit'] as String,
      weekday: (json['weekday'] as num).toInt(),
      startSection: (json['startSection'] as num).toInt(),
      sectionCount: (json['sectionCount'] as num).toInt(),
      weeks: (json['weeks'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      color: json['color'] as String,
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'teacher': instance.teacher,
      'location': instance.location,
      'credit': instance.credit,
      'weekday': instance.weekday,
      'startSection': instance.startSection,
      'sectionCount': instance.sectionCount,
      'weeks': instance.weeks,
      'color': instance.color,
    };
