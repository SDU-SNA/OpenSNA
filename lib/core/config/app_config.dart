/// 应用配置
class AppConfig {
  /// 是否使用 Mock 数据（开发/演示模式）
  static const bool useMockData = true;

  // API基础URL
  static const String baseUrl = 'https://api.sdu.edu.cn';

  // 统一身份认证URL
  static const String authUrl = 'https://pass.sdu.edu.cn';

  // 应用信息
  static const String appName = '山大网管会';
  static const String appVersion = '0.1.0';

  // 缓存配置
  static const int cacheMaxAge = 7; // 天
  static const int cacheMaxCount = 100;

  // 网络超时配置
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// 初始化配置
  static Future<void> init() async {
    // 这里可以加载远程配置或本地配置
  }
}
