import 'package:json_annotation/json_annotation.dart';

part 'announcement.g.dart';

/// 公告模型
@JsonSerializable()
class Announcement {
  final String id;
  final String title;
  final String content;
  final String summary;
  final String category;
  final String author;
  final String? coverImage;
  final bool isPinned;
  final bool isRead;
  final int viewCount;
  final DateTime publishedAt;
  final DateTime updatedAt;
  final List<String> tags;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.category,
    required this.author,
    this.coverImage,
    required this.isPinned,
    required this.isRead,
    required this.viewCount,
    required this.publishedAt,
    required this.updatedAt,
    required this.tags,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);

  Announcement copyWith({
    String? id,
    String? title,
    String? content,
    String? summary,
    String? category,
    String? author,
    String? coverImage,
    bool? isPinned,
    bool? isRead,
    int? viewCount,
    DateTime? publishedAt,
    DateTime? updatedAt,
    List<String>? tags,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      category: category ?? this.category,
      author: author ?? this.author,
      coverImage: coverImage ?? this.coverImage,
      isPinned: isPinned ?? this.isPinned,
      isRead: isRead ?? this.isRead,
      viewCount: viewCount ?? this.viewCount,
      publishedAt: publishedAt ?? this.publishedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }

  /// 分类文本
  String get categoryText {
    switch (category) {
      case 'notice':
        return '通知';
      case 'news':
        return '新闻';
      case 'activity':
        return '活动';
      case 'maintenance':
        return '维护';
      default:
        return '其他';
    }
  }

  @override
  String toString() =>
      'Announcement(id: $id, title: $title, category: $category)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Announcement && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
