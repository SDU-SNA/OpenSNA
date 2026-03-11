# Toolkit包本地开发指南

## 概述

所有Toolkit包均采用独立仓库架构，托管在GitHub账号 `h1s97x` 下。本文档说明如何在本地开发和测试这些包。

## 仓库列表

| 仓库名 | Package名 | GitHub地址 |
|--------|-----------|-----------|
| HardwareInfoKit | hardware_info_kit | https://github.com/h1s97x/HardwareInfoKit |
| NetworkDiagnosticKit | network_diagnostic_kit | https://github.com/h1s97x/NetworkDiagnosticKit |
| LogKit | log_kit | https://github.com/h1s97x/LogKit |
| CrashReporterKit | crash_reporter_kit | https://github.com/h1s97x/CrashReporterKit |
| SystemMonitorKit | system_monitor_kit | https://github.com/h1s97x/SystemMonitorKit |
| DeviceSecurityKit | device_security_kit | https://github.com/h1s97x/DeviceSecurityKit |
| PermissionKit | permission_kit | https://github.com/h1s97x/PermissionKit |

---

## 本地开发设置

### 1. 克隆Toolkit包到本地

推荐的目录结构：

```
workspace/
├── OpenSNA/                    # 主应用仓库
├── HardwareInfoKit/            # Toolkit包
├── NetworkDiagnosticKit/
├── LogKit/
├── CrashReporterKit/
├── SystemMonitorKit/
├── DeviceSecurityKit/
└── PermissionKit/
```

克隆命令：

```bash
# 进入工作目录
cd workspace

# 克隆主应用
git clone https://github.com/SDU-SNA/OpenSNA.git

# 克隆Toolkit包
git clone https://github.com/h1s97x/HardwareInfoKit.git
git clone https://github.com/h1s97x/NetworkDiagnosticKit.git
git clone https://github.com/h1s97x/LogKit.git
git clone https://github.com/h1s97x/CrashReporterKit.git
git clone https://github.com/h1s97x/SystemMonitorKit.git
git clone https://github.com/h1s97x/DeviceSecurityKit.git
git clone https://github.com/h1s97x/PermissionKit.git
```

### 2. 使用本地路径依赖

在主应用的 `pubspec.yaml` 中，将Git依赖替换为本地路径：

```yaml
dependencies:
  # 本地开发时使用路径依赖
  hardware_info_kit:
    path: ../HardwareInfoKit
  network_diagnostic_kit:
    path: ../NetworkDiagnosticKit
  log_kit:
    path: ../LogKit
  crash_reporter_kit:
    path: ../CrashReporterKit
  system_monitor_kit:
    path: ../SystemMonitorKit
  device_security_kit:
    path: ../DeviceSecurityKit
  permission_kit:
    path: ../PermissionKit
```

### 3. 使用 pubspec_overrides.yaml（推荐）

为了不修改 `pubspec.yaml`，可以创建 `pubspec_overrides.yaml` 文件：

```yaml
# pubspec_overrides.yaml
dependency_overrides:
  hardware_info_kit:
    path: ../HardwareInfoKit
  network_diagnostic_kit:
    path: ../NetworkDiagnosticKit
  log_kit:
    path: ../LogKit
  crash_reporter_kit:
    path: ../CrashReporterKit
  system_monitor_kit:
    path: ../SystemMonitorKit
  device_security_kit:
    path: ../DeviceSecurityKit
  permission_kit:
    path: ../PermissionKit
```

**优点**：
- ✅ 不修改 `pubspec.yaml`
- ✅ 不会被提交到Git（已在 `.gitignore` 中）
- ✅ 本地开发和生产环境分离

### 4. 获取依赖

```bash
cd OpenSNA
flutter pub get
```

---

## 开发工作流

### 修改Toolkit包

1. 在Toolkit包目录中进行修改
2. 在主应用中测试修改
3. 提交到Toolkit包仓库

```bash
# 在Toolkit包目录
cd ../NetworkDiagnosticKit
git add .
git commit -m "feat: add new feature"
git push origin main

# 打标签发布版本
git tag v1.1.0
git push origin v1.1.0
```

### 更新主应用依赖

修改 `pubspec.yaml` 中的版本号：

```yaml
dependencies:
  network_diagnostic_kit:
    git:
      url: https://github.com/h1s97x/NetworkDiagnosticKit.git
      ref: v1.1.0  # 更新版本号
```

---

## 测试

### 测试单个Toolkit包

```bash
cd NetworkDiagnosticKit
flutter test
```

### 测试主应用

```bash
cd OpenSNA
flutter test
```

