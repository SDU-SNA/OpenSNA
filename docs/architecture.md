# SDU网管会APP - 模块化架构设计文档

## 项目概述

山东大学网络管理委员会一站式服务应用，采用模块化Package架构，支持Android和Windows平台。

## 架构原则

- **模块化**: 功能按业务领域拆分为独立package
- **可复用**: 核心功能可被其他模块依赖
- **可测试**: 每个模块独立测试
- **松耦合**: 模块间通过接口通信
- **可扩展**: 新功能以新模块形式添加

---

## Package结构总览

```
sdu_sna/
├── lib/                          # 主应用
│   ├── main.dart
│   └── app.dart
├── packages/                     # 功能模块包
│   ├── core/                     # 核心基础包
│   ├── features/                 # 业务功能包
│   ├── shared/                   # 共享组件包
│   └── toolkit/                  # 通用工具包（可选，建议独立仓库）
└── docs/                         # 文档
```

**注意**: 
- toolkit包建议作为独立仓库管理，详见 [通用工具包架构](./toolkit_packages.md)
- 如果toolkit包在开发阶段，可以暂时放在主仓库的packages/toolkit目录

---

## 一、Core层 - 核心基础包

### 1. `core_network` - 网络层
**职责**: 统一网络请求、拦截器、错误处理

**依赖**:
- dio
- dio_cookie_manager
- cookie_jar

**导出内容**:
```dart
// API客户端
class ApiClient
class ApiResponse<T>
class ApiException

// 拦截器
class AuthInterceptor
class LogInterceptor
class ErrorInterceptor

// 请求配置
class NetworkConfig
```

**使用场景**: 所有需要网络请求的模块

---

### 2. `core_storage` - 本地存储层
**职责**: 统一数据持久化、缓存管理

**依赖**:
- shared_preferences
- flutter_secure_storage
- path_provider

**导出内容**:
```dart
// 存储服务
class StorageService
class SecureStorage
class CacheManager

// 数据模型
abstract class Cacheable
```

**使用场景**: 需要本地存储的所有模块

---

### 3. `core_auth` - 认证层
**职责**: 统一身份认证、Token管理、权限控制

**依赖**:
- core_network
- core_storage

**导出内容**:
```dart
// 认证服务
class AuthService
class TokenManager
class BiometricAuth

// 认证状态
class AuthState
class UserCredentials
```

**使用场景**: 需要用户认证的所有功能

---

### 4. `core_ui` - UI基础层
**职责**: 主题、通用组件、样式规范

**依赖**:
- flutter

**导出内容**:
```dart
// 主题
class AppTheme
class AppColors
class AppTextStyles

// 通用组件
class AppButton
class AppTextField
class AppCard
class LoadingWidget
class EmptyWidget
class ErrorWidget

// 工具
class ScreenUtil
class ToastUtil
```

**使用场景**: 所有UI模块

---

### 5. `core_router` - 路由层
**职责**: 统一路由管理、页面跳转

**依赖**:
- flutter

**导出内容**:
```dart
// 路由管理
class AppRouter
class RouteNames
class RouteGuard

// 导航工具
class NavigationService
```

**使用场景**: 主应用和所有功能模块

---

### 6. `core_utils` - 工具层
**职责**: 通用工具类、扩展方法

**依赖**:
- intl
- device_info_plus
- package_info_plus

**导出内容**:
```dart
// 工具类
class DateUtil
class StringUtil
class ValidatorUtil
class LogUtil

// 扩展
extension StringExtension on String
extension DateTimeExtension on DateTime
```

**使用场景**: 所有模块

---

## 二、Features层 - 业务功能包

### 1. `feature_network_service` - 校园网络服务
**职责**: 校园网账号管理、故障报修、设备管理

**依赖**:
- core_network
- core_auth
- core_ui

**功能模块**:
```
feature_network_service/
├── lib/
│   ├── src/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── network_account.dart
│   │   │   │   ├── device_info.dart
│   │   │   │   └── repair_order.dart
│   │   │   ├── repositories/
│   │   │   │   └── network_repository.dart
│   │   │   └── datasources/
│   │   │       └── network_api.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── account_page.dart
│   │       │   ├── device_manage_page.dart
│   │       │   └── repair_page.dart
│   │       ├── widgets/
│   │       └── providers/
│   └── feature_network_service.dart
```

**页面**:
- 账号管理页
- 设备管理页
- 故障报修页
- 网络测速页

---

