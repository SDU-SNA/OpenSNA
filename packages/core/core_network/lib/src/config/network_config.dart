/// 网络配置
class NetworkConfig {
  /// 基础URL
  final String baseUrl;

  /// 连接超时时间（毫秒）
  final int connectTimeout;

  /// 接收超时时间（毫秒）
  final int receiveTimeout;

  /// 发送超时时间（毫秒）
  final int sendTimeout;

  /// 是否启用日志
  final bool enableLog;

  /// 是否启用Cookie
  final bool enableCookie;

  const NetworkConfig({
    required this.baseUrl,
    this.connectTimeout = 30000,
    this.receiveTimeout = 30000,
    this.sendTimeout = 30000,
    this.enableLog = true,
    this.enableCookie = true,
  });

  /// 开发环境配置
  factory NetworkConfig.development() {
    return const NetworkConfig(
      baseUrl: 'https://dev-api.sdu.edu.cn',
      enableLog: true,
    );
  }

  /// 生产环境配置
  factory NetworkConfig.production() {
    return const NetworkConfig(
      baseUrl: 'https://api.sdu.edu.cn',
      enableLog: false,
    );
  }
}
