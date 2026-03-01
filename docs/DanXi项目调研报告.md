# DanXi 项目调研报告

## 1. 项目概述

### 1.1 项目简介
**DanXi（旦挞）** 是一款为复旦大学学生开发的一站式服务应用，使用 Flutter 框架构建，支持多平台部署（iOS、Android、Windows、macOS、Linux）。该项目采用 GPL-3.0 开源协议，由 DanXi-Dev 团队维护。

- **项目名称**: DanXi（旦挞，原名旦夕、旦兮）
- **开发语言**: Dart + Flutter
- **当前版本**: 1.5.0+347
- **Flutter 版本**: 3.41.0 (stable)
- **Dart 版本**: 3.11.0
- **开源协议**: GPL-3.0
- **官方网站**: https://danxi.fduhole.com
- **GitHub**: https://github.com/DanXi-Dev/DanXi

### 1.2 核心功能
DanXi 为复旦大学学生提供以下主要功能：

1. **校园卡服务**
   - 校园卡余额查询
   - 消费记录查看
   - 食堂消费人数统计

2. **学务管理**
   - 课表查阅与导出至系统日历
   - 空教室查询
   - 期中/期末考试日程查询与导出
   - 期末绩点和专业排名查询
   - 教务处通知显示

3. **校园生活**
   - 复活码快速显示（支持 Apple Watch）
   - 刷锻次数查询
   - 校车班次查询
   - 图书馆拥挤度查询
   - 宿舍电费查询

4. **社区功能**
   - 茶楼（校园论坛）
   - 课程评价（DanKe）

## 2. 技术架构分析

### 2.1 技术栈

#### 核心框架
- **Flutter SDK**: 3.41.0
- **Dart**: 3.11.0
- **状态管理**: Provider + Riverpod (hooks_riverpod)
- **国际化**: flutter_intl

#### 主要依赖库


**网络请求**
- `dio`: ^5.4.3+1 - HTTP 客户端
- `dio_cookie_manager`: ^3.0.0 - Cookie 管理
- `http`: ^1.0.0 - HTTP 请求库

**UI 组件**
- `flutter_platform_widgets`: ^10.0.0 - 跨平台 UI 组件
- `cached_network_image`: ^3.2.1 - 图片缓存
- `photo_view`: ^0.15.0 - 图片查看器
- `qr_flutter`: ^4.0.0 - 二维码生成
- `flutter_markdown_plus` - Markdown 渲染
- `fl_chart`: ^1.1.0 - 图表组件

**数据持久化**
- `shared_preferences`: ^2.0.15 - 本地存储
- `flutter_secure_storage`: ^10.0.0-beta.4 - 安全存储
- `encrypt_shared_preferences`: ^0.9.8 - 加密存储
- `path_provider`: ^2.0.9 - 路径管理

**功能增强**
- `quick_actions`: ^1.0.1 - 快捷操作
- `url_launcher`: ^6.1.12 - URL 启动
- `share_plus`: ^12.0.0 - 分享功能
- `permission_handler`: ^12.0.0+1 - 权限管理
- `device_info_plus`: ^12.3.0 - 设备信息
- `in_app_review`: ^2.0.4 - 应用内评价

**平台特定**
- `xiao_mi_push_plugin` - 小米推送（Android）
- `desktop_window`: ^0.4.0 - 桌面窗口控制
- `win32`: ^5.0.2 - Windows API

### 2.2 项目结构

