import 'package:dio/dio.dart';
import 'package:log_kit/log_kit.dart';

/// 日志拦截器（使用log_kit）
class NetworkLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LogKit.d('┌─────────────────────────────────────────────────');
    LogKit.d('│ 请求: ${options.method} ${options.uri}');
    LogKit.d('│ Headers: ${options.headers}');
    if (options.data != null) {
      LogKit.d('│ Data: ${options.data}');
    }
    if (options.queryParameters.isNotEmpty) {
      LogKit.d('│ Query: ${options.queryParameters}');
    }
    LogKit.d('└─────────────────────────────────────────────────');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LogKit.d('┌─────────────────────────────────────────────────');
    LogKit.d('│ 响应: ${response.statusCode} ${response.requestOptions.uri}');
    LogKit.d('│ Data: ${response.data}');
    LogKit.d('└─────────────────────────────────────────────────');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LogKit.e(
      '┌─────────────────────────────────────────────────\n'
      '│ 错误: ${err.requestOptions.method} ${err.requestOptions.uri}\n'
      '│ Message: ${err.message}\n'
      '│ Type: ${err.type}\n'
      '└─────────────────────────────────────────────────',
      error: err,
      stackTrace: err.stackTrace,
    );

    handler.next(err);
  }
}
