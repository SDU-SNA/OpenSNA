# 更新日志

本项目的所有重要更改都将记录在此文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### 进行中

- Phase 3: v1.0 功能扩展（进行中）🔨
  - feature_network_service 包开发（进行中）
  - 网络测速页面已完成

### 已完成

- ✅ Phase 1: Core层基础包开发（100% 完成）
- ✅ Phase 2: MVP核心功能开发（100% 完成）✨
- ✅ Toolkit包集成（log_kit, crash_reporter_kit, permission_kit）

## [0.3.0] - 2026-03-11 (进行中)

### 新增

#### feature_network_service 包 🔨 进行中

Phase 3 第一个功能包，提供网络服务相关功能。

**Data 层（数据层）** ✅
- NetworkAccount 模型（网络账号信息）
  - 账号余额、流量统计、套餐信息
  - 到期时间、账号状态
  - 计算属性（剩余流量、使用百分比、是否即将到期）
- DeviceInfo 模型（在线设备信息）
  - 设备名称、类型、MAC/IP地址
  - 登录时间、流量使用
  - 设备操作系统、品牌、型号
  - 计算属性（在线时长、格式化流量、设备图标）
- SpeedTestResult 模型（网络测速结果）
  - 下载/上传速度、延迟、抖动、丢包率
  - 测试服务器、网络类型
  - 质量评级算法（excellent/good/fair/poor）
  - 格式化显示方法
- RepairRecord 模型（故障报修记录）
  - 报修标题、描述、类型、位置
  - 报修状态、优先级
  - 处理人员、处理备注、解决时间
  - 用户评价
- NetworkServiceApi 数据源
  - 网络账号管理 API（获取账号、充值、流量历史）
  - 在线设备管理 API（设备列表、详情、下线）
  - 网络测速 API（开始测速、测速历史、服务器列表）
  - 故障报修 API（提交报修、上传图片、报修记录、评价）
- NetworkRepositoryImpl Repository 实现

**Domain 层（领域层）** ✅
- NetworkRepository 接口定义
  - 网络账号管理接口
  - 在线设备管理接口
  - 网络测速接口
  - 故障报修接口

**Presentation 层（表现层）** ✅ 75% 完成
- NetworkProviders 状态管理
  - 依赖注入 Provider
  - 网络账号 Provider
  - 在线设备 Provider
  - 网络测速 Provider
  - 故障报修 Provider
- SpeedTestPage 网络测速页面 ✅
  - 空闲状态（未开始测速）
  - 测速中状态（加载动画）
  - 测速结果状态（质量评级、速度指标、网络指标）
  - 错误状态（错误提示、重试）
  - 精美的 UI 设计（Material Design 3）
- NetworkAccountPage 网络账号管理页面 ✅
  - 账号信息卡片（用户名、状态、到期时间）
  - 余额卡片（显示余额、充值按钮）
  - 流量统计卡片（进度条、已用/剩余流量）
  - 套餐信息卡片（套餐名称、价格、流量）
  - 快捷操作（流量历史、消费记录、套餐管理）
  - 充值对话框
  - 下拉刷新支持
- DeviceManagePage 在线设备管理页面 ✅
  - 设备统计（在线设备数、总流量）
  - 设备列表（卡片式展示）
  - 设备详情（底部抽屉）
  - 设备下线功能（确认对话框）
  - 当前设备标识
  - 设备图标（根据类型显示）
  - 在线时长和流量显示
  - 下拉刷新支持

**技术特性**
- ✅ Clean Architecture 分层架构
- ✅ Riverpod 状态管理
- ✅ Material Design 3 设计
- ✅ 完整的数据模型（4个模型）
- ✅ 统一的 API 接口（20+ 个方法）
- ✅ 响应式 UI 设计
- ✅ 质量评级算法
- ✅ JSON 序列化支持

**待完成功能**
- 测速历史页面
- 故障报修页面
- 集成 network_diagnostic_kit

### 开发统计

- **Phase 3 用时**: 1天（进行中）
- **完成功能**: 网络测速、网络账号管理、在线设备管理
- **数据模型**: 4个
- **API 方法**: 20+ 个
- **Provider**: 10+ 个
- **页面**: 3个（75% 完成）

## [0.2.0] - 2026-03-11

### 新增

#### MVP 核心功能 ✅✨

Phase 2 完成！MVP 已具备基本可用功能。