```
DanXi-main/
├── lib/
│   ├── common/           # 公共常量和配置
│   │   ├── constant.dart
│   │   ├── feature_registers.dart
│   │   └── icon_fonts.dart
│   ├── feature/          # 功能模块（Dashboard 卡片）
│   │   ├── base_feature.dart
│   │   ├── feature_map.dart
│   │   ├── ecard_balance_feature.dart
│   │   ├── empty_classroom_feature.dart
│   │   ├── qr_feature.dart
│   │   └── ...
│   ├── page/             # 页面组件
│   │   ├── home_page.dart
│   │   ├── dashboard/    # 仪表盘页面
│   │   ├── forum/        # 论坛页面
│   │   ├── danke/        # 课程评价页面
│   │   └── settings/     # 设置页面
│   ├── provider/         # 状态管理
│   │   ├── settings_provider.dart
│   │   ├── forum_provider.dart
│   │   └── notification_provider.dart
│   ├── repository/       # 数据层
│   │   ├── fdu/          # 复旦大学相关 API
│   │   ├── forum/        # 论坛 API
│   │   ├── danke/        # 课程评价 API
│   │   └── app/          # 应用内部 API
│   ├── model/            # 数据模型
│   ├── widget/           # 可复用组件
│   ├── util/             # 工具类
│   ├── l10n/             # 国际化资源
│   └── main.dart         # 应用入口
├── android/              # Android 平台配置
├── ios/                  # iOS 平台配置
├── windows/              # Windows 平台配置
├── linux/                # Linux 平台配置
├── macos/                # macOS 平台配置
├── web/                  # Web 平台配置
└── assets/               # 资源文件
    ├── fonts/
    ├── graphics/
    └── texts/
```

### 2.3 架构设计模式

#### 2.3.1 Feature 模式
DanXi 采用了独特的 **Feature 模式** 来组织 Dashboard 功能卡片：

```dart
abstract class Feature {
  ConnectionStatus status;
  Widget? get icon;
  String? get mainTitle;
  String? get subTitle;
  bool get clickable;
  
  void buildFeature([Map<String, dynamic>? arguments]);
  void initFeature();
  void onTap();
}
```

**特点**：
- 每个功能卡片都是一个独立的 Feature 实例
- 通过 `FeatureMap` 统一注册和管理
- 支持动态加载和状态更新
- 可配置的显示顺序和可见性

**添加新功能的步骤**：
1. 创建继承自 `Feature` 的类
2. 在 `FeatureMap.registerAllFeatures()` 中注册
3. 添加到 `Constant.defaultDashboardCardList`

#### 2.3.2 Repository 模式
数据层采用 Repository 模式，分离数据获取逻辑：

```
repository/
├── base_repository.dart      # 基础仓库类
├── fdu/                      # 复旦大学服务
│   ├── uis_login_tool.dart   # UIS 登录
│   ├── neo_login_tool.dart   # Neo 登录
│   └── ...
├── forum/                    # 论坛服务
└── app/                      # 应用服务
```

#### 2.3.3 Provider 状态管理
使用 Provider + Riverpod 混合方案：

- **Provider**: 用于全局状态（SettingsProvider, ForumProvider）
- **Riverpod**: 用于局部状态和依赖注入
- **ChangeNotifier**: 实现状态变更通知

### 2.4 路由管理

采用命名路由方式，在 `DanxiApp.routes` 中集中管理：

```dart
static final Map<String, Function> routes = {
  '/home': (context, {arguments}) => const HomePage(),
  '/settings': (context, {arguments}) => const SettingsPage(),
  '/bbs/postDetail': (context, {arguments}) => BBSPostDetail(arguments: arguments),
  // ...
};
```

使用 `smartNavigatorPush` 进行页面导航，支持参数传递。

## 3. 核心功能实现分析

### 3.1 认证系统

DanXi 实现了复旦大学的统一身份认证（UIS）和 Neo 系统登录：

- **UIS 登录**: 用于访问教务系统、校园卡等服务
- **Neo 登录**: 用于访问新版校园服务
- **Session 管理**: 使用 Cookie 持久化登录状态
- **安全存储**: 使用 `flutter_secure_storage` 加密存储凭证

### 3.2 Dashboard 功能卡片

Dashboard 采用可配置的卡片式布局：

**已实现的功能卡片**：
1. `EcardBalanceFeature` - 校园卡余额
2. `EmptyClassroomFeature` - 空教室查询
3. `QRFeature` - 复活码显示
4. `PEFeature` - 体育锻炼记录
5. `NextCourseFeature` - 今日课程
6. `BusFeature` - 校车查询
7. `DiningHallCrowdednessFeature` - 食堂拥挤度
8. `DormElectricityFeature` - 宿舍电费
9. `FudanLibraryCrowdednessFeature` - 图书馆拥挤度
10. `FudanAAONoticesFeature` - 教务通知

