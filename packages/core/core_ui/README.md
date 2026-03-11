# core_ui

UI层核心包，提供统一的主题、样式和通用组件。

## 功能特性

- ✅ 统一的颜色系统
- ✅ 统一的文字样式
- ✅ 亮色/深色主题
- ✅ Material 3 设计
- ✅ 通用 UI 组件
- ✅ 响应式设计支持

## 安装

```yaml
dependencies:
  core_ui:
    path: ../core/core_ui
```

## 使用示例

### 1. 应用主题

```dart
import 'package:core_ui/core_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SDU-SNA',
      // 亮色主题
      theme: AppTheme.lightTheme,
      // 深色主题
      darkTheme: AppTheme.darkTheme,
      // 主题模式
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}
```

### 2. 使用颜色

```dart
import 'package:core_ui/core_ui.dart';

// 主色调
Container(
  color: AppColors.primary,
  child: Text('Primary Color'),
)

// 功能色
Container(
  color: AppColors.success,
  child: Text('Success'),
)

Container(
  color: AppColors.error,
  child: Text('Error'),
)

// 颜色工具方法
final lightColor = AppColors.lighten(AppColors.primary, 0.2);
final darkColor = AppColors.darken(AppColors.primary, 0.2);
final transparentColor = AppColors.withOpacity(AppColors.primary, 0.5);
```

### 3. 使用文字样式

```dart
import 'package:core_ui/core_ui.dart';

// 标题
Text(
  '大标题',
  style: AppTextStyles.displayLarge,
)

Text(
  'H1 标题',
  style: AppTextStyles.headlineLarge,
)

// 正文
Text(
  '正文内容',
  style: AppTextStyles.bodyLarge,
)

Text(
  '小字内容',
  style: AppTextStyles.bodySmall,
)

// 按钮文字
Text(
  '按钮',
  style: AppTextStyles.button,
)

// 特殊样式
Text(
  '链接',
  style: AppTextStyles.link,
)

Text(
  '错误提示',
  style: AppTextStyles.error,
)
```

### 4. 加载组件

```dart
import 'package:core_ui/core_ui.dart';

// 基础加载
LoadingWidget(
  message: '加载中...',
)

// 全屏加载
LoadingWidget.fullScreen(
  message: '正在加载数据',
)

// 加载对话框
LoadingWidget.show(
  context,
  message: '请稍候...',
)

// 隐藏加载对话框
LoadingWidget.hide(context);

// 自定义大小和颜色
LoadingWidget(
  message: '加载中',
  size: 60,
  color: AppColors.secondary,
)
```

### 5. 空状态组件

```dart
import 'package:core_ui/core_ui.dart';

// 基础空状态
EmptyWidget(
  icon: Icons.inbox_outlined,
  title: '暂无数据',
  description: '当前没有任何内容',
)

// 带操作按钮
EmptyWidget(
  icon: Icons.inbox_outlined,
  title: '暂无数据',
  description: '点击按钮添加内容',
  actionText: '添加',
  onAction: () {
    // 处理添加操作
  },
)

// 预设样式 - 无数据
EmptyWidget.noData()

EmptyWidget.noData(
  title: '暂无订单',
  description: '您还没有任何订单',
  actionText: '去购物',
  onAction: () {
    // 跳转到购物页面
  },
)

// 预设样式 - 无搜索结果
EmptyWidget.noSearchResult()

EmptyWidget.noSearchResult(
  title: '未找到 "关键词"',
  description: '请尝试其他搜索词',
)

// 预设样式 - 无网络
EmptyWidget.noNetwork(
  onRetry: () {
    // 重试加载
  },
)
```

### 6. 错误组件

```dart
import 'package:core_ui/core_ui.dart';

// 基础错误
AppErrorWidget(
  message: '加载失败',
  details: '请检查网络连接后重试',
  onRetry: () {
    // 重试操作
  },
)

// 预设样式 - 网络错误
AppErrorWidget.network(
  onRetry: () {
    // 重试
  },
)

// 预设样式 - 服务器错误
AppErrorWidget.server(
  message: '服务器繁忙',
  onRetry: () {
    // 重试
  },
)

// 预设样式 - 未授权
AppErrorWidget.unauthorized(
  onLogin: () {
    // 跳转到登录页
  },
)

// 预设样式 - 加载失败
AppErrorWidget.loadFailed(
  message: '数据加载失败',
  onRetry: () {
    // 重试
  },
)

// 自定义图标
AppErrorWidget(
  icon: Icons.warning_amber_outlined,
  message: '自定义错误',
  details: '错误详情',
  iconSize: 100,
  onRetry: () {},
)
```