**主应用框架** ✅

启动页（SplashPage）：
- 精美的启动动画（淡入+缩放效果）
- 自动检查登录状态
- 智能路由跳转
- 渐变背景设计

主框架页（MainPage）：
- 底部导航栏（首页、网络、我的）
- IndexedStack 页面切换（保持状态）
- Material Design 3 风格

Dashboard 首页：
- 用户信息卡片
- 快捷功能入口（网络账号、在线设备、网络测速、故障报修）
- 公告通知栏
- 常用服务列表（课程表、成绩查询、教室查询、图书馆）
- 下拉刷新支持
- 集成 Riverpod 状态管理

**Feature 层包**

feature_auth (v0.1.0) - 认证功能模块 ✅
- 完整的 Clean Architecture 架构
  - Data 层：LoginRequest/LoginResponse、AuthApi、AuthRepositoryImpl
  - Domain 层：LoginUseCase、LogoutUseCase
  - Presentation 层：LoginPage、LoginForm、AuthProvider
- 登录页面 UI
  - 学号/工号输入
  - 密码输入（支持显示/隐藏）
  - 记住密码选项
  - 忘记密码功能
  - 统一身份认证入口
  - 注册入口
  - 加载状态和错误提示
- 完整认证流程
  - Token 自动管理
  - 自动登录状态检查
  - 统一的异常处理
  - Riverpod 状态管理
- 集成 Core 层包（network, storage, auth, ui, router, utils）

feature_profile (v0.1.0) - 个人中心模块 ✅
- 用户信息头部
  - 用户头像（支持网络图片）
  - 用户名、邮箱、手机号显示
  - 未登录状态提示
- 账号管理（个人资料、修改密码、账号安全）
- 应用设置（消息通知、语言设置、主题设置）
- 其他功能（帮助与反馈、关于我们）
- 退出登录功能
  - 确认对话框
  - 集成 Riverpod 状态管理
  - 自动跳转
- 响应式 UI 设计
- Material Design 3 风格

### 技术特性

- ✅ Clean Architecture 分层架构
- ✅ Riverpod 状态管理
- ✅ Material Design 3 设计
- ✅ 响应式 UI
- ✅ 统一的视觉风格
- ✅ 完整的应用导航流程
- ✅ Token 自动管理
- ✅ 自动登录状态检查

### 开发统计

- **Phase 2 用时**: 1天
- **完成功能**: 认证模块、主应用框架、Dashboard、个人中心
- **代码质量**: 遵循 Clean Architecture 和最佳实践
- **可用性**: MVP 已具备基本可用功能

## [0.1.0] - 2026-03-11
- ✅ 登录页面 UI
  - 学号/工号输入
  - 密码输入（支持显示/隐藏）
  - 记住密码选项
  - 忘记密码功能
  - 统一身份认证入口
  - 注册入口
  - 加载状态和错误提示
- ✅ 登录表单组件（可复用）
- ✅ Clean Architecture 分层架构
- ✅ 集成 Core 层包
- 🚧 完整认证流程（开发中）
  - Repository 实现
  - UseCase 实现
  - 状态管理（Riverpod）
  - Token 管理
  - 自动登录

## [0.1.0] - 2026-03-11

### 新增

#### Toolkit 集成

**ToolkitInitializer 服务**
- 统一的 Toolkit 包初始化入口
- 集成 log_kit（日志系统）
  - 多级别日志（Debug、Info、Warning、Error）
  - 文件日志（自动轮转）
  - 远程日志上报
- 集成 crash_reporter_kit（崩溃收集）
  - 自动捕获未处理的异常
  - 崩溃信息收集和上报
  - Zone 异常捕获机制
- 集成 permission_kit（权限管理）
  - 统一的权限请求接口
  - 权限状态检查
- 便捷方法封装
  - `ToolkitInitializer.log()` - 记录日志
  - `ToolkitInitializer.logError()` - 记录错误
  - `ToolkitInitializer.reportCrash()` - 上报崩溃
- 完整的集成文档和最佳实践

**主应用更新**
- 更新 main.dart 添加 Toolkit 初始化
- 添加 Zone 异常捕获
- 优雅的错误处理（初始化失败不影响应用启动）

#### Core 层包（全部完成）✅

