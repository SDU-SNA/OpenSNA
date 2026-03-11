# SDU网管会APP - 开发路线图

## 文档信息
- **创建日期**: 2026-03-11
- **当前状态**: 架构设计完成，准备开始开发
- **目标版本**: MVP v0.1.0
- **预计完成**: 2026-04-08 (4周)

---

## 当前状态总结

### ✅ 已完成
1. **架构设计** - 完整的模块化架构设计
2. **功能规划** - 详细的功能需求清单
3. **Toolkit包架构** - 独立仓库架构（GitHub: h1s97x）
4. **文档体系** - 完善的开发文档
5. **项目配置** - pubspec.yaml、melos.yaml配置完成

### 🔨 进行中
- 无

### 📋 待开始
- Core层开发
- Feature层开发
- 主应用开发

---

## 开发路线图

### Phase 1: 基础设施搭建 (Week 1-2) 🎯 当前阶段

#### Week 1: Core层基础包开发

**目标**: 搭建核心基础设施，为业务开发做准备

##### 1.1 创建packages目录结构
```bash
mkdir -p packages/core
mkdir -p packages/features
mkdir -p packages/shared
```

##### 1.2 开发 core_network (网络层) - 优先级最高
**时间**: 2天

**功能清单**:
- [ ] 创建package结构
- [ ] 配置Dio实例
- [ ] 实现ApiClient基类
- [ ] 实现请求拦截器
  - [ ] Token拦截器
  - [ ] 日志拦截器（使用log_kit）
  - [ ] 错误拦截器
- [ ] 实现响应封装 (ApiResponse)
- [ ] 实现异常处理 (ApiException)
- [ ] 编写单元测试
- [ ] 编写README文档

**依赖**:
```yaml
dependencies:
  dio: ^5.4.0
  dio_cookie_manager: ^3.1.0
  cookie_jar: ^4.0.8
  log_kit:  # 使用Toolkit包
    git:
      url: https://github.com/h1s97x/LogKit.git
      ref: main
```

**关键文件**:
```
packages/core/core_network/
├── lib/
│   ├── src/
│   │   ├── api_client.dart
│   │   ├── api_response.dart
│   │   ├── api_exception.dart
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart
│   │   │   ├── log_interceptor.dart
│   │   │   └── error_interceptor.dart
│   │   └── config/
│   │       └── network_config.dart
│   └── core_network.dart
├── test/
└── pubspec.yaml
```

##### 1.3 开发 core_storage (存储层)
**时间**: 1.5天

**功能清单**:
- [ ] 创建package结构
- [ ] 实现SharedPreferences封装
- [ ] 实现SecureStorage封装
- [ ] 实现缓存管理器
- [ ] 实现数据序列化工具
- [ ] 编写单元测试
- [ ] 编写README文档

**依赖**:
```yaml
dependencies:
  shared_preferences: ^2.2.0
  flutter_secure_storage: ^9.0.0
  path_provider: ^2.1.0
```

##### 1.4 开发 core_auth (认证层)
**时间**: 1.5天

**功能清单**:
- [ ] 创建package结构
- [ ] 实现AuthService
- [ ] 实现TokenManager
- [ ] 实现登录/登出逻辑
- [ ] 实现Token刷新机制
- [ ] 实现生物识别认证（可选）
- [ ] 编写单元测试
- [ ] 编写README文档

**依赖**:
```yaml
dependencies:
  core_network:
    path: ../core_network
  core_storage:
    path: ../core_storage
```

##### 1.5 开发 core_ui (UI基础层)
**时间**: 1天

**功能清单**:
- [ ] 创建package结构
- [ ] 定义主题配置 (AppTheme)
- [ ] 定义颜色系统 (AppColors)
- [ ] 定义文字样式 (AppTextStyles)
- [ ] 实现通用组件
  - [ ] AppButton
  - [ ] AppTextField
  - [ ] LoadingWidget
  - [ ] EmptyWidget
  - [ ] ErrorWidget
- [ ] 编写README文档

#### Week 2: Core层完善 + Toolkit集成

##### 2.1 开发 core_router (路由层)
**时间**: 1天

**功能清单**:
- [ ] 创建package结构
- [ ] 定义路由配置
- [ ] 实现路由管理器
- [ ] 实现路由守卫
- [ ] 实现导航服务
- [ ] 编写README文档

##### 2.2 开发 core_utils (工具层)
**时间**: 0.5天（简化版）