### 2. `feature_campus_info` - 校园资讯
**职责**: 公告通知、网络状态、技术文章

**依赖**:
- core_network
- core_storage
- core_ui

**功能模块**:
```
feature_campus_info/
├── lib/
│   ├── src/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── announcement.dart
│   │   │   │   ├── article.dart
│   │   │   │   └── network_status.dart
│   │   │   └── repositories/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── announcement_list_page.dart
│   │       │   ├── article_detail_page.dart
│   │       │   └── network_status_page.dart
│   │       └── widgets/
│   └── feature_campus_info.dart
```

**页面**:
- 公告列表页
- 文章详情页
- 网络状态监控页

---

### 3. `feature_convenience` - 便民服务
**职责**: 校园地图、教室查询、图书馆、校车

**依赖**:
- core_network
- core_ui
- url_launcher

**功能模块**:
```
feature_convenience/
├── lib/
│   ├── src/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── classroom.dart
│   │   │   │   ├── library_seat.dart
│   │   │   │   └── bus_schedule.dart
│   │   │   └── repositories/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── campus_map_page.dart
│   │       │   ├── classroom_query_page.dart
│   │       │   ├── library_page.dart
│   │       │   └── bus_schedule_page.dart
│   │       └── widgets/
│   └── feature_convenience.dart
```

**页面**:
- 校园地图页
- 教室查询页
- 图书馆座位页
- 校车时刻表页

---

### 4. `feature_academic` - 学习工具
**职责**: 课程表、成绩、考试安排

**依赖**:
- core_network
- core_auth
- core_storage
- core_ui

**功能模块**:
```
feature_academic/
├── lib/
│   ├── src/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── course.dart
│   │   │   │   ├── grade.dart
│   │   │   │   └── exam.dart
│   │   │   └── repositories/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── schedule_page.dart
│   │       │   ├── grade_page.dart
│   │       │   └── exam_page.dart
│   │       └── widgets/
│   │           └── course_card.dart
│   └── feature_academic.dart
```

**页面**:
- 课程表页
- 成绩查询页
- 考试安排页

---

### 5. `feature_community` - 社区互动
**职责**: 树洞、问答、活动、投票

**依赖**:
- core_network
- core_auth
- core_ui
- cached_network_image

**功能模块**:
```
feature_community/
├── lib/
│   ├── src/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── post.dart
│   │   │   │   ├── comment.dart
│   │   │   │   ├── activity.dart
│   │   │   │   └── vote.dart
│   │   │   └── repositories/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── forum_page.dart
│   │       │   ├── post_detail_page.dart
│   │       │   ├── activity_page.dart
│   │       │   └── vote_page.dart
│   │       └── widgets/
│   │           ├── post_card.dart
│   │           └── comment_item.dart
│   └── feature_community.dart
```

**页面**:
- 论坛/树洞页
- 帖子详情页
- 活动列表页
- 投票页

---

### 6. `feature_profile` - 个人中心
**职责**: 个人资料、消息通知、设置

**依赖**:
- core_auth
- core_storage
- core_ui
- permission_handler

**功能模块**:
```
feature_profile/
├── lib/
│   ├── src/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── user_profile.dart
│   │   │   │   └── notification.dart
│   │   │   └── repositories/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── profile_page.dart
│   │       │   ├── notification_page.dart
│   │       │   ├── settings_page.dart
│   │       │   └── about_page.dart
│   │       └── widgets/
│   └── feature_profile.dart
```

**页面**:
- 个人资料页
- 消息通知页
- 设置页
- 关于页

---

## 三、Shared层 - 共享组件包

### 1. `shared_widgets` - 共享UI组件
**职责**: 跨模块复用的业务组件

**依赖**:
- core_ui
- cached_network_image
- shimmer

**导出内容**:
```dart
// 列表组件
class RefreshableList
class InfiniteList

// 媒体组件
class ImageViewer
class QRCodeWidget

// 表单组件
class FormBuilder
class DatePicker

// 其他
class BottomSheetBuilder
class DialogBuilder
```

---

### 2. `shared_models` - 共享数据模型
**职责**: 跨模块使用的通用数据模型

**导出内容**:
```dart
// 通用模型
class PageData<T>
class ApiResult<T>
class FileInfo
class Location
```

---

## 四、Toolkit层 - 通用工具包（可选）

**说明**: Toolkit包是独立于业务的、可复用的技术组件，建议作为独立仓库管理。