**core_network (v0.1.0)**
- 基于 Dio 的网络请求封装
- ApiClient 统一网络客户端
- NetworkConfig 网络配置管理
- ApiResponse 统一响应封装
- ApiException 统一异常处理
- 三个拦截器：
  - AuthInterceptor: Token 自动管理
  - NetworkLogInterceptor: 使用 log_kit 记录日志
  - ErrorInterceptor: 统一错误处理
- 支持 GET/POST/PUT/DELETE 请求
- 支持文件上传和下载
- Cookie 支持
- 4 个单元测试（全部通过）

**core_storage (v0.1.0)**
- StorageService: SharedPreferences 封装
  - 支持 String、Int、Double、Bool、StringList 类型
  - 提供默认值支持
  - 提供键管理功能
- SecureStorage: FlutterSecureStorage 封装
  - 用于存储敏感数据（Token、密码等）
  - 支持 Android 加密 SharedPreferences
  - 支持 iOS Keychain
  - 提供 Token 和密码快捷方法
- CacheManager: 带过期时间的缓存管理
  - 支持自定义过期时间
  - 自动清理过期缓存
  - 支持泛型数据类型
  - JSON 序列化支持
- 16 个单元测试（全部通过）

#### 项目基础设施

- Monorepo 架构（使用 melos 管理）
- 三层架构设计（Core、Features、Shared）
- Toolkit 包独立仓库管理
- 完整的文档体系
- 代码分析配置
- Git 配置和忽略规则

#### 文档

- README.md: 项目说明
- docs/architecture.md: 架构设计文档
- docs/toolkit_packages.md: Toolkit 包说明
- docs/toolkit_local_development.md: 本地开发指南
- docs/repository_strategy.md: 仓库策略
- docs/features.md: 功能规划
- docs/DEVELOPMENT_ROADMAP.md: 开发路线图
- docs/DEVELOPMENT_PROGRESS.md: 开发进度跟踪
- CONTRIBUTING.md: 贡献指南
- CHANGELOG.md: 变更日志
- COMMIT_PLAN.md: 提交计划

### 技术栈

- Flutter SDK: >=3.5.0
- Dart SDK: >=3.0.0
- 包管理: melos
- 网络请求: dio ^5.4.0
- 本地存储: shared_preferences ^2.2.0
- 安全存储: flutter_secure_storage ^9.0.0
- 日志管理: log_kit (from GitHub: h1s97x/LogKit)

### 质量保证

- 单元测试覆盖率: 100% (core_network, core_storage)
- 测试用例总数: 20 个（core_network: 4, core_storage: 16）
- 代码分析: 无诊断问题
- 代码规范: 遵循 Dart 官方规范

### 平台支持

- ✅ Android
- ✅ iOS
- ✅ Windows
- ⏳ Linux (计划中)
- ⏳ macOS (计划中)
- ⏳ Web (计划中)

## 开发计划

### Phase 1: Core层基础包开发 (Week 1-2)

- [x] core_network (已完成)
- [x] core_storage (已完成)
- [ ] core_auth (进行中)
- [ ] core_ui (待开发)
- [ ] core_router (待开发)
- [ ] core_utils (待开发)

### Phase 2: Features层开发 (Week 3-4)

- [ ] feature_auth (待开发)
- [ ] feature_home (待开发)
- [ ] feature_profile (待开发)
- [ ] feature_network_service (待开发)

### Phase 3: 集成和测试 (Week 5-6)

- [ ] 集成测试
- [ ] UI 测试
- [ ] 性能测试
- [ ] 文档完善

### Phase 4: 发布准备 (Week 7-8)

- [ ] Beta 测试
- [ ] Bug 修复
- [ ] 发布准备
- [ ] v1.0.0 发布

## 已知问题

- 后端 API 接口尚未就绪，需要 Mock 数据开发
- Toolkit 包的稳定性需要在实际使用中验证

## 未来版本计划

### v0.2.0 (预计 2026-03-18)

- core_auth 包实现
- core_ui 包实现
- core_router 包实现
- core_utils 包实现

### v0.3.0 (预计 2026-04-01)

- feature_auth 包实现
- feature_home 包实现
- feature_profile 包实现

### v1.0.0 (预计 2026-04-15)

- MVP 功能完成
- 完整的测试覆盖
- 文档完善
- 正式发布

---

**项目**: SDU-SNA (OpenSNA)  
**当前版本**: v0.1.0  
**最后更新**: 2026-03-11
