// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkAccount _$NetworkAccountFromJson(Map<String, dynamic> json) =>
    NetworkAccount(
      id: json['id'] as String,
      username: json['username'] as String,
      balance: (json['balance'] as num).toDouble(),
      usedTraffic: (json['usedTraffic'] as num).toDouble(),
      totalTraffic: (json['totalTraffic'] as num).toDouble(),
      packageName: json['packageName'] as String,
      packagePrice: (json['packagePrice'] as num).toDouble(),
      expireTime: DateTime.parse(json['expireTime'] as String),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$NetworkAccountToJson(NetworkAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'balance': instance.balance,
      'usedTraffic': instance.usedTraffic,
      'totalTraffic': instance.totalTraffic,
      'packageName': instance.packageName,
      'packagePrice': instance.packagePrice,
      'expireTime': instance.expireTime.toIso8601String(),
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
