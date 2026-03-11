# SDU-SNA 项目提交方案

## 提交原则

1. **清晰明确 (Clear and Concise)**: 提交信息清楚说明"做了什么"以及"为什么这么做"
2. **原子性 (Atomic)**: 每次提交只包含一个逻辑变更
3. **格式化 (Structured)**: 采用统一的格式，方便工具解析和生成 CHANGELOG

## 当前提交方案（Phase 1: Core层基础包开发）

## 当前提交方案（Phase 1: Core层基础包开发）

### 第一阶段：项目基础配置（7 个提交）

#### 1. 项目初始化

```bash
git commit -m "chore: 初始化 SDU-SNA 项目

- 创建 Flutter 项目基础结构
- 配置 packages 目录（core、features、shared）
- 添加 .metadata 文件"
```

#### 2. 项目配置文件

```bash
git commit -m "chore: 配置项目依赖和构建工具

- 添加 pubspec.yaml 定义项目元数据和依赖
- 配置 Flutter SDK 约束 >=3.5.0
- 配置 melos.yaml 用于 monorepo 管理
- 添加 pubspec_overrides.yaml.example 用于本地开发"
```

#### 3. Git 配置

```bash
git commit -m "chore: 配置 Git 忽略规则

- 添加 .gitignore 排除构建产物
- 排除 IDE 配置文件
- 排除 Toolkit 包目录（使用独立仓库）
- 排除 docs/archive/ 目录"
```

#### 4. 代码分析配置

```bash
git commit -m "chore: 添加代码分析配置

- 添加 analysis_options.yaml
- 启用 flutter_lints 规则集
- 配置严格的代码质量检查"
```

#### 5. 文档体系

```bash
git commit -m "docs: 建立项目文档体系

- 添加 README.md 项目说明
- 添加 docs/architecture.md 架构设计文档
- 添加 docs/toolkit_packages.md Toolkit包说明
- 添加 docs/toolkit_local_development.md 本地开发指南
- 添加 docs/repository_strategy.md 仓库策略
- 添加 docs/features.md 功能规划
- 添加 docs/DEVELOPMENT_ROADMAP.md 开发路线图"
```

#### 6. 贡献指南和变更日志

```bash
git commit -m "docs: 添加贡献指南和变更日志

- 添加 CONTRIBUTING.md 贡献指南
- 添加 CHANGELOG.md 变更日志
- 添加 COMMIT_PLAN.md 提交计划"
```

#### 7. 平台配置

```bash
git commit -m "chore: 配置 Android 和 Windows 平台

- 配置 Android 构建文件（Gradle Kotlin DSL）
- 配置 Windows 平台支持
- 添加平台特定配置文件"
```

### 第二阶段：Core层 - core_network 包（1 个提交）

#### 8. core_network 包实现

```bash
git commit -m "feat(core): 实现 core_network 网络层包

- 创建 core_network 包结构
- 实现 ApiClient 基于 Dio 的网络客户端
- 实现 NetworkConfig 网络配置
- 实现 ApiResponse 统一响应封装
- 实现 ApiException 异常处理
- 实现三个拦截器：
  - AuthInterceptor: Token 自动管理
  - NetworkLogInterceptor: 使用 log_kit 记录日志
  - ErrorInterceptor: 统一错误处理
- 支持 GET/POST/PUT/DELETE 请求
- 支持文件上传和下载
- 添加 16 个单元测试（全部通过）
- 编写完整的 README 文档

依赖:
- dio: ^5.4.0
- dio_cookie_manager: ^3.1.0
- cookie_jar: ^4.0.8
- log_kit (from GitHub: h1s97x/LogKit)"
```

### 第三阶段：Core层 - core_storage 包（1 个提交）

#### 9. core_storage 包实现