### 7. 完整示例

```dart
import 'package:core_ui/core_ui.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool _isLoading = true;
  bool _hasError = false;
  List<String> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // 模拟加载数据
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _data = ['Item 1', 'Item 2', 'Item 3'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('示例页面'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return LoadingWidget(
        message: '加载中...',
      );
    }

    if (_hasError) {
      return AppErrorWidget.network(
        onRetry: _loadData,
      );
    }

    if (_data.isEmpty) {
      return EmptyWidget.noData(
        title: '暂无数据',
        actionText: '刷新',
        onAction: _loadData,
      );
    }

    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(
              _data[index],
              style: AppTextStyles.bodyLarge,
            ),
          ),
        );
      },
    );
  }
}
```

## 颜色系统

### 主色调
- `AppColors.primary` - 主色（品牌色）
- `AppColors.primaryLight` - 主色（浅色）
- `AppColors.primaryDark` - 主色（深色）
- `AppColors.secondary` - 次要色
- `AppColors.secondaryLight` - 次要色（浅色）
- `AppColors.secondaryDark` - 次要色（深色）

### 功能色
- `AppColors.success` - 成功色
- `AppColors.warning` - 警告色
- `AppColors.error` - 错误色
- `AppColors.info` - 信息色

### 中性色
- `AppColors.background` - 背景色
- `AppColors.surface` - 表面色
- `AppColors.textPrimary` - 主要文字色
- `AppColors.textSecondary` - 次要文字色
- `AppColors.divider` - 分割线颜色
- `AppColors.border` - 边框颜色

## 文字样式

### 标题样式
- `AppTextStyles.displayLarge` - 超大标题 (32px)
- `AppTextStyles.displayMedium` - 大标题 (28px)
- `AppTextStyles.displaySmall` - 中标题 (24px)
- `AppTextStyles.headlineLarge` - H1 标题 (22px)
- `AppTextStyles.headlineMedium` - H2 标题 (20px)
- `AppTextStyles.headlineSmall` - H3 标题 (18px)

### 正文样式
- `AppTextStyles.bodyLarge` - 大正文 (16px)
- `AppTextStyles.bodyMedium` - 中正文 (14px)
- `AppTextStyles.bodySmall` - 小正文 (12px)

### 标签样式
- `AppTextStyles.labelLarge` - 大标签 (14px)
- `AppTextStyles.labelMedium` - 中标签 (12px)
- `AppTextStyles.labelSmall` - 小标签 (10px)

### 按钮样式
- `AppTextStyles.button` - 按钮文字 (14px)
- `AppTextStyles.buttonLarge` - 大按钮文字 (16px)
- `AppTextStyles.buttonSmall` - 小按钮文字 (12px)

### 特殊样式
- `AppTextStyles.link` - 链接文字
- `AppTextStyles.hint` - 提示文字
- `AppTextStyles.error` - 错误文字
- `AppTextStyles.success` - 成功文字
- `AppTextStyles.warning` - 警告文字

## 组件列表

### LoadingWidget
加载指示器组件，支持自定义消息、大小和颜色。

### EmptyWidget
空状态组件，用于显示无数据、无搜索结果等场景。

### AppErrorWidget
错误提示组件，用于显示各种错误状态。

## 主题定制

如果需要自定义主题，可以修改 `AppColors` 和 `AppTextStyles` 中的值，或者扩展 `AppTheme` 类。

```dart
// 自定义主题
class MyAppTheme {
  static ThemeData get customTheme {
    final baseTheme = AppTheme.lightTheme;
    return baseTheme.copyWith(
      primaryColor: Colors.purple,
      // 其他自定义...
    );
  }
}
```

## 注意事项

1. **Material 3**: 本包使用 Material 3 设计规范
2. **响应式**: 所有组件都支持响应式布局
3. **深色模式**: 完整支持深色模式
4. **可访问性**: 遵循 WCAG 可访问性指南

## 依赖

无外部依赖，仅依赖 Flutter SDK。

## 许可证

MIT