**功能清单**:
- [ ] 创建package结构
- [ ] 实现日期工具类
- [ ] 实现字符串工具类
- [ ] 实现验证工具类
- [ ] 实现扩展方法
- [ ] 导出log_kit（方便使用）
- [ ] 编写单元测试
- [ ] 编写README文档

**注意**: ❌ 不包含日志功能（使用log_kit）

**依赖**:
```yaml
dependencies:
  intl: ^0.20.2
  log_kit:  # 导出使用
    git:
      url: https://github.com/h1s97x/LogKit.git
      ref: main
```

##### 2.3 集成Toolkit包
**时间**: 1天

**任务**:
- [ ] 配置log_kit
  - [ ] 初始化日志系统
  - [ ] 配置日志级别
  - [ ] 配置日志输出（Console + File）
  - [ ] 配置远程上报（可选）
- [ ] 配置crash_reporter_kit
  - [ ] 初始化崩溃收集
  - [ ] 配置上报地址
  - [ ] 测试崩溃捕获
  - [ ] 集成到main.dart
- [ ] 配置permission_kit
  - [ ] 测试权限请求
  - [ ] 编写权限使用示例
- [ ] 更新主应用配置
- [ ] 编写集成文档

**集成示例**:
```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化日志
  await LogKit.init(
    level: LogLevel.debug,
    enableFileLog: true,
    enableRemoteLog: true,
    remoteUrl: 'https://log.sdu.edu.cn/api/logs',
  );
  
  // 初始化崩溃收集
  await CrashReporterKit.init(
    apiUrl: 'https://crash.sdu.edu.cn/api/report',
    appVersion: '1.0.0',
  );
  
  // 捕获所有异常
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stack) {
    CrashReporterKit.report(error, stack);
  });
}
```

##### 2.4 Core层测试与文档
**时间**: 2天

**任务**:
- [ ] 完善所有Core包的单元测试
- [ ] 编写集成测试
- [ ] 完善API文档
- [ ] 编写使用示例
- [ ] 编写Toolkit集成指南
- [ ] Code Review

**节省的开发时间**: 通过复用Toolkit包，节省约2.5天开发时间 ✅
- ❌ 不需要开发日志功能
- ❌ 不需要开发崩溃收集
- ❌ 不需要开发权限管理

---

### Phase 2: MVP核心功能开发 (Week 3-4)

#### Week 3: 认证模块 + 主应用框架

##### 3.1 开发 feature_auth (认证功能)
**时间**: 2天

**功能清单**:
- [ ] 创建feature package
- [ ] 实现登录页面
  - [ ] UI设计
  - [ ] 表单验证
  - [ ] 登录逻辑
  - [ ] 错误处理
- [ ] 实现登录状态管理 (Riverpod)
- [ ] 集成统一身份认证API
- [ ] 实现记住密码功能
- [ ] 实现自动登录
- [ ] 编写测试
- [ ] 编写文档

**页面结构**:
```
packages/features/feature_auth/
├── lib/
│   ├── src/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── datasources/
│   │   │       └── auth_api.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       └── logout_usecase.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── login_page.dart
│   │       ├── widgets/
│   │       │   └── login_form.dart
│   │       └── providers/
│   │           └── auth_provider.dart
│   └── feature_auth.dart
```

##### 3.2 搭建主应用框架
**时间**: 2天

**任务**:
- [ ] 创建主应用入口 (main.dart)
- [ ] 配置应用初始化
  - [ ] 初始化Toolkit包
  - [ ] 初始化Core包
  - [ ] 配置路由
  - [ ] 配置主题
- [ ] 实现启动页
- [ ] 实现首次引导页
- [ ] 实现底部导航栏
- [ ] 实现侧边栏（如需要）
- [ ] 配置权限请求
- [ ] 编写文档

##### 3.3 开发 feature_dashboard (首页)
**时间**: 1天

**功能清单**:
- [ ] 创建feature package
- [ ] 实现首页布局
- [ ] 实现功能入口卡片
- [ ] 实现快捷操作
- [ ] 实现公告轮播
- [ ] 编写文档

#### Week 4: 网络服务核心功能

##### 4.1 开发 feature_network_service (网络服务)
**时间**: 3天

**功能清单**:
- [ ] 创建feature package
- [ ] 实现网络账号管理页面
  - [ ] 余额查询
  - [ ] 流量统计
  - [ ] 套餐信息
