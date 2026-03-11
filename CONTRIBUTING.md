# 贡献指南

感谢您对 SDU-SNA (OpenSNA) 项目的关注！本指南将帮助您为项目做出贡献。

## 项目架构

SDU-SNA 采用 Monorepo 架构，使用 melos 进行包管理。项目分为三层：

```text
sdu_sna/
├── packages/
│   ├── core/                    # Core 层：基础设施
│   │   ├── core_network/        # 网络层
│   │   ├── core_storage/        # 存储层
│   │   ├── core_auth/           # 认证层
│   │   ├── core_ui/             # UI 组件层
│   │   ├── core_router/         # 路由层
│   │   └── core_utils/          # 工具层
│   ├── features/                # Features 层：业务功能
│   └── shared/                  # Shared 层：共享代码
├── docs/                        # 文档
└── lib/                         # 主应用代码
```

## 开发环境设置

### 1. 安装依赖

```bash
# 克隆仓库
git clone https://github.com/your-org/sdu-sna.git
cd sdu-sna

# 安装 melos
dart pub global activate melos

# 安装所有包的依赖
melos bootstrap
```

### 2. 本地开发 Toolkit 包

如果需要本地开发 Toolkit 包，请参考 `docs/toolkit_local_development.md`。

## 添加新的 Core 包

### 步骤 1：创建包结构

```bash
cd packages/core
flutter create --template=package core_new_feature
cd core_new_feature
```

### 步骤 2：配置 pubspec.yaml

```yaml
name: core_new_feature
description: 新功能的描述
version: 0.1.0
publish_to: none

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  # 添加其他依赖

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

### 步骤 3：实现功能

在 `lib/src/` 目录下实现功能代码，在 `lib/core_new_feature.dart` 中导出。

### 步骤 4：编写测试

在 `test/` 目录下编写单元测试，确保测试覆盖率。

### 步骤 5：编写文档

创建 `README.md` 文档，包含：
- 功能说明
- 安装方法
- 使用示例
- API 文档

### 步骤 6：更新进度文档

在 `docs/DEVELOPMENT_PROGRESS.md` 中记录新包的开发进度。

## 代码风格指南

### Dart 代码

- 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 指南
- 使用 `dart format` 格式化代码
- 运行 `flutter analyze` 检查问题
- 为公共 API 添加文档注释
- 使用有意义的变量和方法名
- 保持方法简洁，单一职责

示例：

```dart
/// 获取用户信息
///
/// 参数:
/// - [userId]: 用户ID
///
/// 返回:
/// - [User]: 用户对象
///
/// 抛出:
/// - [ApiException]: 网络请求失败时抛出
Future<User> getUserInfo(String userId) async {
  try {
    final response = await apiClient.get('/users/$userId');
    return User.fromJson(response.data);
  } catch (e) {
    throw ApiException('获取用户信息失败: $e');
  }
}
```

### Kotlin 代码（Android）

- 遵循 Kotlin 编码规范
- 使用空安全
- 为公共方法添加 KDoc 注释
- 适当处理异常

### Swift 代码（iOS）

- 遵循 Swift 编码规范
- 使用可选类型处理空值
- 为公共方法添加文档注释
- 适当处理错误

## 测试

### 运行所有测试

```bash
# 使用 melos 运行所有包的测试
melos run test

# 或者单独运行某个包的测试
cd packages/core/core_network
flutter test
```

### 测试覆盖率

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### 编写测试

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:core_network/core_network.dart';

void main() {
  group('ApiClient Tests', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = ApiClient(
        config: NetworkConfig(baseUrl: 'https://api.example.com'),
      );
    });

    test('should make GET request successfully', () async {
      final response = await apiClient.get('/test');
      expect(response.isSuccess, true);
    });
  });
}
```

## Pull Request 流程

1. Fork 仓库
2. 创建功能分支：`git checkout -b feature/new-feature`
3. 进行修改
4. 为新功能添加测试
5. 确保所有测试通过：`melos run test`
6. 确保代码分析通过：`melos run analyze`
7. 格式化代码：`melos run format`
8. 提交并附上描述性消息：`git commit -m "feat(core): 添加新功能"`
9. 推送到您的 fork：`git push origin feature/new-feature`
10. 创建 Pull Request

### 提交消息格式

遵循 [Conventional Commits](https://www.conventionalcommits.org/)：

```text
<类型>(<范围>): <主题>

<正文>

<页脚>
```

类型：
- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档变更
- `style`: 代码格式变更
- `refactor`: 代码重构
- `test`: 添加或更新测试
- `chore`: 维护任务
- `perf`: 性能优化

范围：
- `core`: Core 层包
- `features`: Features 层包
- `shared`: Shared 层包
- `toolkit`: Toolkit 包相关
- `docs`: 文档相关

示例：

```text
feat(core): 实现 core_auth 认证层包

- 实现 AuthService 认证服务
- 实现 TokenManager Token 管理
- 实现登录/登出逻辑
- 添加单元测试
```

## 报告问题

在提交 issue 时，请包含：

- 问题的清晰描述
- 复现步骤
- 预期行为和实际行为
- Flutter 版本和平台信息
- 相关的错误日志或截图

## 功能请求

欢迎提出新功能建议！请在 issue 中说明：

- 功能的用途和场景
- 预期的 API 设计
- 是否愿意实现该功能

## Melos 命令

```bash
# 安装所有包的依赖
melos bootstrap

# 运行所有测试
melos run test

# 运行代码分析
melos run analyze

# 格式化代码
melos run format

# 清理所有包
melos clean

# 查看包依赖关系
melos list
```

## 获取帮助

- 查看 [文档](docs/)
- 查看现有 [issues](https://github.com/your-org/sdu-sna/issues)
- 阅读 [开发路线图](docs/DEVELOPMENT_ROADMAP.md)
- 阅读 [架构文档](docs/architecture.md)

## 行为准则

- 尊重和包容所有贡献者
- 提供建设性的反馈
- 关注对社区最有利的事情
- 对其他社区成员表现出同理心
- 避免使用冒犯性语言

## 许可证

通过贡献，您同意您的贡献将在 MIT 许可证下授权。

## 致谢

贡献者将在以下位置获得认可：

- `AUTHORS` 文件
- 发布说明
- 项目 README

感谢您为 SDU-SNA 做出贡献！🎉
