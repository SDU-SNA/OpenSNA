# SDU网管会APP - 仓库管理策略

## 推荐方案：混合Monorepo + 选择性独立

### 仓库划分策略

#### 主仓库 (opensna)
```
opensna/
├── lib/                    # 主应用
├── packages/
│   ├── core/              # 核心包（保留在主仓库）
│   │   ├── core_network
│   │   ├── core_storage
│   │   ├── core_auth
│   │   ├── core_ui
│   │   ├── core_router
│   │   └── core_utils
│   ├── features/          # 业务功能包（保留在主仓库）
│   │   ├── feature_network_service
│   │   ├── feature_campus_info
│   │   ├── feature_convenience
│   │   ├── feature_academic
│   │   ├── feature_community
│   │   └── feature_profile
│   └── shared/            # 共享包（可选独立）
│       ├── shared_widgets
│       └── shared_models
└── docs/
```

**保留在主仓库的理由**：
- 这些包是SDU特定的，不会被其他项目使用
- 频繁修改，需要同步更新
- 团队规模小，不需要复杂的权限控制
- 简化开发流程

---

## 可独立的Package（如果需要）

### 1. shared_widgets（可独立）
如果你们网管会有多个项目，可以独立

**独立条件**：
- 组件足够通用
- 有其他项目需要使用
- 需要独立维护和版本控制

**仓库名**: `opensna_widgets`

**引用方式**：
```yaml
# pubspec.yaml
dependencies:
  shared_widgets:
    git:
      url: https://github.com/SDU-SNA/opensna_widgets.git
      ref: v1.0.0  # 使用tag
```

### 2. core_ui（可独立）
如果要建立统一的设计系统

**独立条件**：
- 设计规范稳定
- 多个项目共享
- 需要设计团队独立维护

**仓库名**: `sdu_design_system`

---

## 实施建议

### 阶段一：全部Monorepo（当前阶段）
**时间**: MVP - v1.0

**原因**：
- 快速迭代，功能不稳定
- 频繁重构
- 团队磨合期

**配置**：
```yaml
# pubspec.yaml
dependencies:
  core_network:
    path: packages/core/core_network
  feature_network_service:
    path: packages/features/feature_network_service
```

### 阶段二：选择性独立（v1.5+）
**时间**: 功能稳定后

**独立候选**：
1. `shared_widgets` - 如果有其他项目需要
2. `core_ui` - 如果要建立设计系统

**保留在主仓库**：
- 所有 core_* 包（除了 core_ui）
- 所有 feature_* 包
- shared_models

---

## Monorepo工具推荐

### 1. Melos（推荐）
Flutter/Dart生态的Monorepo工具

#### 安装
```bash
dart pub global activate melos
```

#### 配置 melos.yaml
```yaml
name: opensna
packages:
  - packages/**

command:
  bootstrap:
    # 自动链接本地包
    usePubspecOverrides: true

scripts:
  # 分析所有包
  analyze:
    run: melos exec -- flutter analyze
    description: 分析所有包的代码

  # 测试所有包
  test:
    run: melos exec -- flutter test
    description: 运行所有包的测试

  # 格式化代码
  format:
    run: melos exec -- dart format .
    description: 格式化所有包的代码

  # 清理
  clean:
    run: melos exec -- flutter clean
    description: 清理所有包

  # 获取依赖
  get:
    run: melos exec -- flutter pub get
    description: 获取所有包的依赖

  # 版本管理
  version:
    run: melos version --no-git-tag-version
    description: 更新包版本
```

#### 常用命令
```bash
# 初始化（链接所有本地包）
melos bootstrap

# 运行所有测试
melos run test

# 分析所有代码
melos run analyze

# 格式化所有代码
melos run format

# 清理所有包
melos run clean

# 在所有包中执行命令
melos exec -- flutter pub upgrade

# 只在特定包中执行
melos exec --scope="core_*" -- flutter analyze
```

### 2. 工作区配置（Workspace）
不使用Melos也可以手动配置

#### 创建 pubspec_overrides.yaml（自动生成）
```yaml
# 这个文件会被 melos bootstrap 自动生成
# 用于覆盖依赖，使用本地路径
dependency_overrides:
  core_network:
    path: packages/core/core_network
  core_storage:
    path: packages/core/core_storage
  # ... 其他包
```

---

## Git工作流

### 分支策略

```
main (生产)
  ↑
develop (开发)
  ↑
feature/* (功能分支)
  ↑
package/* (包开发分支)
```

### 提交规范

```bash
# 格式
<type>(<scope>): <subject>

# 示例
feat(core_network): 添加请求重试机制
fix(feature_academic): 修复课程表显示bug
docs(architecture): 更新架构文档
refactor(core_ui): 重构主题系统
test(feature_profile): 添加个人中心测试
```

**Type类型**：
- `feat`: 新功能
- `fix`: 修复bug
- `docs`: 文档
- `style`: 格式（不影响代码运行）
- `refactor`: 重构
- `test`: 测试
- `chore`: 构建/工具

**Scope范围**：
- 包名（如 `core_network`, `feature_academic`）
- 或功能模块（如 `auth`, `ui`）

### 示例工作流

