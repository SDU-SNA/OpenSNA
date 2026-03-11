# 山东大学网管会应用

## 项目简介

山东大学网管会一站式服务应用，为山东大学师生提供便捷的校园服务。

## 平台支持

本应用仅支持以下平台：
- ✅ Android
- ✅ Windows

## 功能特性

### 第一期（MVP）
- ✅ 统一身份认证
- ✅ 校园卡服务
- ✅ 课表查询
- ✅ 成绩查询
- ✅ 考试安排

### 后续规划
- 空教室查询
- 图书馆服务
- 校园社区
- 网络服务
- 更多功能...

## 技术栈

- **框架**: Flutter 3.x
- **语言**: Dart 3.x
- **状态管理**: Provider + Riverpod
- **网络请求**: Dio
- **本地存储**: SharedPreferences + SecureStorage

### Toolkit包（独立仓库）

项目使用以下独立维护的Toolkit包，托管在 GitHub 账号 `h1s97x` 下：

| 包名 | 功能 | 仓库地址 |
|------|------|---------|
| hardware_info_kit | 硬件信息检测 | [HardwareInfoKit](https://github.com/h1s97x/HardwareInfoKit) |
| network_diagnostic_kit | 网络诊断工具 | [NetworkDiagnosticKit](https://github.com/h1s97x/NetworkDiagnosticKit) |
| log_kit | 日志管理 | [LogKit](https://github.com/h1s97x/LogKit) |
| crash_reporter_kit | 崩溃报告 | [CrashReporterKit](https://github.com/h1s97x/CrashReporterKit) |
| system_monitor_kit | 系统监控 | [SystemMonitorKit](https://github.com/h1s97x/SystemMonitorKit) |
| device_security_kit | 设备安全检测 | [DeviceSecurityKit](https://github.com/h1s97x/DeviceSecurityKit) |
| permission_kit | 权限管理 | [PermissionKit](https://github.com/h1s97x/PermissionKit) |

详细文档请参考：
- [Toolkit包架构文档](docs/toolkit_packages.md)
- [Toolkit包本地开发指南](docs/toolkit_local_development.md)

## 项目结构

```
opensna/
├── lib/
│   ├── core/                    # 核心模块
│   │   ├── config/              # 配置文件
│   │   ├── network/             # 网络层
│   │   ├── providers/           # 全局状态管理
│   │   ├── routes/              # 路由配置
│   │   ├── theme/               # 主题配置
│   │   └── utils/               # 工具类
│   ├── features/                # 功能模块（按功能划分）
│   │   ├── auth/                # 认证模块
│   │   │   ├── data/            # 数据层
│   │   │   ├── domain/          # 业务逻辑层
│   │   │   └── presentation/    # 展示层
│   │   ├── dashboard/           # 首页
│   │   ├── ecard/               # 校园卡
│   │   ├── timetable/           # 课表
│   │   └── ...                  # 其他功能模块
│   ├── shared/                  # 共享资源
│   │   ├── widgets/             # 通用组件
│   │   └── models/              # 数据模型
│   └── main.dart                # 应用入口
├── assets/                      # 资源文件
│   ├── images/                  # 图片
│   ├── icons/                   # 图标
│   └── fonts/                   # 字体
├── docs/                        # 文档
│   ├── architecture.md          # 架构设计文档
│   ├── toolkit_packages.md      # Toolkit包文档
│   └── ...                      # 其他文档
├── test/                        # 测试文件
└── pubspec.yaml                 # 依赖配置
```

**注意**: Toolkit包（如 `hardware_info_kit`、`network_diagnostic_kit` 等）采用独立仓库架构，不在主仓库中。详见 [Toolkit包本地开发指南](docs/toolkit_local_development.md)。

## 开始使用

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### 安装依赖

```bash
cd opensna
flutter pub get
```

### 运行应用

```bash
# Android
flutter run -d android

# Windows
flutter run -d windows

# 指定设备
flutter run -d <device_id>
```

### 构建应用

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# Windows
flutter build windows --release
```

## 开发规范

### 代码规范

- 遵循 Dart 官方代码规范
- 使用 `flutter_lints` 进行代码检查
- 私有成员使用 `_` 前缀
- 类名使用大驼峰命名
- 变量和方法使用小驼峰命名

### 提交规范

```
<type>: <subject>

<body>
```

**Type 类型**:
- `feat`: 新功能
- `fix`: Bug修复
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建/工具变动

### 分支管理

- `main`: 主分支，稳定版本
- `develop`: 开发分支
- `feature/*`: 功能分支
- `bugfix/*`: Bug修复分支
- `release/*`: 发布分支

## 架构设计

### Clean Architecture

项目采用 Clean Architecture 架构，每个功能模块分为三层：

1. **Presentation Layer（展示层）**
   - Pages: 页面
   - Widgets: 组件
   - Providers: 状态管理

2. **Domain Layer（业务逻辑层）**
   - Entities: 实体
   - Use Cases: 用例
   - Repositories: 仓库接口

3. **Data Layer（数据层）**
   - Models: 数据模型
   - Data Sources: 数据源
   - Repositories: 仓库实现

### 状态管理

- **Provider**: 用于全局状态（如认证状态、设置）
- **Riverpod**: 用于局部状态和依赖注入

### 网络请求

使用 Dio 进行网络请求，统一在 `ApiClient` 中管理：

```dart
final response = await ApiClient().get('/api/endpoint');
```

### 路由管理

使用命名路由，在 `AppRoutes` 中统一管理：

```dart
Navigator.pushNamed(context, AppRoutes.login);
```

## 测试

### 运行测试

```bash
# 运行所有测试
flutter test

# 运行特定测试
flutter test test/features/auth/auth_test.dart

# 生成覆盖率报告
flutter test --coverage
```

### 测试类型

- **单元测试**: 测试单个函数或类
- **Widget测试**: 测试UI组件
- **集成测试**: 测试完整流程

## 常见问题

### 1. 依赖安装失败

```bash
flutter clean
flutter pub get
```

### 2. 构建失败

检查 Flutter 和 Dart 版本是否符合要求：

```bash
flutter --version
dart --version
```

### 3. 热重载不生效

重启应用：

```bash
flutter run
```

## 贡献指南

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'feat: Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 联系方式

- 项目负责人: [联系方式]
- 技术支持: [联系方式]
- 问题反馈: [GitHub Issues](https://github.com/SDU-SNA/OpenSNA/issues)

## 更新日志

### v0.1.0 (2026-03-01)
- 初始化项目
- 搭建基础框架
- 实现认证系统
- 实现Dashboard页面

---

**开发团队**: 山东大学网管会  
**最后更新**: 2026-03-01