**特性**：
- 支持拖拽排序
- 可自定义显示/隐藏
- 异步加载数据
- 状态指示（加载中、成功、失败）

### 3.3 论坛系统（茶楼）

完整的校园论坛功能：

- 帖子浏览、发布、回复
- 图片上传和查看
- 标签系统
- 搜索功能
- 消息通知
- 管理员操作
- Markdown 支持

### 3.4 课表系统

- 课表数据获取和解析
- 日历视图展示
- 导出到系统日历（.ics 格式）
- 今日课程提醒

### 3.5 多平台适配

#### 平台检测
使用 `PlatformX` 工具类统一处理平台差异：

```dart
class PlatformX {
  static bool get isAndroid;
  static bool get isIOS;
  static bool get isWindows;
  static bool get isMacOS;
  static bool get isLinux;
  static bool get isWeb;
  static bool isCupertino(BuildContext context);
}
```

#### UI 适配
- **Material Design**: Android、Windows、Linux
- **Cupertino Design**: iOS、macOS
- 使用 `flutter_platform_widgets` 实现跨平台组件

#### 特定平台功能
- **iOS**: Apple Watch 支持、快捷操作
- **Android**: 小米推送、快捷方式
- **Desktop**: 窗口控制、系统托盘

## 4. 开发规范

### 4.1 代码规范

**命名规范**：
- 私有成员使用 `_` 前缀
- 长而清晰的命名优于短而模糊的命名
- 避免重复代码块

**架构原则**：
- 解耦优于耦合
- 多个小类优于少数大类
- 私有优于公开
- 单一职责原则

### 4.2 提交规范

采用规范化的 Commit Message 格式：

```
<action>: <description>

<details>
```

**Action 类型**：
- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档变更
- `update`: 翻译文本更新
- `upgrade`: 依赖升级
- `change`/`misc`: 其他代码变更
- `style`: 代码格式调整
- `refactor`: 代码重构
- `chore`: 构建过程变更
- `perf`: 性能优化

### 4.3 国际化

支持多语言：
- 中文简体 (zh_Hans)
- 中文繁体 (zh_Hant)
- 英语 (en)
- 日语 (ja)

使用 `flutter_intl` 管理翻译资源。

## 5. 构建和部署

### 5.1 构建步骤

```bash
# 1. 获取依赖
flutter pub get

# 2. 激活国际化工具
flutter pub global activate intl_utils

# 3. 生成国际化文件
dart run intl_utils:generate

# 4. 生成代码
dart run build_runner build --delete-conflicting-outputs

# 5. 运行应用
flutter run [ios/android/windows/linux/macos]
```

### 5.2 平台要求

- **Android**: Android Command Line Tools
- **iOS/macOS**: Xcode
- **Windows**: Visual Studio
- **Linux**: GTK3, libsecret, gnome-keyring, wpewebkit

### 5.3 发布渠道

- **iOS/iPadOS**: App Store
- **Android**: GitHub Releases (APK)
- **Windows**: GitHub Releases (ZIP)
- **macOS**: App Store (Apple Silicon) / GitHub Releases (Intel)
- **Linux**: AUR / archlinuxcn / GitHub Releases

## 6. 项目亮点

### 6.1 技术亮点

1. **完整的多平台支持**
   - 单一代码库支持 6 个平台
   - 平台特定功能适配（如 Apple Watch）

2. **模块化架构**
   - Feature 模式实现功能解耦
   - Repository 模式分离数据层
   - 清晰的分层架构

3. **良好的用户体验**
   - Material 3 设计
   - 动态主题色
   - 流畅的动画效果
   - 离线缓存支持

4. **安全性**
   - 加密存储敏感信息
   - 防截屏功能
   - Session 管理

5. **可扩展性**
   - 插件化的 Feature 系统
   - 统一的路由管理
   - 完善的状态管理

### 6.2 功能亮点

