import 'package:json_annotation/json_annotation.dart';

part 'speed_test_result.g.dart';

/// 网络测速结果模型
@JsonSerializable()
class SpeedTestResult {
  /// 测试ID
  final String id;

  /// 下载速度（Mbps）
  final double downloadSpeed;

  /// 上传速度（Mbps）
  final double uploadSpeed;

  /// 延迟（ms）
  final int latency;

  /// 抖动（ms）
  final int jitter;

  /// 丢包率（%）
  final double packetLoss;

  /// 测试服务器
  final String server;

  /// 测试时间
  final DateTime testTime;

  /// 网络类型（wifi, cellular, ethernet）
  final String networkType;

  /// 测试状态（success, failed, timeout）
  final String status;

  /// 错误信息（如果失败）
  final String? errorMessage;

  const SpeedTestResult({
    required this.id,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.latency,
    required this.jitter,
    required this.packetLoss,
    required this.server,
    required this.testTime,
    required this.networkType,
    required this.status,
    this.errorMessage,
  });

  /// 从 JSON 创建
  factory SpeedTestResult.fromJson(Map<String, dynamic> json) =>
      _$SpeedTestResultFromJson(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => _$SpeedTestResultToJson(this);

  /// 复制并修改部分字段
  SpeedTestResult copyWith({
    String? id,
    double? downloadSpeed,
    double? uploadSpeed,
    int? latency,
    int? jitter,
    double? packetLoss,
    String? server,
    DateTime? testTime,
    String? networkType,
    String? status,
    String? errorMessage,
  }) {
    return SpeedTestResult(
      id: id ?? this.id,
      downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      uploadSpeed: uploadSpeed ?? this.uploadSpeed,
      latency: latency ?? this.latency,
      jitter: jitter ?? this.jitter,
      packetLoss: packetLoss ?? this.packetLoss,
      server: server ?? this.server,
      testTime: testTime ?? this.testTime,
      networkType: networkType ?? this.networkType,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// 是否测试成功
  bool get isSuccess => status == 'success';

  /// 网络质量评级（excellent, good, fair, poor）
  String get qualityRating {
    if (!isSuccess) return 'unknown';

    // 综合评分：下载速度 40%、上传速度 30%、延迟 20%、丢包率 10%
    double score = 0;

    // 下载速度评分（满分40）
    if (downloadSpeed >= 100) {
      score += 40;
    } else if (downloadSpeed >= 50) {
      score += 30;
    } else if (downloadSpeed >= 20) {
      score += 20;
    } else if (downloadSpeed >= 10) {
      score += 10;
    }

    // 上传速度评分（满分30）
    if (uploadSpeed >= 50) {
      score += 30;
    } else if (uploadSpeed >= 20) {
      score += 20;
    } else if (uploadSpeed >= 10) {
      score += 15;
    } else if (uploadSpeed >= 5) {
      score += 10;
    }

    // 延迟评分（满分20）
    if (latency <= 20) {
      score += 20;
    } else if (latency <= 50) {
      score += 15;
    } else if (latency <= 100) {
      score += 10;
    } else if (latency <= 200) {
      score += 5;
    }

    // 丢包率评分（满分10）
    if (packetLoss == 0) {
      score += 10;
    } else if (packetLoss < 1) {
      score += 7;
    } else if (packetLoss < 3) {
      score += 5;
    } else if (packetLoss < 5) {
      score += 3;
    }

    // 根据总分评级
    if (score >= 85) {
      return 'excellent';
    } else if (score >= 70) {
      return 'good';
    } else if (score >= 50) {
      return 'fair';
    } else {
      return 'poor';
    }
  }

  /// 质量评级文本
  String get qualityRatingText {
    switch (qualityRating) {
      case 'excellent':
        return '优秀';
      case 'good':
        return '良好';
      case 'fair':
        return '一般';
      case 'poor':
        return '较差';
      default:
        return '未知';
    }
  }

  /// 格式化的下载速度
  String get formattedDownloadSpeed => '${downloadSpeed.toStringAsFixed(2)} Mbps';

  /// 格式化的上传速度
  String get formattedUploadSpeed => '${uploadSpeed.toStringAsFixed(2)} Mbps';

  /// 格式化的延迟
  String get formattedLatency => '$latency ms';

  /// 格式化的抖动
  String get formattedJitter => '$jitter ms';

  /// 格式化的丢包率
  String get formattedPacketLoss => '${packetLoss.toStringAsFixed(2)}%';

  @override
  String toString() {
    return 'SpeedTestResult(id: $id, downloadSpeed: $downloadSpeed, '
        'uploadSpeed: $uploadSpeed, latency: $latency, '
        'server: $server, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SpeedTestResult &&
        other.id == id &&
        other.downloadSpeed == downloadSpeed &&
        other.uploadSpeed == uploadSpeed &&
        other.latency == latency &&
        other.jitter == jitter &&
        other.packetLoss == packetLoss &&
        other.server == server &&
        other.testTime == testTime &&
        other.networkType == networkType &&
        other.status == status &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      downloadSpeed,
      uploadSpeed,
      latency,
      jitter,
      packetLoss,
      server,
      testTime,
      networkType,
      status,
      errorMessage,
    );
  }
}
