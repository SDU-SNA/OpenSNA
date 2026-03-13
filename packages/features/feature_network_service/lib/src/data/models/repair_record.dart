import 'package:json_annotation/json_annotation.dart';

part 'repair_record.g.dart';

/// 故障报修记录模型
@JsonSerializable()
class RepairRecord {
  /// 报修ID
  final String id;

  /// 报修标题
  final String title;

  /// 问题描述
  final String description;

  /// 故障类型（network_down, slow_speed, connection_issue, other）
  final String type;

  /// 报修位置
  final String location;

  /// 联系方式
  final String contact;

  /// 图片URL列表
  final List<String> images;

  /// 报修状态（pending, processing, resolved, closed）
  final String status;

  /// 优先级（low, normal, high, urgent）
  final String priority;

  /// 报修时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;

  /// 处理人员
  final String? handler;

  /// 处理备注
  final String? handlerNote;

  /// 解决时间
  final DateTime? resolvedAt;

  /// 用户评价（1-5星）
  final int? rating;

  /// 用户评价内容
  final String? ratingComment;

  const RepairRecord({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    required this.contact,
    required this.images,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.handler,
    this.handlerNote,
    this.resolvedAt,
    this.rating,
    this.ratingComment,
  });

  /// 从 JSON 创建
  factory RepairRecord.fromJson(Map<String, dynamic> json) =>
      _$RepairRecordFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$RepairRecordToJson(this);

  /// 复制并修改部分字段
  RepairRecord copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? location,
    String? contact,
    List<String>? images,
    String? status,
    String? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? handler,
    String? handlerNote,
    DateTime? resolvedAt,
    int? rating,
    String? ratingComment,
  }) {
    return RepairRecord(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      location: location ?? this.location,
      contact: contact ?? this.contact,
      images: images ?? this.images,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      handler: handler ?? this.handler,
      handlerNote: handlerNote ?? this.handlerNote,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      rating: rating ?? this.rating,
      ratingComment: ratingComment ?? this.ratingComment,
    );
  }

  /// 故障类型文本
  String get typeText {
    switch (type) {
      case 'network_down':
        return '网络断开';
      case 'slow_speed':
        return '网速慢';
      case 'connection_issue':
        return '连接问题';
      case 'other':
        return '其他';
      default:
        return '未知';
    }
  }

  /// 状态文本
  String get statusText {
    switch (status) {
      case 'pending':
        return '待处理';
      case 'processing':
        return '处理中';
      case 'resolved':
        return '已解决';
      case 'closed':
        return '已关闭';
      default:
        return '未知';
    }
  }

  /// 优先级文本
  String get priorityText {
    switch (priority) {
      case 'low':
        return '低';
      case 'normal':
        return '普通';
      case 'high':
        return '高';
      case 'urgent':
        return '紧急';
      default:
        return '未知';
    }
  }

  /// 是否待处理
  bool get isPending => status == 'pending';

  /// 是否处理中
  bool get isProcessing => status == 'processing';

  /// 是否已解决
  bool get isResolved => status == 'resolved';

  /// 是否已关闭
  bool get isClosed => status == 'closed';

  /// 是否可以评价
  bool get canRate => isResolved && rating == null;

  /// 处理时长（分钟）
  int? get processingDuration {
    if (resolvedAt == null) return null;
    return resolvedAt!.difference(createdAt).inMinutes;
  }

  /// 格式化的处理时长
  String? get formattedProcessingDuration {
    final duration = processingDuration;
    if (duration == null) return null;

    if (duration < 60) {
      return '$duration分钟';
    } else if (duration < 1440) {
      final hours = duration ~/ 60;
      final minutes = duration % 60;
      return '$hours小时${minutes}分钟';
    } else {
      final days = duration ~/ 1440;
      final hours = (duration % 1440) ~/ 60;
      return '$days天${hours}小时';
    }
  }

  @override
  String toString() {
    return 'RepairRecord(id: $id, title: $title, type: $type, '
        'status: $status, priority: $priority, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RepairRecord &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.type == type &&
        other.location == location &&
        other.contact == contact &&
        other.images == images &&
        other.status == status &&
        other.priority == priority &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.handler == handler &&
        other.handlerNote == handlerNote &&
        other.resolvedAt == resolvedAt &&
        other.rating == rating &&
        other.ratingComment == ratingComment;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      type,
      location,
      contact,
      images,
      status,
      priority,
      createdAt,
      updatedAt,
      handler,
      handlerNote,
      resolvedAt,
      rating,
      ratingComment,
    );
  }
}
