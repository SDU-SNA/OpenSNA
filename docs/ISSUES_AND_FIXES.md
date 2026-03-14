# 当前问题诊断与修复方案

> 生成时间：2026-03-14  
> 基于 `flutter analyze` 实际输出

---

## 问题分类总览

| 类别 | 数量 | 严重程度 | 是否阻止启动 |
|------|------|----------|------------|
| A. barrel export 路径错误 | 4个包 | 🔴 致命 | 是 |
| B. 页面内相对导入失效 | 3个包 | 🔴 致命 | 是 |
| C. feature_network_service 缺少 speed_test_page.dart | 1处 | 🔴 致命 | 是 |
| D. feature_auth 的 .g.dart 未生成 + API不匹配 | 多处 | 🔴 致命 | 是 |
| E. dashboard_page.dart 中 User 类未定义 | 1处 | 🔴 致命 | 是 |
| F. DanXi-main/ 目录大量错误 | 数百个 | 🟡 噪音 | 否（不影响我们的app） |

---

## A. Barrel Export 路径错误（4个包）

**根本原因**：barrel 文件（`lib/feature_xxx.dart`）里用的是 `src/...` 相对路径，但 Dart analyzer 在包根目录下解析时找不到这些文件。

### feature_academic/lib/feature_academic.dart
```
error - Target of URI doesn't exist: 'src/presentation/pages/timetable_page.dart'
error - Target of URI doesn't exist: 'src/presentation/pages/grades_page.dart'
error - Target of URI doesn't exist: 'src/presentation/pages/exams_page.dart'
```
**实际文件存在**：`lib/src/presentation/pages/timetable_page.dart` ✅  
**修复**：路径改为 `src/presentation/pages/timetable_page.dart` → 已经是这个，但文件名是 `timetable_page.dart`，实际文件名需确认（见B节）

### feature_campus_info/lib/feature_campus_info.dart
```
error - Target of URI doesn't exist: 'src/presentation/pages/campus_info_page.dart'
error - Target of URI doesn't exist: 'src/presentation/pages/announcement_detail_page.dart'
error - Target of URI doesn't exist: 'src/presentation/pages/search_page.dart'
```

### feature_convenience/lib/feature_convenience.dart
```
error - Target of URI doesn't exist: 'src/presentation/pages/classroom_page.dart'
error - Target of URI doesn't exist: 'src/presentation/pages/library_page.dart'
error - Target of URI doesn't exist: 'src/presentation/pages/bus_page.dart'
```

### feature_network_service/lib/feature_network_service.dart
```
error - Target of URI doesn't exist: 'src/presentation/pages/network_account_page.dart'
error - Target of URI doesn't exist: 'src/presentation/pages/device_manage_page.dart'
error - Target of URI doesn't exist: 'src/presentation/pages/repair_page.dart'
error - Target of URI doesn't exist: 'src/presentation/pages/speed_test_history_page.dart'
```
**注意**：barrel 里写的是 `speed_test_history_page.dart`，但实际文件是 `speed_test_page.dart`（history page 是另一个文件）

**修复方案**：这些路径本身是正确的（相对于 `lib/` 目录），问题是 **analyzer 在 Windows 上对 monorepo 子包的路径解析有 bug**。  
解决方法：在各包目录下单独运行 `flutter pub get`，或者将 export 路径改为绝对包路径。

---

## B. 页面内相对导入失效（3个包）

**根本原因**：同一目录下的相对导入（如 `import 'timetable_page.dart'`）在 analyzer 报告找不到，但文件确实存在。这是 Windows 路径 + monorepo 的已知问题。

### academic_page.dart
```dart
import 'timetable_page.dart';  // ❌ analyzer 找不到
import 'grades_page.dart';     // ❌
import 'exams_page.dart';      // ❌
```
**修复**：改为包路径导入：
```dart
import 'package:feature_academic/src/presentation/pages/timetable_page.dart';
import 'package:feature_academic/src/presentation/pages/grades_page.dart';
import 'package:feature_academic/src/presentation/pages/exams_page.dart';
```

### convenience_page.dart
```dart
import 'classroom_page.dart';  // ❌
import 'library_page.dart';    // ❌
import 'bus_page.dart';        // ❌
```
**修复**：改为包路径导入。

### favorites_page.dart (feature_campus_info)
```dart
import 'announcement_detail_page.dart';  // ❌
```
**修复**：改为包路径导入。

### network_service_page.dart (feature_network_service)
```dart
import 'network_account_page.dart';  // ❌
import 'device_manage_page.dart';    // ❌
import 'repair_page.dart';           // ❌
```
**修复**：改为包路径导入。

