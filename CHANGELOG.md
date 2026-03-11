# 更新日志

本项目的所有重要更改都将记录在此文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### 进行中

- Phase 1: Core层基础包开发（100% 完成）✅
- Phase 2: Toolkit包集成（准备开始）

## [0.1.0] - 2026-03-11

### 新增

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
