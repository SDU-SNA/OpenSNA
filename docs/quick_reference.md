# 快速参考手册

## Melos常用命令

```bash
# 初始化项目（首次或拉取代码后）
melos bootstrap

# 开发常用
melos run analyze          # 代码分析
melos run test            # 运行测试
melos run format          # 格式化代码
melos run clean           # 清理构建

# 依赖管理
melos run get             # 获取依赖
melos run upgrade         # 升级依赖
melos run outdated        # 检查过期依赖

# 针对特定包
melos run analyze:core    # 只分析core包
melos run test:features   # 只测试feature包

# 代码生成（Riverpod等）
melos run generate

# 版本管理
melos version             # 交互式版本更新
melos version --all       # 统一更新所有包版本

# 在所有包中执行命令
melos exec -- <command>

# 在特定包中执行
melos exec --scope="core_*" -- <command>
melos exec --scope="feature_network_service" -- <command>
```

## Flutter常用命令

```bash
# 运行应用
flutter run                    # 默认设备
flutter run -d android        # Android
flutter run -d windows        # Windows

# 构建
flutter build apk --release   # Android APK
flutter build appbundle       # Android AAB
flutter build windows         # Windows

# 开发工具
flutter doctor               # 检查环境
flutter devices              # 列出设备
flutter clean                # 清理
flutter pub get              # 获取依赖
flutter pub upgrade          # 升级依赖
flutter analyze              # 代码分析
flutter test                 # 运行测试
dart format .                # 格式化代码
```

## Git工作流

```bash
# 创建功能分支
git checkout -b feature/功能名称

# 提交代码
git add .
git commit -m "feat(包名): 描述"

# 推送
git push origin feature/功能名称

# 更新主分支
git checkout develop
git pull origin develop

# 合并功能分支
git merge feature/功能名称

# 删除功能分支
git branch -d feature/功能名称
```

## 提交信息规范

```
<type>(<scope>): <subject>

type:
  feat     - 新功能
  fix      - 修复bug
  docs     - 文档
  style    - 格式
  refactor - 重构
  test     - 测试
  chore    - 构建/工具

scope:
  包名或模块名

示例:
  feat(core_network): 添加请求重试机制
  fix(feature_academic): 修复课程表显示bug
  docs(architecture): 更新架构文档
```

## 项目结构

```
opensna/
├── lib/                          # 主应用
├── packages/
│   ├── core/                     # 核心包
│   │   ├── core_network         # 网络层
│   │   ├── core_storage         # 存储层
│   │   ├── core_auth            # 认证层
│   │   ├── core_ui              # UI基础
│   │   ├── core_router          # 路由层
│   │   └── core_utils           # 工具层
│   ├── features/                 # 功能包
│   │   ├── feature_network_service    # 网络服务
│   │   ├── feature_campus_info        # 校园资讯
│   │   ├── feature_convenience        # 便民服务
│   │   ├── feature_academic           # 学习工具
│   │   ├── feature_community          # 社区互动
│   │   └── feature_profile            # 个人中心
│   └── shared/                   # 共享包
│       ├── shared_widgets       # 共享组件
│       └── shared_models        # 共享模型
├── docs/                         # 文档
├── melos.yaml                    # Melos配置
└── pubspec.yaml                  # 主应用配置
```

## Package内部结构

```
package_name/
├── lib/
│   ├── src/
│   │   ├── data/              # 数据层
│   │   │   ├── models/        # 数据模型
│   │   │   ├── repositories/  # 仓库
│   │   │   └── datasources/   # 数据源
│   │   ├── domain/            # 领域层
│   │   │   ├── entities/      # 实体
│   │   │   └── usecases/      # 用例
│   │   └── presentation/      # 表现层
│   │       ├── pages/         # 页面
│   │       ├── widgets/       # 组件
│   │       └── providers/     # 状态管理
│   └── package_name.dart      # 导出文件
├── test/                       # 测试
├── pubspec.yaml
└── README.md
```

## 开发流程

### 1. 开始新功能
```bash
# 1. 更新代码
git checkout develop
git pull origin develop

# 2. 创建功能分支
git checkout -b feature/网络测速

# 3. 初始化依赖
melos bootstrap
```

### 2. 开发中
```bash
# 运行应用
flutter run

# 代码分析
melos run analyze

# 运行测试
melos run test

# 格式化代码
melos run format
```

### 3. 提交代码
```bash
# 1. 检查代码
melos run analyze
melos run test
melos run format:check

# 2. 提交
git add .
git commit -m "feat(feature_network_service): 添加网络测速功能"

# 3. 推送
git push origin feature/网络测速

# 4. 创建PR
# 在GitHub/GitLab上创建Pull Request
```

### 4. 代码审查
- 检查代码规范
- 运行CI测试
- 审查通过后合并

## 常见问题

### Q: 拉取代码后无法运行？
```bash
# 重新初始化
melos clean
melos bootstrap
flutter pub get
```

### Q: 修改了core包，其他包没有更新？
```bash
# 重新链接
melos bootstrap
```

### Q: 依赖冲突？
```bash
# 清理并重新获取
melos clean
rm pubspec.lock
rm pubspec_overrides.yaml
melos bootstrap
```

### Q: 如何添加新的package？
```bash
# 1. 创建package
cd packages/features
flutter create --template=package feature_new

# 2. 编辑 melos.yaml（已配置 packages/**)

# 3. 重新初始化
melos bootstrap

# 4. 在主应用添加依赖
# 编辑 pubspec.yaml
dependencies:
  feature_new:
    path: packages/features/feature_new

# 5. 获取依赖
flutter pub get
```

### Q: 如何调试特定package？
```bash
# 方法1: 在主应用中调试
flutter run

# 方法2: 创建example应用
cd packages/features/feature_network_service
mkdir example
cd example
flutter create .
# 然后在example中引用package进行调试
```

## 性能优化建议

### 开发时
- 使用热重载（r）而不是热重启（R）
- 只运行需要的测试
- 使用 `--dart-define` 传递环境变量

### 构建时
```bash
# 使用混淆和压缩
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# 分析包大小
flutter build apk --analyze-size
```

## 有用的VS Code插件

- Flutter
- Dart
- Pubspec Assist
- Flutter Riverpod Snippets
- Error Lens
- GitLens

## 有用的命令别名

在 `.bashrc` 或 `.zshrc` 中添加：

```bash
# Melos
alias mb='melos bootstrap'
alias ma='melos run analyze'
alias mt='melos run test'
alias mf='melos run format'
alias mc='melos run clean'

# Flutter
alias fr='flutter run'
alias frd='flutter run -d'
alias fba='flutter build apk --release'
alias fbw='flutter build windows'
alias fc='flutter clean'
alias fpg='flutter pub get'
```

## 资源链接

- [项目架构文档](./architecture.md)
- [功能需求文档](./features.md)
- [仓库管理策略](./repository_strategy.md)
- [快速开始指南](./getting_started.md)
- [Flutter文档](https://docs.flutter.dev/)
- [Riverpod文档](https://riverpod.dev/)
- [Melos文档](https://melos.invertase.dev/)
