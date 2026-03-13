// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speed_test_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeedTestResult _$SpeedTestResultFromJson(Map<String, dynamic> json) =>
    SpeedTestResult(
      id: json['id'] as String,
      downloadSpeed: (json['downloadSpeed'] as num).toDouble(),
      uploadSpeed: (json['uploadSpeed'] as num).toDouble(),
      latency: (json['latency'] as num).toInt(),
      jitter: (json['jitter'] as num).toInt(),
      packetLoss: (json['packetLoss'] as num).toDouble(),
      server: json['server'] as String,
      testTime: DateTime.parse(json['testTime'] as String),
      networkType: json['networkType'] as String,
      status: json['status'] as String,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$SpeedTestResultToJson(SpeedTestResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'downloadSpeed': instance.downloadSpeed,
      'uploadSpeed': instance.uploadSpeed,
      'latency': instance.latency,
      'jitter': instance.jitter,
      'packetLoss': instance.packetLoss,
      'server': instance.server,
      'testTime': instance.testTime.toIso8601String(),
      'networkType': instance.networkType,
      'status': instance.status,
      'errorMessage': instance.errorMessage,
    };