---

## C. feature_network_service 缺少 speed_test_page.dart

**问题**：barrel 文件 export 了 `speed_test_page.dart`，但 `pages/` 目录下只有：
- `device_manage_page.dart`
- `network_account_page.dart`
- `network_service_page.dart`
- `repair_page.dart`
- `speed_test_history_page.dart`  ← 有这个

**没有** `speed_test_page.dart`！但 `network_service_page.dart` 里引用了它，`dashboard_page.dart` 也用了 `SpeedTestPage()`。

**修复**：需要创建 `speed_test_page.dart`，或者把 `speed_test_history_page.dart` 重命名/改造成 `SpeedTestPage`。

---

## D. feature_auth 问题（多处，需要 build_runner）

### D1. .g.dart 文件未生成
```
error - Target of URI hasn't been generated: 'login_request.g.dart'
error - Target of URI hasn't been generated: 'login_response.g.dart'
```
**修复**：在 `packages/features/feature_auth/` 目录下运行：
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### D2. AuthService API 不匹配
`auth_repository_impl.dart` 调用了 `authService.saveToken()`、`authService.saveUser()`、`authService.getUser()`，但 `core_auth` 的 `AuthService` 没有这些方法（它用的是 `TokenManager`）。

**修复**：`auth_repository_impl.dart` 需要直接用 `TokenManager` 或修改调用方式。

### D3. auth_provider.dart 中 AuthService() 缺少必填参数
```
error - The named parameter 'apiClient' is required, but there's no corresponding argument
```
`AuthService` 构造函数要求 `apiClient`，但 provider 里写的是 `AuthService()`。

**修复**：
```dart
final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient: apiClient);
});
```

### D4. ApiExceptionType 枚举值名称不匹配
`auth_repository_impl.dart` 用了 `unauthorized`、`forbidden`、`notFound`、`timeout`、`noInternet`、`serverError`，但 `core_network` 里实际的枚举值名称不同（需要对照 `api_exception.dart` 确认）。

### D5. login_page.dart 类型参数错误
```
error - The name '_LoginFormState' isn't a type, so it can't be used as a type argument
```
`StatefulWidget` 的泛型写法有误。

---

## E. dashboard_page.dart 中 User 类未定义

```
error - Undefined class 'User' - lib/features/dashboard/presentation/pages/dashboard_page.dart:53
```

`dashboard_page.dart` 引用了 `authState.user`，类型是 `User?`，但没有导入 `User` 类。

**修复**：添加导入：
```dart
import 'package:core_auth/core_auth.dart';  // 或 feature_auth
```
或者把 `_UserCard` 的参数类型改为 `dynamic`/`Object?`，只用 `.toString()` 显示。

同样问题在 `profile_page.dart:125`。

---

## F. DanXi-main/ 目录噪音

`DanXi-main/` 是参考项目，不是我们的代码，但 analyzer 会扫描它产生数百个错误。

**修复**：在 `analysis_options.yaml` 里排除它：
```yaml
analyzer:
  exclude:
    - DanXi-main/**
    - build/**
```

---

## 修复优先级和步骤

### Step 1：排除 DanXi-main（5分钟）
修改根目录 `analysis_options.yaml`，立刻消除数百个噪音错误。

### Step 2：修复相对导入 → 包路径导入（15分钟）
修改以下4个文件：
- `feature_academic/lib/src/presentation/pages/academic_page.dart`
- `feature_convenience/lib/src/presentation/pages/convenience_page.dart`
- `feature_campus_info/lib/src/presentation/pages/favorites_page.dart`
- `feature_network_service/lib/src/presentation/pages/network_service_page.dart`

### Step 3：创建缺失的 speed_test_page.dart（10分钟）
在 `feature_network_service/lib/src/presentation/pages/` 下创建 `SpeedTestPage`（可以是跳转到 history page 的简单包装）。

### Step 4：修复 feature_auth（30分钟）
- 运行 build_runner 生成 .g.dart
- 修复 AuthService 构造函数调用
- 修复 ApiExceptionType 枚举值
- 修复 login_page.dart 类型参数

### Step 5：修复 dashboard_page.dart 的 User 类（5分钟）
添加正确的 import。

### Step 6：各包运行 flutter pub get（5分钟）
确保 package_config.json 是最新的。

---

## 预期结果

完成以上步骤后，我们自己的代码（排除 DanXi-main）应该可以 0 error 通过 analyze，app 可以正常启动并显示 Mock 数据。