```bash
# 1. 创建功能分支
git checkout -b feature/network-speedtest

# 2. 开发（可能涉及多个包）
# 修改 packages/features/feature_network_service/...
# 修改 packages/core/core_network/...

# 3. 提交
git add .
git commit -m "feat(feature_network_service): 添加网络测速功能"

# 4. 推送
git push origin feature/network-speedtest

# 5. 创建PR
# 在GitHub/GitLab上创建Pull Request

# 6. 代码审查通过后合并到develop
git checkout develop
git merge feature/network-speedtest

# 7. 定期合并到main发版
```

---

## CI/CD配置

### GitHub Actions示例

#### .github/workflows/ci.yml
```yaml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          channel: 'stable'
      
      - name: Install Melos
        run: dart pub global activate melos
      
      - name: Bootstrap
        run: melos bootstrap
      
      - name: Analyze
        run: melos run analyze
      
      - name: Test
        run: melos run test
      
      - name: Check format
        run: melos run format --set-exit-if-changed

  build-android:
    needs: analyze
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/app-release.apk

  build-windows:
    needs: analyze
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      
      - name: Build Windows
        run: flutter build windows --release
      
      - name: Upload Windows Build
        uses: actions/upload-artifact@v3
        with:
          name: windows-release
          path: build/windows/runner/Release/
```

---

## 版本管理

### 语义化版本（Semantic Versioning）

```
主版本.次版本.修订号
MAJOR.MINOR.PATCH

例如: 1.2.3
```

**规则**：
- MAJOR: 不兼容的API修改
- MINOR: 向下兼容的功能新增
- PATCH: 向下兼容的bug修复

### 版本同步策略

#### 方案A: 统一版本（推荐）
所有包使用相同版本号

```yaml
# 所有包都是 0.1.0
core_network: 0.1.0
core_storage: 0.1.0
feature_network_service: 0.1.0
```

**优点**：
- 版本管理简单
- 兼容性清晰
- 发版统一

**使用Melos管理**：
```bash
# 统一升级所有包版本
melos version --all
```

#### 方案B: 独立版本
每个包独立版本号

```yaml
core_network: 1.2.0
core_storage: 1.1.0
feature_network_service: 0.5.0
```

**优点**：
- 反映真实变更
- 独立演进

**缺点**：
- 管理复杂
- 需要仔细处理依赖

---

## 依赖管理

### 本地开发
```yaml
# pubspec.yaml
dependencies:
  core_network:
    path: packages/core/core_network
```

### 发布后（如果独立仓库）
```yaml
# pubspec.yaml
dependencies:
  core_network:
    git:
      url: https://github.com/sdu-network-admin/core_network.git
      ref: v1.0.0
```

### 私有pub服务器（可选）
如果不想公开代码，可以搭建私有pub服务器

```yaml
# pubspec.yaml
dependencies:
  core_network:
    hosted:
      name: core_network
      url: https://pub.sdu.edu.cn
    version: ^1.0.0
```

---

## 目录结构最佳实践

### 推荐结构（Monorepo）
```
opensna/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── release.yml
├── lib/                    # 主应用
├── packages/
│   ├── core/
│   │   ├── core_network/
│   │   │   ├── lib/
│   │   │   ├── test/
│   │   │   ├── pubspec.yaml
│   │   │   └── README.md
│   │   └── ...
│   ├── features/
│   └── shared/
├── docs/
├── melos.yaml
├── pubspec.yaml
├── .gitignore
└── README.md
```

### .gitignore 配置
```gitignore
# Flutter
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/
flutter_*.png

# Melos
.melos_tool/
pubspec_overrides.yaml

# IDE
.idea/
.vscode/
*.iml
*.ipr
*.iws

# OS
.DS_Store
Thumbs.db

# 不要忽略 melos.yaml
!melos.yaml
```

---

## 何时考虑独立仓库？

### 独立的信号：
1. ✅ 包被3个以上项目使用
2. ✅ 包有独立的维护团队
3. ✅ 包需要独立的发版周期
4. ✅ 包足够稳定，API很少变化
5. ✅ 需要精细的权限控制

### 保持Monorepo的信号：
1. ✅ 团队规模小（<10人）
2. ✅ 快速迭代阶段
3. ✅ 包之间耦合度高
4. ✅ 频繁跨包重构
5. ✅ 只有一个主项目使用

---

## 总结建议

### 对于SDU网管会项目：

**现阶段（MVP - v1.0）**：
- ✅ 使用Monorepo
- ✅ 所有包在主仓库
- ✅ 使用Melos管理
- ✅ 统一版本号

**未来（v2.0+）**：
- 如果有其他项目需要，考虑独立 `shared_widgets`
- 如果要建立设计系统，考虑独立 `core_ui`
- 其他包保持在主仓库

**不建议独立的包**：
- ❌ core_network（SDU特定）
- ❌ core_auth（SDU统一认证）
- ❌ 所有 feature_* 包（业务特定）

---

## 快速开始

```bash
# 1. 安装Melos
dart pub global activate melos

# 2. 初始化项目
melos bootstrap

# 3. 开发
# 正常开发，修改任何包

# 4. 测试
melos run test

# 5. 提交
git add .
git commit -m "feat(core_network): 添加新功能"
git push

# 6. 发版
melos version
git push --tags
```

---

## 参考资源

- [Melos文档](https://melos.invertase.dev/)
- [Monorepo最佳实践](https://monorepo.tools/)
- [语义化版本](https://semver.org/lang/zh-CN/)
- [Git工作流](https://www.atlassian.com/git/tutorials/comparing-workflows)
