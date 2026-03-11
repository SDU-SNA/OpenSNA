import 'package:dio/dio.dart';

/// 认证拦截器
class AuthInterceptor extends Interceptor {
  /// Token获取回调
  final Future<String?> Function() getToken;

  AuthInterceptor({required this.getToken});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 获取Token
    final token = await getToken();

    // 添加Token到请求头
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 401未授权，可以在这里处理Token刷新
    if (err.response?.statusCode == 401) {
      // TODO: 实现Token刷新逻辑
    }

    handler.next(err);
  }
}
