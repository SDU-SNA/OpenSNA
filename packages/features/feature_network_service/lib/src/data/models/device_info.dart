import 'package:json_annotation/json_annotation.dart';

part 'device_info.g.dart';

/// 在线设备信息模型
@JsonSerializable()
class DeviceInfo {
  /// 设备ID
  final String id;

  /// 设备名称
  final String name;

  /// 设备类型（phone, tablet, laptop, desktop, other）
  final String type;

  /// MAC 地址
  final String macAddress;

  /// IP 地址
  final String ipAddress;

  /// 登录时间
  final DateTime loginTime;

  /// 最后活动时间
  final DateTime lastActiveTime;

  /// 已用流量（MB）
  final double usedTraffic;

  /// 设备操作系统
  final String? os;

  /// 设备品牌
  final String? brand;

  /// 设备型号
  final String? model;

  /// 连接位置
  final String? location;

  /// 是否当前设备
  final bool isCurrentDevice;

  const DeviceInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.macAddress,
    required this.ipAddress,
    required this.loginTime,
    required this.lastActiveTime,
    required this.usedTraffic,
    this.os,
    this.brand,
    this.model,
    this.location,
    this.isCurrentDevice = false,
  });

  /// 从 JSON 创建
  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);

  /// 复制并修改部分字段
  DeviceInfo copyWith({
    String? id,
    String? name,
    String? type,
    String? macAddress,
    String? ipAddress,
    DateTime? loginTime,
    DateTime? lastActiveTime,
    double? usedTraffic,
    String? os,
    String? brand,
    String? model,
    String? location,
    bool? isCurrentDevice,
  }) {
    return DeviceInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      macAddress: macAddress ?? this.macAddress,
      ipAddress: ipAddress ?? this.ipAddress,
      loginTime: loginTime ?? this.loginTime,
      lastActiveTime: lastActiveTime ?? this.lastActiveTime,
      usedTraffic: usedTraffic ?? this.usedTraffic,
      os: os ?? this.os,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      location: location ?? this.location,
      isCurrentDevice: isCurrentDevice ?? this.isCurrentDevice,
    );
  }

  /// 在线时长（分钟）
  int get onlineDuration {
    final now = DateTime.now();
    return now.difference(loginTime).inMinutes;
  }

  /// 格式化的在线时长
  String get formattedOnlineDuration {
    final duration = onlineDuration;
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

  /// 格式化的流量使用
  String get formattedTraffic {
    if (usedTraffic < 1024) {
      return '${usedTraffic.toStringAsFixed(2)} MB';
    } else {
      final gb = usedTraffic / 1024;
      return '${gb.toStringAsFixed(2)} GB';
    }
  }

  /// 设备图标名称
  String get deviceIcon {
    switch (type.toLowerCase()) {
      case 'phone':
        return 'phone_android';
      case 'tablet':
        return 'tablet';
      case 'laptop':
        return 'laptop';
      case 'desktop':
        return 'computer';
      default:
        return 'devices';
    }
  }

  /// 设备显示名称
  String get displayName {
    if (brand != null && model != null) {
      return '$brand $model';
    } else if (brand != null) {
      return brand!;
    } else if (model != null) {
      return model!;
    } else {
      return name;
    }
  }

  @override
  String toString() {
    return 'DeviceInfo(id: $id, name: $name, type: $type, '
        'macAddress: $macAddress, ipAddress: $ipAddress, '
        'loginTime: $loginTime, usedTraffic: $usedTraffic)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeviceInfo &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.macAddress == macAddress &&
        other.ipAddress == ipAddress &&
        other.loginTime == loginTime &&
        other.lastActiveTime == lastActiveTime &&
        other.usedTraffic == usedTraffic &&
        other.os == os &&
        other.brand == brand &&
        other.model == model &&
        other.location == location &&
        other.isCurrentDevice == isCurrentDevice;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      type,
      macAddress,
      ipAddress,
      loginTime,
      lastActiveTime,
      usedTraffic,
      os,
      brand,
      model,
      location,
      isCurrentDevice,
    );
  }
}