### 运行示例应用

每个Toolkit包都有 `example` 目录：

```bash
cd NetworkDiagnosticKit/example
flutter run
```

---

## 发布流程

### 1. 更新版本号

编辑 `pubspec.yaml`：

```yaml
version: 1.1.0  # 更新版本号
```

### 2. 更新 CHANGELOG.md

```markdown
## [1.1.0] - 2026-03-11

### Added
- 新增功能描述

### Changed
- 修改内容描述

### Fixed
- 修复问题描述
```

### 3. 提交并打标签

```bash
git add .
git commit -m "chore: release v1.1.0"
git tag v1.1.0
git push origin main --tags
```

### 4. 更新主应用依赖

在主应用的 `pubspec.yaml` 中更新版本：

```yaml
dependencies:
  network_diagnostic_kit:
    git:
      url: https://github.com/h1s97x/NetworkDiagnosticKit.git
      ref: v1.1.0
```

---

## 常见问题

### Q: 如何在多个项目中使用同一个Toolkit包？

A: 使用Git依赖，所有项目都引用同一个仓库：

```yaml
dependencies:
  network_diagnostic_kit:
    git:
      url: https://github.com/h1s97x/NetworkDiagnosticKit.git
      ref: v1.0.0
```

### Q: 如何快速切换本地开发和生产环境？

A: 使用 `pubspec_overrides.yaml`，它会自动被 `.gitignore` 忽略。

### Q: 如何处理Toolkit包之间的依赖？

A: 在Toolkit包的 `pubspec.yaml` 中声明依赖：

```yaml
# LogKit/pubspec.yaml
dependencies:
  device_security_kit:
    git:
      url: https://github.com/h1s97x/DeviceSecurityKit.git
      ref: v1.0.0
```

### Q: 如何回滚到旧版本？

A: 修改 `pubspec.yaml` 中的 `ref` 为旧版本标签：

```yaml
dependencies:
  network_diagnostic_kit:
    git:
      url: https://github.com/h1s97x/NetworkDiagnosticKit.git
      ref: v1.0.0  # 回滚到旧版本
```

---

## 最佳实践

### 1. 版本管理

- 遵循语义化版本（Semantic Versioning）
- 主版本：不兼容的API修改
- 次版本：向下兼容的功能新增
- 修订版本：向下兼容的bug修复

### 2. 分支策略

- `main`: 稳定版本
- `develop`: 开发版本
- `feature/*`: 功能分支
- `hotfix/*`: 紧急修复分支

### 3. 提交规范

使用 Conventional Commits：

- `feat`: 新功能
- `fix`: 修复bug
- `docs`: 文档更新
- `style`: 代码格式
- `refactor`: 重构
- `test`: 测试
- `chore`: 构建/工具

### 4. 文档维护

每个Toolkit包必须包含：
- README.md（中文）
- README_EN.md（英文）
- CHANGELOG.md（更新日志）
- GETTING_STARTED.md（快速开始）
- API文档

---

## 工具脚本

### 批量克隆脚本

创建 `clone_toolkits.sh`：

```bash
#!/bin/bash

# Toolkit包列表
TOOLKITS=(
  "HardwareInfoKit"
  "NetworkDiagnosticKit"
  "LogKit"
  "CrashReporterKit"
  "SystemMonitorKit"
  "DeviceSecurityKit"
  "PermissionKit"
)

# 克隆所有Toolkit包
for toolkit in "${TOOLKITS[@]}"; do
  echo "Cloning $toolkit..."
  git clone "https://github.com/h1s97x/$toolkit.git"
done

echo "All toolkits cloned successfully!"
```

### 批量更新脚本

创建 `update_toolkits.sh`：

```bash
#!/bin/bash

# Toolkit包列表
TOOLKITS=(
  "HardwareInfoKit"
  "NetworkDiagnosticKit"
  "LogKit"
  "CrashReporterKit"
  "SystemMonitorKit"
  "DeviceSecurityKit"
  "PermissionKit"
)

# 更新所有Toolkit包
for toolkit in "${TOOLKITS[@]}"; do
  if [ -d "$toolkit" ]; then
    echo "Updating $toolkit..."
    cd "$toolkit"
    git pull origin main
    cd ..
  fi
done

echo "All toolkits updated successfully!"
```

---

## 总结

- ✅ 所有Toolkit包采用独立仓库架构
- ✅ 使用 `pubspec_overrides.yaml` 进行本地开发
- ✅ 遵循语义化版本管理
- ✅ 保持文档完整和更新
- ✅ 使用Git标签管理版本

