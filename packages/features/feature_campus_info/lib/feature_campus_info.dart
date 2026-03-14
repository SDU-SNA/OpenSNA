/// 校园资讯功能模块
library feature_campus_info;

// Data 层
export 'src/data/models/announcement.dart';
export 'src/data/datasources/campus_info_api.dart';
export 'src/data/repositories/campus_info_repository_impl.dart';

// Domain 层
export 'src/domain/repositories/campus_info_repository.dart';

// Presentation 层
export 'src/presentation/providers/campus_info_providers.dart';
export 'src/presentation/pages/campus_info_page.dart';
export 'src/presentation/pages/announcement_detail_page.dart';
export 'src/presentation/pages/search_page.dart';
export 'src/presentation/pages/favorites_page.dart';