```bash
git commit -m "feat(core): 实现 core_storage 存储层包

- 创建 core_storage 包结构
- 实现 StorageService (SharedPreferences 封装)
  - 支持 String、Int、Double、Bool、StringList 类型
  - 提供默认值支持
  - 提供键管理功能
- 实现 SecureStorage (FlutterSecureStorage 封装)
  - 用于存储敏感数据（Token、密码等）
  - 提供 Token 和密码快捷方法
  - 支持 Android 加密 SharedPreferences
  - 支持 iOS Keychain
- 实现 CacheManager (带过期时间的缓存管理)
  - 支持自定义过期时间
  - 自动清理过期缓存
  - 支持泛型数据类型
  - JSON 序列化支持
- 添加 16 个单元测试（全部通过）
- 编写完整的 README 文档

依赖:
- shared_preferences: ^2.2.0
- flutter_secure_storage: ^9.0.0
- path_provider: ^2.1.0
- json_annotation: ^4.8.0"
```

### 第四阶段：开发进度文档（1 个提交）

#### 10. 开发进度跟踪

```bash
git commit -m "docs: 添加开发进度跟踪文档

- 添加 docs/DEVELOPMENT_PROGRESS.md
- 记录 Phase 1 进度（25% 完成）
- 记录已完成的包：core_network、core_storage
- 记录测试结果和代码质量指标
- 更新里程碑和下一步计划"
```

---

## 提交规范

### Type 类型

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档变更
- `style`: 代码格式（不影响代码运行）
- `refactor`: 重构
- `perf`: 性能优化
- `test`: 测试相关
- `chore`: 构建过程或辅助工具的变动
- `ci`: CI 配置变更

### Scope 范围

- `core`: Core 层包
- `features`: Features 层包
- `shared`: Shared 层包
- `toolkit`: Toolkit 包相关
- `docs`: 文档相关
- `example`: 示例应用

### 提交信息格式

```text
<类型>(<范围>): <简短描述>

<详细描述>
- 变更点 1
- 变更点 2
- 变更点 3
```

---

## 执行计划

### 准备工作

1. ✅ 确保所有文件已保存
2. ✅ 确保测试通过（core_network: 4个，core_storage: 16个）
3. ✅ 确保代码分析通过（无诊断问题）
4. ✅ 确保文档完整

### 执行步骤

按照上述 10 个提交逐个执行，每个提交：

1. 只包含一个逻辑变更
2. 提交信息清晰明确
3. 代码可编译可运行
4. 相关测试通过

### 提交命令

```bash
# 第一阶段：项目基础配置
git add .metadata lib/ test/
git commit -m "chore: 初始化 SDU-SNA 项目..."

git add pubspec.yaml melos.yaml pubspec_overrides.yaml.example
git commit -m "chore: 配置项目依赖和构建工具..."

git add .gitignore
git commit -m "chore: 配置 Git 忽略规则..."

git add analysis_options.yaml
git commit -m "chore: 添加代码分析配置..."

git add README.md docs/architecture.md docs/toolkit_packages.md docs/toolkit_local_development.md docs/repository_strategy.md docs/features.md docs/DEVELOPMENT_ROADMAP.md
git commit -m "docs: 建立项目文档体系..."

git add CONTRIBUTING.md CHANGELOG.md COMMIT_PLAN.md
git commit -m "docs: 添加贡献指南和变更日志..."

git add android/ windows/
git commit -m "chore: 配置 Android 和 Windows 平台..."

# 第二阶段：core_network
git add packages/core/core_network/
git commit -m "feat(core): 实现 core_network 网络层包..."

# 第三阶段：core_storage
git add packages/core/core_storage/
git commit -m "feat(core): 实现 core_storage 存储层包..."

# 第四阶段：进度文档
git add docs/DEVELOPMENT_PROGRESS.md
git commit -m "docs: 添加开发进度跟踪文档..."
```

### 推送到远程

```bash
# 推送到远程仓库
git push origin main

# 创建标签（可选，等到 MVP 完成后）
git tag -a v0.1.0 -m "Phase 1: Core层基础包完成"
git push origin v0.1.0
```

