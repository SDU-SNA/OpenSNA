# SDU网管会APP - 文档索引

## 项目概述

山东大学网络管理委员会一站式服务应用，采用模块化架构，支持Android和Windows平台。

---

## 核心文档

### 1. [架构设计文档](./architecture.md) 📐
完整的模块化架构设计，包括：
- Package结构总览
- Core层（6个核心包）
- Features层（6个业务功能包）
- Shared层（2个共享包）
- Toolkit层（通用工具包）
- 依赖关系图
- 开发规范

**适合**: 架构师、技术负责人、新成员了解项目结构

---

### 2. [功能需求清单](./features.md) ✅
详细的功能需求列表，包括：
- 7大功能模块
- 60+具体功能点
- 优先级划分（P0-P3）
- 4个版本迭代计划
- 技术要求和性能指标

**适合**: 产品经理、开发人员、测试人员

---

### 3. [仓库管理策略](./repository_strategy.md) 🗂️
仓库组织和管理方案，包括：
- Monorepo vs Multi-repo对比
- 推荐的混合方案
- Melos工具使用
- Git工作流
- CI/CD配置
- 版本管理策略

**适合**: 技术负责人、DevOps工程师

---

### 4. [通用工具包架构](./toolkit_packages.md) 🔧
独立的通用工具包设计，包括：
- 7个通用工具包规划
- 独立仓库架构（GitHub: h1s97x）
- hardware_info_kit（已完成）
- network_diagnostic_kit（已完成）
- log_kit（已完成）
- crash_reporter_kit（已完成）
- system_monitor_kit（已完成）
- device_security_kit（已完成）
- permission_kit（已完成）

**适合**: 工具包开发者、架构师

---

### 5. [Toolkit包本地开发指南](./toolkit_local_development.md) 💻
Toolkit包本地开发和测试指南，包括：
- 仓库克隆和设置
- 本地路径依赖配置
- pubspec_overrides.yaml使用
- 开发工作流
- 测试和发布流程
- 常见问题解答

**适合**: Toolkit包开发者、贡献者

---

### 6. [快速开始指南](./getting_started.md) 🚀
项目初始化和开发指南，包括：
- Package创建步骤
- 完整代码示例
- 第一个Package实现
- 第一个Feature实现
- 主应用集成
- 运行和构建

**适合**: 新成员、开发人员快速上手

---

### 7. [快速参考手册](./quick_reference.md) 📖
常用命令和开发流程，包括：
- Melos常用命令
- Flutter常用命令
- Git工作流
- 提交信息规范
- 项目结构
- 常见问题解答

**适合**: 所有开发人员日常参考

---

### 8. [network_diagnostic_kit开发模板](./network_diagnostic_kit_template.md) 📝
网络诊断工具包的完整代码模板，包括：
- 项目结构
- 数据模型
- 核心API
- 示例应用
- 实现指南

**适合**: 开发network_diagnostic_kit的工程师

---

### 9. [开发路线图](./DEVELOPMENT_ROADMAP.md) 🗺️
详细的开发计划和时间表，包括：
- 当前状态总结
- 4周MVP开发计划
- 8周v1.0开发计划
- 开发优先级
- 团队分工建议
- 里程碑和风险管理
- 下一步行动计划

**适合**: 项目经理、开发团队、所有成员了解开发进度

---

### 10. [Toolkit vs Core 功能分析](./toolkit_vs_core_analysis.md) 🔍
Toolkit包和Core层功能重叠分析，包括：
- 功能重叠识别
- 复用策略
- 分工明确
- 使用示例
- 开发时间节省分析

**适合**: 架构师、开发人员、避免重复开发

---

## 文档使用指南

### 新成员入职
1. 阅读 [架构设计文档](./architecture.md) 了解整体架构
2. 阅读 [功能需求清单](./features.md) 了解产品功能
3. 阅读 [开发路线图](./DEVELOPMENT_ROADMAP.md) 了解开发计划
4. 跟随 [快速开始指南](./getting_started.md) 搭建开发环境
5. 收藏 [快速参考手册](./quick_reference.md) 日常使用

### 开始开发
1. 查看 [开发路线图](./DEVELOPMENT_ROADMAP.md) 了解当前进度
2. 查看 [功能需求清单](./features.md) 确定开发任务
3. 参考 [架构设计文档](./architecture.md) 确定模块位置
4. 使用 [快速参考手册](./quick_reference.md) 中的命令
5. 遵循 [仓库管理策略](./repository_strategy.md) 的Git规范

### 开发工具包
1. 阅读 [通用工具包架构](./toolkit_packages.md) 了解设计
2. 阅读 [Toolkit包本地开发指南](./toolkit_local_development.md) 配置环境
3. 参考 [network_diagnostic_kit模板](./network_diagnostic_kit_template.md)
4. 查看已完成的Toolkit包实现（GitHub: h1s97x）
5. 遵循工具包开发规范

---

## 项目结构速览

