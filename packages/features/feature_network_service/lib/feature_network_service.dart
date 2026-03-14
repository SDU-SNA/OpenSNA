/// 网络服务功能模块
library feature_network_service;

// Data 层
export 'src/data/models/network_account.dart';
export 'src/data/models/device_info.dart';
export 'src/data/models/speed_test_result.dart';
export 'src/data/models/repair_record.dart';
export 'src/data/datasources/network_service_api.dart';
export 'src/data/repositories/network_repository_impl.dart';

// Domain 层
export 'src/domain/repositories/network_repository.dart';

// Presentation 层
export 'src/presentation/providers/network_providers.dart';
export 'src/presentation/pages/network_service_page.dart';
export 'src/presentation/pages/speed_test_page.dart';
export 'src/presentation/pages/network_account_page.dart';
export 'src/presentation/pages/device_manage_page.dart';
export 'src/presentation/pages/repair_page.dart';
export 'src/presentation/pages/speed_test_history_page.dart';
