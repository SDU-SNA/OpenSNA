// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repair_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RepairRecord _$RepairRecordFromJson(Map<String, dynamic> json) => RepairRecord(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      location: json['location'] as String,
      contact: json['contact'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      status: json['status'] as String,
      priority: json['priority'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      handler: json['handler'] as String?,
      handlerNote: json['handlerNote'] as String?,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
      rating: (json['rating'] as num?)?.toInt(),
      ratingComment: json['ratingComment'] as String?,
    );

Map<String, dynamic> _$RepairRecordToJson(RepairRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'location': instance.location,
      'contact': instance.contact,
      'images': instance.images,
      'status': instance.status,
      'priority': instance.priority,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'handler': instance.handler,
      'handlerNote': instance.handlerNote,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'rating': instance.rating,
      'ratingComment': instance.ratingComment,
    };