```
sdu_sna/
├── lib/                          # 主应用
├── packages/
│   ├── core/                     # 核心基础包
│   │   ├── core_network         # 网络层
│   │   ├── core_storage         # 存储层
│   │   ├── core_auth            # 认证层
│   │   ├── core_ui              # UI基础
│   │   ├── core_router          # 路由层
│   │   └── core_utils           # 工具层
│   ├── features/                 # 业务功能包
│   │   ├── feature_network_service    # 网络服务
│   │   ├── feature_campus_info        # 校园资讯
│   │   ├── feature_convenience        # 便民服务
│   │   ├── feature_academic           # 学习工具
│   │   ├── feature_community          # 社区互动
│   │   └── feature_profile            # 个人中心
│   └── shared/                   # 共享包
│       ├── shared_widgets       # 共享组件
│       └── shared_models        # 共享模型
├── docs/                         # 文档（本目录）
├── melos.yaml                    # Melos配置
└── pubspec.yaml                  # 主应用配置

# Toolkit包（独立仓库，GitHub: h1s97x）
├── HardwareInfoKit              # 硬件检测工具
├── NetworkDiagnosticKit         # 网络诊断工具
├── LogKit                       # 日志管理
├── CrashReporterKit             # 崩溃报告
├── SystemMonitorKit             # 系统监控
├── DeviceSecurityKit            # 设备安全检测
└── PermissionKit                # 权限管理
```

---

## 开发流程

### 1. 功能开发流程
```
需求分析 → 架构设计 → 创建Package → 实现功能 → 单元测试 → 集成测试 → 代码审查 → 合并代码
```

### 2. 工具包开发流程
```
需求分析 → API设计 → 创建Plugin → 实现功能 → 编写文档 → 单元测试 → 示例应用 → 发布
```

### 3. 日常开发流程
```
拉取代码 → 创建分支 → 开发功能 → 本地测试 → 提交代码 → 创建PR → 代码审查 → 合并
```

---

## 技术栈

### 核心技术
- Flutter 3.19+
- Dart 3.0+
- Riverpod（状态管理）
- Dio（网络请求）

### 开发工具
- Melos（Monorepo管理）
- Git（版本控制）
- GitHub Actions（CI/CD）

### 平台支持
- Android 6.0+
- Windows 10+

---

## 开发规范

### 命名规范
- Package名: `snake_case` (如: `core_network`)
- 文件名: `snake_case` (如: `user_profile.dart`)
- 类名: `PascalCase` (如: `UserProfile`)
- 变量/方法: `camelCase` (如: `getUserProfile`)

### 提交规范
```
<type>(<scope>): <subject>

type: feat, fix, docs, style, refactor, test, chore
scope: 包名或模块名
subject: 简短描述

示例:
feat(core_network): 添加请求重试机制
fix(feature_academic): 修复课程表显示bug
```

### 代码规范
- 遵循 Dart 官方代码风格
- 使用 `flutter analyze` 检查代码
- 使用 `dart format` 格式化代码
- 单元测试覆盖率 > 80%

---

## 常用命令

### Melos命令
```bash
melos bootstrap          # 初始化项目
melos run analyze        # 代码分析
melos run test          # 运行测试
melos run format        # 格式化代码
melos run clean         # 清理构建
```

### Flutter命令
```bash
flutter run             # 运行应用
flutter build apk       # 构建APK
flutter test            # 运行测试
flutter analyze         # 代码分析
```

### Git命令
```bash
git checkout -b feature/xxx    # 创建功能分支
git add .                      # 添加文件
git commit -m "feat: xxx"      # 提交代码
git push origin feature/xxx    # 推送代码
```

---

## 资源链接

### 官方文档
- [Flutter文档](https://docs.flutter.dev/)
- [Dart文档](https://dart.dev/guides)
- [Riverpod文档](https://riverpod.dev/)
- [Melos文档](https://melos.invertase.dev/)

### 参考项目
- [DanXi](https://github.com/DanXi-Dev/DanXi) - 复旦大学校园应用
- [HardwareInfoKit](https://github.com/h1s97x/HardwareInfoKit) - 硬件检测工具
- [NetworkDiagnosticKit](https://github.com/h1s97x/NetworkDiagnosticKit) - 网络诊断工具
- 更多Toolkit包: [GitHub: h1s97x](https://github.com/h1s97x)

### 社区资源
- [Flutter中文网](https://flutter.cn/)
- [Pub.dev](https://pub.dev/) - Dart包仓库

---

## 联系方式

- 项目负责人: [待填写]
- 技术支持: [待填写]
- 问题反馈: [待填写]

---

## 更新日志

- 2026-03-11: 添加功能重叠分析
  - 创建 Toolkit vs Core 功能分析文档
  - 识别可复用功能，避免重复开发
  - 明确分工边界和使用策略
  - 更新开发路线图，节省2.5天开发时间
- 2026-03-11: 添加开发路线图
  - 创建详细的4周MVP开发计划
  - 创建8周v1.0开发计划
  - 明确开发优先级和团队分工
  - 添加里程碑和风险管理
- 2026-03-11: 更新Toolkit包架构
  - 采用独立仓库架构（GitHub: h1s97x）
  - 使用帕斯卡命名法（如: HardwareInfoKit）
  - 添加Toolkit包本地开发指南
  - 更新所有相关文档
- 2026-03-08: 初始版本，创建核心文档
  - 架构设计文档
  - 功能需求清单
  - 仓库管理策略
  - 通用工具包架构
  - 快速开始指南
  - 快速参考手册
  - network_diagnostic_kit模板

---

**文档维护**: 随项目开发持续更新
