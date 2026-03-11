# feature_auth

认证功能模块，提供用户登录、注册、密码管理等功能。

## 功能特性

- ✅ 用户登录（学号/工号 + 密码）
- ✅ 记住密码
- ✅ 忘记密码提示
- 🚧 统一身份认证登录（开发中）
- 🚧 用户注册（开发中）
- 🚧 密码修改（开发中）
- 🚧 自动登录（开发中）

## 架构设计

采用 Clean Architecture 分层架构：

```
feature_auth/
├── lib/
│   ├── src/
│   │   ├── data/              # 数据层
│   │   │   ├── datasources/   # 数据源（API）
│   │   │   ├── models/        # 数据模型
│   │   │   └── repositories/  # Repository 实现
│   │   ├── domain/            # 领域层
│   │   │   ├── entities/      # 实体
│   │   │   └── usecases/      # 用例
│   │   └── presentation/      # 表现层
│   │       ├── pages/         # 页面
│   │       ├── widgets/       # 组件
│   │       └── providers/     # 状态管理
│   └── feature_auth.dart      # 主导出文件
└── test/                      # 测试
```

## 使用方法

### 1. 添加依赖

```yaml
dependencies:
  feature_auth:
    path: packages/features/feature_auth
```

### 2. 导入包

```dart
import 'package:feature_auth/feature_auth.dart';
```

### 3. 使用登录页面

```dart
// 在路由中配置
GoRoute(
  path: '/login',
  builder: (context, state) => const LoginPage(),
),

// 或直接导航
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const LoginPage()),
);
```

## 组件说明

### LoginPage

登录页面，包含完整的登录界面和交互逻辑。

**特性**:
- 学号/工号输入
- 密码输入（支持显示/隐藏）
- 记住密码选项
- 忘记密码功能
- 统一身份认证入口
- 注册入口
- 加载状态显示
- 错误提示

**使用示例**:
```dart
const LoginPage()
```

### LoginForm

登录表单组件，可复用的表单部分。

**参数**:
- `onLogin`: 登录回调
- `onForgotPassword`: 忘记密码回调
- `isLoading`: 加载状态

**使用示例**:
```dart
LoginForm(
  isLoading: false,
  onLogin: () {
    // 处理登录
  },
  onForgotPassword: () {
    // 处理忘记密码
  },
)
```

## 开发计划

### Phase 1: 基础登录功能 ✅
- [x] 登录页面 UI
- [x] 登录表单组件
- [x] 表单验证
- [x] 加载状态
- [x] 错误提示

### Phase 2: 完整认证流程 🚧
- [ ] 集成 core_auth
- [ ] 实现登录 UseCase
- [ ] 实现 Repository
- [ ] 状态管理（Riverpod）
- [ ] 自动登录
- [ ] Token 管理

### Phase 3: 扩展功能 📋
- [ ] 统一身份认证
- [ ] 用户注册
- [ ] 密码修改
- [ ] 密码重置
- [ ] 生物识别登录

## 依赖

- `core_network` - 网络请求
- `core_storage` - 本地存储
- `core_auth` - 认证服务
- `core_ui` - UI 组件
- `core_router` - 路由管理
- `core_utils` - 工具类
- `flutter_riverpod` - 状态管理

## 测试

```bash
cd packages/features/feature_auth
flutter test
```

## 许可证

本包是 SDU-SNA 项目的一部分。
