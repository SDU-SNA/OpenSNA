// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      macAddress: json['macAddress'] as String,
      ipAddress: json['ipAddress'] as String,
      loginTime: DateTime.parse(json['loginTime'] as String),
      lastActiveTime: DateTime.parse(json['lastActiveTime'] as String),
      usedTraffic: (json['usedTraffic'] as num).toDouble(),
      os: json['os'] as String?,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      location: json['location'] as String?,
      isCurrentDevice: json['isCurrentDevice'] as bool? ?? false,
    );

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'macAddress': instance.macAddress,
      'ipAddress': instance.ipAddress,
      'loginTime': instance.loginTime.toIso8601String(),
      'lastActiveTime': instance.lastActiveTime.toIso8601String(),
      'usedTraffic': instance.usedTraffic,
      'os': instance.os,
      'brand': instance.brand,
      'model': instance.model,
      'location': instance.location,
      'isCurrentDevice': instance.isCurrentDevice,
    };
