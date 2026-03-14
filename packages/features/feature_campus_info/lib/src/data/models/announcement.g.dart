// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      summary: json['summary'] as String,
      category: json['category'] as String,
      author: json['author'] as String,
      coverImage: json['coverImage'] as String?,
      isPinned: json['isPinned'] as bool,
      isRead: json['isRead'] as bool,
      viewCount: (json['viewCount'] as num).toInt(),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'summary': instance.summary,
      'category': instance.category,
      'author': instance.author,
      'coverImage': instance.coverImage,
      'isPinned': instance.isPinned,
      'isRead': instance.isRead,
      'viewCount': instance.viewCount,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'tags': instance.tags,
    };