详细文档请参考: [通用工具包架构](./toolkit_packages.md)

### 推荐的Toolkit包

#### 1. `hardware_info_kit` - 硬件检测工具 ✅
**职责**: 跨平台硬件信息获取

**功能**:
- CPU、内存、GPU、磁盘信息
- 电池、网络、操作系统信息
- 支持 Android、Windows

**引用方式**:
```yaml
dependencies:
  hardware_info_kit:
    git:
      url: https://github.com/h1s97x/HardwareInfoKit.git
      ref: v1.0.0
```

---

#### 2. `network_diagnostic_kit` - 网络诊断工具 ✅
**职责**: 网络诊断和测试

**仓库**: https://github.com/h1s97x/NetworkDiagnosticKit

**功能**:
- 网络连接检测
- 网速测试（下载/上传/延迟）
- DNS诊断
- 路由追踪
- 网络质量评分
- 端口扫描

**使用场景**: feature_network_service

---

#### 3. `system_monitor_kit` - 系统监控工具 ✅
**职责**: 实时系统资源监控

**仓库**: https://github.com/h1s97x/SystemMonitorKit

**功能**:
- CPU、内存、磁盘、网络实时监控
- 历史数据记录
- 阈值告警
- 数据导出

**使用场景**: 性能监控页面

---

#### 4. `device_security_kit` - 设备安全检测 ✅
**职责**: 设备安全检测和风险评估

**仓库**: https://github.com/h1s97x/DeviceSecurityKit

**功能**:
- Root/越狱检测
- 模拟器检测
- 设备指纹
- 加密工具

**使用场景**: 安全检测、风险控制

---

#### 5. `log_kit` - 日志管理 ✅
**职责**: 统一日志管理和上报

**仓库**: https://github.com/h1s97x/LogKit

**功能**:
- 多级别日志
- 本地存储
- 远程上报

**使用场景**: 全局日志

---

#### 6. `crash_reporter_kit` - 崩溃收集 ✅
**职责**: 崩溃收集和分析

**仓库**: https://github.com/h1s97x/CrashReporterKit

**功能**:
- 异常捕获
- 崩溃报告
- 自动上报

**使用场景**: 全局异常处理

---

#### 7. `permission_kit` - 权限管理 ✅
**职责**: 统一权限管理

**仓库**: https://github.com/h1s97x/PermissionKit

**功能**:
- 权限请求
- 权限状态检查
- 权限对话框
- 设置页面导航

**使用场景**: 所有需要权限的功能

---

### Toolkit包的使用

**所有Toolkit包均采用独立仓库架构**，托管在GitHub账号 `h1s97x` 下，使用帕斯卡命名法。

在主应用中引用：
```yaml
# pubspec.yaml
dependencies:
  # 通用工具包（独立仓库）
  hardware_info_kit:
    git:
      url: https://github.com/h1s97x/HardwareInfoKit.git
      ref: v1.0.0
  network_diagnostic_kit:
    git:
      url: https://github.com/h1s97x/NetworkDiagnosticKit.git
      ref: v1.0.0
  log_kit:
    git:
      url: https://github.com/h1s97x/LogKit.git
      ref: v1.0.0
  crash_reporter_kit:
    git:
      url: https://github.com/h1s97x/CrashReporterKit.git
      ref: v1.0.0
  system_monitor_kit:
    git:
      url: https://github.com/h1s97x/SystemMonitorKit.git
      ref: v1.0.0
  device_security_kit:
    git:
      url: https://github.com/h1s97x/DeviceSecurityKit.git
      ref: v1.0.0
  permission_kit:
    git:
      url: https://github.com/h1s97x/PermissionKit.git
      ref: v1.0.0
```

在功能模块中使用：
```dart
// packages/features/feature_network_service/lib/src/pages/diagnostic_page.dart
import 'package:network_diagnostic_kit/network_diagnostic_kit.dart';

class DiagnosticPage extends StatelessWidget {
  Future<void> runTest() async {
    final result = await NetworkDiagnostic.runSpeedTest();
    print('下载速度: ${result.downloadSpeed} Mbps');
  }
}
```

---

## 五、依赖关系图

