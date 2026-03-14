// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Classroom _$ClassroomFromJson(Map<String, dynamic> json) => Classroom(
      id: json['id'] as String,
      name: json['name'] as String,
      building: json['building'] as String,
      capacity: (json['capacity'] as num).toInt(),
      type: json['type'] as String,
      isAvailable: json['isAvailable'] as bool,
      nextOccupiedTime: json['nextOccupiedTime'] == null
          ? null
          : DateTime.parse(json['nextOccupiedTime'] as String),
      currentCourse: json['currentCourse'] as String?,
    );

Map<String, dynamic> _$ClassroomToJson(Classroom instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'building': instance.building,
      'capacity': instance.capacity,
      'type': instance.type,
      'isAvailable': instance.isAvailable,
      'nextOccupiedTime': instance.nextOccupiedTime?.toIso8601String(),
      'currentCourse': instance.currentCourse,
    };
