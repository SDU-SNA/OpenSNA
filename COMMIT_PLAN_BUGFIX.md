# Bug Fix Commit Plan

本次提交计划针对 Mock 数据层集成 + 编译错误修复，共分 7 个提交。

---

## Commit 1: build: add toolkit packages and update analysis config

**范围**: 项目配置

```
analysis_options.yaml
pubspec.yaml
windows/flutter/generated_plugin_registrant.cc
windows/flutter/generated_plugins.cmake
```

**说明**: 排除 toolkit example 和 build 目录的 lint 检查；更新 Windows 插件注册。

---

## Commit 2: feat(mock): add mock data layer for all feature packages

**范围**: 新增 Mock 实现文件（全部 `??` 状态）

```
packages/features/feature_academic/lib/src/data/datasources/mock_academic_api.dart
packages/features/feature_campus_info/lib/src/data/repositories/mock_campus_info_repository.dart
packages/features/feature_convenience/lib/src/data/datasources/mock_convenience_api.dart
packages/features/feature_network_service/lib/src/data/repositories/mock_network_repository.dart
packages/features/feature_auth/lib/src/data/models/login_request.g.dart
packages/features/feature_auth/lib/src/data/models/login_response.g.dart
docs/ISSUES_AND_FIXES.md
packages/toolkit/
```

**说明**: 为所有 feature 包添加 Mock 数据源，支持无后端启动；build_runner 生成的 .g.dart 文件；新增 toolkit 包目录。

---

## Commit 3: fix(core): fix core package compilation errors

**范围**: core 层包修复

```
packages/core/core_auth/lib/core_auth.dart
packages/core/core_network/lib/core_network.dart
packages/core/core_network/lib/src/models/api_response.dart
packages/core/core_network/pubspec.yaml
packages/core/core_router/lib/src/app_router.dart
packages/core/core_router/lib/src/router_extensions.dart
packages/core/core_storage/lib/core_storage.dart
packages/core/core_storage/lib/src/cache_manager.dart
packages/core/core_storage/lib/src/storage_service.dart
packages/core/core_storage/test/storage_test.dart
packages/core/core_ui/lib/src/theme/app_colors.dart
packages/core/core_ui/lib/src/theme/app_text_styles.dart
packages/core/core_ui/lib/src/theme/app_theme.dart
packages/core/core_utils/lib/src/extensions/string_extensions.dart
packages/core/core_utils/lib/src/utils/date_util.dart
packages/core/core_utils/lib/src/utils/string_util.dart
packages/core/core_utils/lib/src/utils/validator.dart
packages/core/core_utils/pubspec.yaml
```

**说明**: 修复 core 包 API 不兼容、barrel export 问题、依赖版本冲突。

---

## Commit 4: fix(feature-auth): fix auth feature compilation errors

**范围**: feature_auth 包

```
packages/features/feature_auth/lib/feature_auth.dart
packages/features/feature_auth/lib/src/data/models/login_request.dart
packages/features/feature_auth/lib/src/data/models/login_response.dart
packages/features/feature_auth/lib/src/data/repositories/auth_repository_impl.dart
packages/features/feature_auth/lib/src/domain/usecases/login_usecase.dart
packages/features/feature_auth/lib/src/presentation/pages/login_page.dart
packages/features/feature_auth/lib/src/presentation/providers/auth_provider.dart
packages/features/feature_auth/lib/src/presentation/widgets/login_form.dart
```

**说明**: 修复 `AuthService` 构造参数、`Duration`/`int` 类型错误、`GlobalKey` 误用、`auth_repository_impl` 不存在方法调用。

---

## Commit 5: fix(feature-academic): fix garbled Chinese strings and rewrite pages

**范围**: feature_academic 包

```
packages/features/feature_academic/lib/src/data/datasources/academic_api.dart
packages/features/feature_academic/lib/src/data/models/course.g.dart
packages/features/feature_academic/lib/src/data/models/exam.dart
packages/features/feature_academic/lib/src/presentation/pages/exams_page.dart
packages/features/feature_academic/lib/src/presentation/pages/grades_page.dart
packages/features/feature_academic/lib/src/presentation/pages/timetable_page.dart
packages/features/feature_academic/lib/src/presentation/providers/academic_providers.dart
```