```
┌─────────────────────────────────────────────────────────┐
│                      Main App                           │
│                    (sdu_sna)                            │
└────────────────────┬────────────────────────────────────┘
                     │
        ┌────────────┴────────────┬──────────────┐
        │                         │              │
        ▼                         ▼              ▼
┌───────────────┐         ┌──────────────┐  ┌─────────────┐
│   Features    │         │    Shared    │  │   Toolkit   │
│   Packages    │◄────────│   Packages   │  │  (独立仓库)  │
└───────┬───────┘         └──────┬───────┘  └─────────────┘
        │                        │
        └────────────┬───────────┘
                     │
                     ▼
             ┌───────────────┐
             │  Core Packages│
             └───────────────┘
```

**依赖规则**:
- Main App 依赖 Features、Core 和 Toolkit
- Features 依赖 Core、Shared 和 Toolkit
- Shared 依赖 Core
- Toolkit 独立，不依赖项目内的包
- Core 之间可以相互依赖（需控制循环依赖）
- Features 之间不直接依赖（通过事件总线通信）

---

## 五、实施步骤

### Phase 1: 基础设施（Week 1-2）
1. 创建 core_network
2. 创建 core_storage
3. 创建 core_auth
4. 创建 core_ui
5. 创建 core_router
6. 创建 core_utils

### Phase 2: 核心功能（Week 3-4）
1. 实现 feature_network_service（核心业务）
2. 实现 feature_profile
3. 实现 shared_widgets

### Phase 3: 扩展功能（Week 5-6）
1. 实现 feature_campus_info
2. 实现 feature_academic
3. 实现 feature_convenience

### Phase 4: 社区功能（Week 7-8）
1. 实现 feature_community
2. 完善 shared_models
3. 集成测试

---

## 六、Package创建规范

### 目录结构模板
```
package_name/
├── lib/
│   ├── src/
│   │   ├── data/           # 数据层
│   │   │   ├── models/     # 数据模型
│   │   │   ├── repositories/  # 仓库实现
│   │   │   └── datasources/   # 数据源
│   │   ├── domain/         # 领域层
│   │   │   ├── entities/   # 业务实体
│   │   │   └── usecases/   # 用例
│   │   └── presentation/   # 表现层
│   │       ├── pages/      # 页面
│   │       ├── widgets/    # 组件
│   │       └── providers/  # 状态管理
│   └── package_name.dart   # 导出文件
├── test/                   # 测试
├── pubspec.yaml
└── README.md
```

### pubspec.yaml模板
```yaml
name: package_name
description: Package description
version: 0.1.0
publish_to: none

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  # 添加依赖

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

### 导出文件规范
```dart
// package_name.dart
library package_name;

// 导出公共API
export 'src/data/models/model.dart';
export 'src/domain/entities/entity.dart';
export 'src/presentation/pages/page.dart';

// 不导出内部实现
// export 'src/data/datasources/...' ❌
```

---

## 七、开发规范

### 命名规范
- Package名: `snake_case` (如: `core_network`)
- 文件名: `snake_case` (如: `user_profile.dart`)
- 类名: `PascalCase` (如: `UserProfile`)
- 变量/方法: `camelCase` (如: `getUserProfile`)
- 常量: `lowerCamelCase` (如: `maxRetryCount`)

### 代码组织
- 每个文件只包含一个公共类
- 相关功能放在同一目录
- 使用barrel文件简化导入

### 状态管理
- 使用 Riverpod 进行状态管理
- Provider 定义在各自的 feature 中
- 全局状态放在 core 层

### 错误处理
- 统一使用 `ApiException` 处理网络错误
- UI层捕获并展示用户友好的错误信息
- 记录详细日志用于调试

---

## 八、测试策略

### 单元测试
- 每个 package 独立测试
- 覆盖率目标: 80%+
- 重点测试业务逻辑和数据转换

### 集成测试
- 测试模块间交互
- 测试完整业务流程

### UI测试
- 关键页面的Widget测试
- 用户交互流程测试

---

## 九、性能优化

### 网络优化
- 请求缓存
- 图片懒加载
- 分页加载

### 存储优化
- 定期清理过期缓存
- 压缩存储数据
- 使用索引加速查询

### UI优化
- 列表复用
- 图片缓存
- 骨架屏加载

---

## 十、安全考虑

### 数据安全
- 敏感信息使用 SecureStorage
- Token 加密存储
- HTTPS 通信

### 权限管理
- 最小权限原则
- 运行时权限请求
- 权限说明清晰

---

## 附录

### 参考资料
- [Flutter Package开发指南](https://docs.flutter.dev/development/packages-and-plugins/developing-packages)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Riverpod文档](https://riverpod.dev/)

### 更新日志
- 2026-03-08: 初始版本