1. **一站式服务**
   - 整合校园各类服务
   - 统一的用户界面
   - 便捷的快捷操作

2. **社区功能**
   - 完整的论坛系统
   - 课程评价平台
   - 实时消息通知

3. **智能提醒**
   - 课程提醒
   - 考试日程
   - 系统通知

## 7. 可借鉴之处

### 7.1 架构设计

**Feature 模式**：
- 适合卡片式 Dashboard 设计
- 易于添加和管理功能模块
- 支持动态配置

**Repository 模式**：
- 清晰的数据层抽象
- 便于测试和维护
- 支持多数据源

### 7.2 开发流程

1. **规范化的开发流程**
   - 清晰的 Commit 规范
   - 完善的文档
   - 活跃的社区

2. **多平台适配经验**
   - 平台检测工具类
   - 跨平台 UI 组件
   - 特定平台功能处理

3. **国际化方案**
   - flutter_intl 工具链
   - 多语言支持

### 7.3 功能实现

1. **认证系统**
   - 统一身份认证集成
   - Session 管理
   - 安全存储方案

2. **数据缓存**
   - 离线数据支持
   - 图片缓存
   - 状态持久化

3. **用户体验**
   - 加载状态指示
   - 错误处理
   - 流畅的交互

## 8. 潜在问题和改进建议

### 8.1 潜在问题

1. **依赖管理**
   - 部分依赖使用 Git 仓库而非 pub.dev
   - 可能影响构建稳定性

2. **代码复杂度**
   - 部分文件较大（如 main.dart）
   - 可以进一步拆分

3. **测试覆盖**
   - 测试代码较少
   - 缺少自动化测试

### 8.2 改进建议

1. **架构优化**
   - 考虑使用更现代的状态管理方案（如 Riverpod 2.0）
   - 进一步模块化大型文件

2. **测试完善**
   - 增加单元测试
   - 添加集成测试
   - 实现 CI/CD 自动化测试

3. **文档完善**
   - 添加 API 文档
   - 完善开发指南
   - 提供架构图

## 9. 对山东大学网管会应用的启示

### 9.1 可直接借鉴的设计

1. **Feature 模式**
   - 适合校园服务应用的功能组织
   - 易于扩展和维护

2. **多平台支持**
   - Flutter 框架的跨平台能力
   - 统一的代码库

3. **认证系统**
   - 统一身份认证集成方案
   - Session 管理机制

### 9.2 需要适配的部分

1. **学校特定服务**
   - 山东大学的教务系统
   - 校园卡系统
   - 其他校园服务 API

2. **UI 设计**
   - 符合山东大学品牌形象
   - 自定义主题色

3. **功能定制**
   - 根据山东大学学生需求定制功能
   - 添加特色服务

### 9.3 开发建议

1. **初期开发**
   - 从核心功能开始（认证、课表、校园卡）
   - 采用 Feature 模式组织代码
   - 建立清晰的项目结构

2. **技术选型**
   - 使用 Flutter 3.x 稳定版
   - Provider + Riverpod 状态管理
   - Dio 网络请求库

3. **开发流程**
   - 建立代码规范
   - 使用 Git 版本控制
   - 实施 Code Review

4. **测试和部署**
   - 优先支持 Android 和 iOS
   - 建立测试环境
   - 逐步完善功能

## 10. 总结

DanXi 是一个成熟的校园服务应用项目，具有以下特点：

**优势**：
- 完整的多平台支持
- 清晰的架构设计
- 丰富的功能实现
- 活跃的开源社区
- 良好的代码规范

**可借鉴价值**：
- Feature 模式的功能组织方式
- Repository 模式的数据层设计
- 多平台适配经验
- 认证和安全方案
- 开发规范和流程

**建议**：
对于山东大学网管会的应用开发，可以参考 DanXi 的整体架构和设计模式，但需要根据山东大学的实际情况进行适配和定制。建议采用渐进式开发策略，先实现核心功能，再逐步扩展。

---

**报告生成时间**: 2026-03-01  
**DanXi 版本**: 1.5.0+347  
**Flutter 版本**: 3.41.0