- [ ] 实现在线设备管理页面
  - [ ] 设备列表
  - [ ] 设备详情
  - [ ] 设备下线
- [ ] 实现数据模型
- [ ] 实现Repository
- [ ] 实现状态管理
- [ ] 编写测试
- [ ] 编写文档

**页面结构**:
```
packages/features/feature_network_service/
├── lib/
│   ├── src/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── network_account.dart
│   │   │   │   └── device_info.dart
│   │   │   └── repositories/
│   │   │       └── network_repository.dart
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── account_page.dart
│   │       │   └── device_manage_page.dart
│   │       ├── widgets/
│   │       └── providers/
│   └── feature_network_service.dart
```

##### 4.2 开发 feature_profile (个人中心)
**时间**: 1.5天

**功能清单**:
- [ ] 创建feature package
- [ ] 实现个人资料页面
- [ ] 实现设置页面
  - [ ] 账号设置
  - [ ] 通知设置
  - [ ] 通用设置
- [ ] 实现关于页面
- [ ] 编写文档

##### 4.3 MVP集成测试
**时间**: 0.5天

**任务**:
- [ ] 端到端测试
- [ ] 性能测试
- [ ] 兼容性测试
- [ ] Bug修复
- [ ] 文档完善

---

### Phase 3: v1.0功能扩展 (Week 5-8)

#### Week 5-6: 网络工具 + 校园资讯

##### 5.1 集成 network_diagnostic_kit
**时间**: 2天

**任务**:
- [ ] 在feature_network_service中集成
- [ ] 实现网络测速页面
- [ ] 实现网络诊断页面
- [ ] 实现测速历史记录
- [ ] 编写文档

##### 5.2 开发网络故障报修
**时间**: 2天

**任务**:
- [ ] 实现报修表单页面
- [ ] 实现图片上传
- [ ] 实现报修记录查询
- [ ] 实现维修进度跟踪
- [ ] 编写文档

##### 5.3 开发 feature_campus_info (校园资讯)
**时间**: 2天

**任务**:
- [ ] 创建feature package
- [ ] 实现公告列表页面
- [ ] 实现公告详情页面
- [ ] 实现文章列表页面
- [ ] 实现文章详情页面
- [ ] 实现搜索功能
- [ ] 实现收藏功能
- [ ] 编写文档

#### Week 7-8: 学习工具 + 便民服务

##### 7.1 开发 feature_academic (学习工具)
**时间**: 3天

**任务**:
- [ ] 创建feature package
- [ ] 实现课程表页面
  - [ ] 周视图
  - [ ] 日视图
  - [ ] 课程详情
- [ ] 实现成绩查询页面
- [ ] 实现考试安排页面
- [ ] 编写文档

##### 7.2 开发 feature_convenience (便民服务)
**时间**: 3天

**任务**:
- [ ] 创建feature package
- [ ] 实现教室查询页面
- [ ] 实现图书馆服务页面
- [ ] 实现校车服务页面
- [ ] 实现校园地图页面（可选）
- [ ] 编写文档

##### 7.3 v1.0测试与优化
**时间**: 2天

**任务**:
- [ ] 完整功能测试
- [ ] 性能优化
- [ ] UI/UX优化
- [ ] Bug修复
- [ ] 文档完善
- [ ] 准备发布

---

## 开发优先级

### 🔴 P0 - 必须完成 (MVP)
1. Core层所有包
2. feature_auth (认证)
3. feature_network_service (网络账号 + 设备管理)
4. feature_dashboard (首页)
5. feature_profile (个人中心基础)
6. log_kit + crash_reporter_kit 集成

### 🟡 P1 - 重要功能 (v1.0)
1. network_diagnostic_kit 集成
2. 网络故障报修
3. feature_campus_info (公告 + 文章)
4. feature_academic (课程表 + 成绩 + 考试)
5. feature_convenience (教室 + 图书馆 + 校车)

### 🟢 P2 - 增强功能 (v1.5+)
1. hardware_info_kit 集成
2. system_monitor_kit 集成
3. device_security_kit 集成
4. 社区功能
5. 数据统计

---

## 技术债务管理

### 已知技术债务
- 无（新项目）

### 需要关注的点
1. **性能优化**: 列表加载、图片缓存
2. **错误处理**: 统一的错误处理机制
3. **测试覆盖**: 保持80%+的测试覆盖率
4. **文档维护**: 及时更新文档
5. **代码规范**: 遵循Dart代码规范

