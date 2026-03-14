library core_network;

// 核心
export 'src/api_client.dart';

// 配置
export 'src/config/network_config.dart';

// 模型
export 'src/models/api_response.dart';

// 异常
export 'src/exceptions/api_exception.dart';

// 拦截器（如果需要自定义）
export 'src/interceptors/auth_interceptor.dart';
export 'src/interceptors/log_interceptor.dart';
export 'src/interceptors/error_interceptor.dart';

// 导出Dio相关（方便使用）
export 'package:dio/dio.dart'
    show Options, CancelToken, ProgressCallback, FormData, MultipartFile;
