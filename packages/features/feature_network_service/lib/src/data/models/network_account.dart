import 'package:json_annotation/json_annotation.dart';

part 'network_account.g.dart';

/// 网络账号信息模型
@JsonSerializable()
class NetworkAccount {
  /// 账号ID
  final String id;

  /// 用户名
  final String username;

  /// 账号余额（元）
  final double balance;

  /// 已用流量（GB）
  final double usedTraffic;

  /// 总流量（GB）
  final double totalTraffic;

  /// 套餐名称
  final String packageName;

  /// 套餐价格（元/月）
  final double packagePrice;

  /// 到期时间
  final DateTime expireTime;

  /// 账号状态（active: 正常, suspended: 停用, expired: 过期）
  final String status;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;

  const NetworkAccount({
    required this.id,
    required this.username,
    required this.balance,
    required this.usedTraffic,
    required this.totalTraffic,
    required this.packageName,
    required this.packagePrice,
    required this.expireTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从 JSON 创建
  factory NetworkAccount.fromJson(Map<String, dynamic> json) =>
      _$NetworkAccountFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$NetworkAccountToJson(this);

  /// 复制并修改部分字段
  NetworkAccount copyWith({
    String? id,
    String? username,
    double? balance,
    double? usedTraffic,
    double? totalTraffic,
    String? packageName,
    double? packagePrice,
    DateTime? expireTime,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NetworkAccount(
      id: id ?? this.id,
      username: username ?? this.username,
      balance: balance ?? this.balance,
      usedTraffic: usedTraffic ?? this.usedTraffic,
      totalTraffic: totalTraffic ?? this.totalTraffic,
      packageName: packageName ?? this.packageName,
      packagePrice: packagePrice ?? this.packagePrice,
      expireTime: expireTime ?? this.expireTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 剩余流量（GB）
  double get remainingTraffic => totalTraffic - usedTraffic;

  /// 流量使用百分比
  double get trafficUsagePercent =>
      totalTraffic > 0 ? (usedTraffic / totalTraffic * 100) : 0;

  /// 是否即将到期（7天内）
  bool get isExpiringSoon {
    final now = DateTime.now();
    final diff = expireTime.difference(now);
    return diff.inDays <= 7 && diff.inDays > 0;
  }

  /// 是否已过期
  bool get isExpired => DateTime.now().isAfter(expireTime);

  /// 是否正常
  bool get isActive => status == 'active';

  @override
  String toString() {
    return 'NetworkAccount(id: $id, username: $username, balance: $balance, '
        'usedTraffic: $usedTraffic, totalTraffic: $totalTraffic, '
        'packageName: $packageName, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NetworkAccount &&
        other.id == id &&
        other.username == username &&
        other.balance == balance &&
        other.usedTraffic == usedTraffic &&
        other.totalTraffic == totalTraffic &&
        other.packageName == packageName &&
        other.packagePrice == packagePrice &&
        other.expireTime == expireTime &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      username,
      balance,
      usedTraffic,
      totalTraffic,
      packageName,
      packagePrice,
      expireTime,
      status,
      createdAt,
      updatedAt,
    );
  }
}