---

## 团队分工建议

### 后端开发 (2人)
- API设计与开发
- 数据库设计
- 接口文档编写

### 前端开发 (3人)
- **开发者A**: Core层 + 主应用框架
- **开发者B**: feature_auth + feature_network_service
- **开发者C**: feature_dashboard + feature_profile

### 测试 (1人)
- 单元测试
- 集成测试
- UI测试
- 性能测试

### UI/UX设计 (1人)
- 界面设计
- 交互设计
- 视觉规范

---

## 里程碑

### Milestone 1: Core层完成 (Week 2结束)
- ✅ 所有Core包开发完成
- ✅ Toolkit包集成完成
- ✅ 单元测试通过
- ✅ 文档完善

### Milestone 2: MVP完成 (Week 4结束)
- ✅ 认证功能完成
- ✅ 网络服务核心功能完成
- ✅ 首页和个人中心完成
- ✅ 可以进行内部测试

### Milestone 3: v1.0完成 (Week 8结束)
- ✅ 所有P1功能完成
- ✅ 测试通过
- ✅ 性能达标
- ✅ 准备发布

---

## 风险管理

### 技术风险
| 风险 | 影响 | 概率 | 应对措施 |
|------|------|------|---------|
| API接口不稳定 | 高 | 中 | 提前与后端对接，Mock数据开发 |
| 第三方库兼容性 | 中 | 低 | 选择成熟稳定的库，做好版本管理 |
| 性能问题 | 中 | 中 | 及时进行性能测试和优化 |
| 平台差异 | 中 | 中 | 做好平台适配，充分测试 |

### 进度风险
| 风险 | 影响 | 概率 | 应对措施 |
|------|------|------|---------|
| 需求变更 | 高 | 中 | 控制需求变更，优先完成核心功能 |
| 人员变动 | 高 | 低 | 做好文档，代码规范，便于交接 |
| 时间延期 | 中 | 中 | 合理安排优先级，必要时调整范围 |

---

## 下一步行动 (本周)

### 立即开始 (今天)
1. ✅ 创建packages目录结构
2. ✅ 开始开发 core_network
3. ✅ 配置开发环境

### 本周任务 (Week 1)
1. 完成 core_network 开发和测试
2. 完成 core_storage 开发和测试
3. 完成 core_auth 开发和测试
4. 完成 core_ui 基础组件

### 下周计划 (Week 2)
1. 完成 core_router 和 core_utils
2. 集成 log_kit 和 crash_reporter_kit
3. 完善Core层测试和文档
4. 准备开始Feature层开发

---

## 成功指标

### MVP阶段
- [ ] 用户可以登录
- [ ] 用户可以查看网络账号信息
- [ ] 用户可以管理在线设备
- [ ] 应用启动时间 < 2秒
- [ ] 无严重Bug

### v1.0阶段
- [ ] 所有P1功能可用
- [ ] 测试覆盖率 > 80%
- [ ] 性能指标达标
- [ ] 用户反馈良好
- [ ] 准备上线

---

## 参考资料

### 开发文档
- [架构设计文档](./architecture.md)
- [功能需求清单](./features.md)
- [快速开始指南](./getting_started.md)
- [Toolkit包文档](./toolkit_packages.md)
- [Toolkit vs Core 功能分析](./toolkit_vs_core_analysis.md) ⭐ 新增

### 技术文档
- [Flutter文档](https://docs.flutter.dev/)
- [Riverpod文档](https://riverpod.dev/)
- [Dio文档](https://pub.dev/packages/dio)

### Toolkit包文档
- [HardwareInfoKit](https://github.com/h1s97x/HardwareInfoKit)
- [NetworkDiagnosticKit](https://github.com/h1s97x/NetworkDiagnosticKit)
- [LogKit](https://github.com/h1s97x/LogKit)
- [CrashReporterKit](https://github.com/h1s97x/CrashReporterKit)
- [SystemMonitorKit](https://github.com/h1s97x/SystemMonitorKit)
- [DeviceSecurityKit](https://github.com/h1s97x/DeviceSecurityKit)
- [PermissionKit](https://github.com/h1s97x/PermissionKit)

---

**文档维护**: 每周更新进度，及时调整计划  
**最后更新**: 2026-03-11  
**下次更新**: 2026-03-18