---

## 项目特点

### 核心功能

- ✅ Monorepo 架构（使用 melos 管理）
- ✅ 三层架构（Core、Features、Shared）
- ✅ Toolkit 包独立仓库管理
- ✅ 网络层封装（core_network）
- ✅ 存储层封装（core_storage）
- ✅ 完整的文档体系
- ✅ 单元测试覆盖

### 技术特性

- ✅ 使用 Dio 进行网络请求
- ✅ 使用 log_kit 进行日志管理（复用 Toolkit 包）
- ✅ 使用 SharedPreferences 进行本地存储
- ✅ 使用 FlutterSecureStorage 进行安全存储
- ✅ 支持缓存管理（带过期时间）
- ✅ 统一的错误处理机制
- ✅ Token 自动管理

### 质量保证

- ✅ 单元测试覆盖（20 个测试用例）
- ✅ 代码分析通过（无诊断问题）
- ✅ 完整文档覆盖
- ✅ 遵循 Dart 官方规范

### 设计理念

- 🎯 模块化：清晰的包结构和职责划分
- 🔧 可扩展：易于添加新功能和新包
- 📦 复用性：通过 Toolkit 包避免重复开发
- 🚀 性能：高效的网络和存储操作
- 🔒 类型安全：强类型数据模型
- 📝 文档完善：详细的使用说明和示例

---

## 项目结构

```text
sdu_sna/
├── packages/
│   ├── core/                             # Core 层
│   │   ├── core_network/                 # ✅ 网络层（已完成）
│   │   ├── core_storage/                 # ✅ 存储层（已完成）
│   │   ├── core_auth/                    # ⏳ 认证层（待开发）
│   │   ├── core_ui/                      # ⏳ UI 层（待开发）
│   │   ├── core_router/                  # ⏳ 路由层（待开发）
│   │   └── core_utils/                   # ⏳ 工具层（待开发）
│   ├── features/                         # Features 层（待开发）
│   └── shared/                           # Shared 层（待开发）
├── docs/                                 # 文档
│   ├── architecture.md
│   ├── toolkit_packages.md
│   ├── toolkit_local_development.md
│   ├── repository_strategy.md
│   ├── features.md
│   ├── DEVELOPMENT_ROADMAP.md
│   ├── DEVELOPMENT_PROGRESS.md
│   └── archive/                          # 归档文档（不上传）
├── android/                              # Android 平台
├── windows/                              # Windows 平台
├── lib/                                  # 主应用代码
├── test/                                 # 测试
├── pubspec.yaml                          # 项目依赖
├── melos.yaml                            # Monorepo 配置
├── README.md                             # 项目说明
├── CONTRIBUTING.md                       # 贡献指南
├── CHANGELOG.md                          # 变更日志
└── COMMIT_PLAN.md                        # 提交计划
```

---

## 版本信息

**项目名称**: SDU-SNA (OpenSNA)  
**当前版本**: v0.1.0-dev  
**当前阶段**: Phase 1 - Core层基础包开发  
**完成进度**: 25% (2/8 包完成)  
**提交方案**: 精简版本（10 个提交）

---

## 当前状态

### 已完成 ✅

- ✅ 项目结构创建
- ✅ 文档体系建立
- ✅ core_network 包实现（4 个测试通过）
- ✅ core_storage 包实现（16 个测试通过）
- ✅ 代码分析通过（无诊断问题）
- ✅ Toolkit 包架构设计

### 进行中 🔨

- 准备提交到 Git 仓库

### 待开发 ⏳

- core_auth 包
- core_ui 包
- core_router 包
- core_utils 包
- Features 层包
- Shared 层包

---

**准备日期**: 2026-03-11  
**项目**: SDU-SNA (OpenSNA)  
**阶段**: Phase 1  
**状态**: 准备提交 ✅