**说明**: 修复 `exams_page.dart` 和 `grades_page.dart` 中因编码损坏导致的语法错误（乱码中文字符串）；新增 `timetable_page.dart`。

---

## Commit 6: fix(feature-campus-info, feature-convenience): fix garbled strings and missing model getters

**范围**: feature_campus_info + feature_convenience 包

```
packages/features/feature_campus_info/lib/src/data/repositories/campus_info_repository_impl.dart
packages/features/feature_campus_info/lib/src/presentation/pages/announcement_detail_page.dart
packages/features/feature_campus_info/lib/src/presentation/pages/campus_info_page.dart
packages/features/feature_campus_info/lib/src/presentation/pages/favorites_page.dart
packages/features/feature_campus_info/lib/src/presentation/pages/search_page.dart
packages/features/feature_campus_info/lib/src/presentation/providers/campus_info_providers.dart
packages/features/feature_convenience/lib/src/data/models/bus_route.dart
packages/features/feature_convenience/lib/src/data/models/bus_route.g.dart
packages/features/feature_convenience/lib/src/data/models/classroom.g.dart
packages/features/feature_convenience/lib/src/presentation/pages/bus_page.dart
packages/features/feature_convenience/lib/src/presentation/pages/classroom_page.dart
packages/features/feature_convenience/lib/src/presentation/pages/library_page.dart
packages/features/feature_convenience/lib/src/presentation/providers/convenience_providers.dart
```

**说明**: 修复所有页面中的乱码中文字符串；为 `BusRoute` 添加缺失的 `isSoon`、`isDeparted`、`minutesUntilDeparture` 计算属性。

---

## Commit 7: fix(feature-network-service): fix garbled strings and wrong AppTextStyles references

**范围**: feature_network_service 包

```
packages/features/feature_network_service/lib/src/data/datasources/network_service_api.dart
packages/features/feature_network_service/lib/src/data/models/speed_test_result.dart
packages/features/feature_network_service/lib/src/presentation/pages/device_manage_page.dart
packages/features/feature_network_service/lib/src/presentation/pages/network_account_page.dart
packages/features/feature_network_service/lib/src/presentation/pages/repair_page.dart
packages/features/feature_network_service/lib/src/presentation/pages/speed_test_history_page.dart
packages/features/feature_network_service/lib/src/presentation/pages/speed_test_page.dart
packages/features/feature_network_service/lib/src/presentation/providers/network_providers.dart
```

**说明**: 修复乱码中文字符串；将不存在的 `AppTextStyles.titleLarge/titleMedium/titleSmall` 替换为正确的 `headlineMedium/labelLarge/labelMedium`；修复 `uploadFile` → `post` API 调用。

---

## Commit 8: fix(app): fix main app layer errors and add mock provider overrides

**范围**: 主应用 lib/ 目录

```
lib/core/config/app_config.dart
lib/core/network/api_client.dart
lib/core/network/api_exception.dart
lib/core/providers/auth_provider.dart
lib/core/providers/settings_provider.dart
lib/core/routes/app_routes.dart
lib/core/services/toolkit_initializer.dart
lib/core/theme/app_theme.dart
lib/features/auth/presentation/pages/login_page.dart
lib/features/dashboard/presentation/pages/dashboard_page.dart
lib/features/dashboard/presentation/widgets/feature_card.dart
lib/features/home/presentation/pages/home_page.dart
lib/features/profile/presentation/pages/profile_page.dart
lib/features/splash/splash_page.dart
lib/main.dart
```

**说明**: 添加 `useMockData = true` 配置；在 `main.dart` 中注入 Mock provider overrides；修复 `user?.name` → `user?.extra?['name']`、`avatarUrl` → `avatar` 等字段名错误。

---

## 执行顺序

按 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 顺序提交，依赖关系从底层到上层。
