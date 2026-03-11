import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// 错误组件
class AppErrorWidget extends StatelessWidget {
  /// 错误消息
  final String message;

  /// 错误详情
  final String? details;

  /// 重试按钮文字
  final String? retryText;

  /// 重试回调
  final VoidCallback? onRetry;

  /// 图标
  final IconData icon;

  /// 图标大小
  final double iconSize;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.details,
    this.retryText,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.iconSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: AppColors.error,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            if (details != null) ...[
              const SizedBox(height: 8),
              Text(
                details!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText ?? '重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 网络错误
  factory AppErrorWidget.network({
    String? message,
    VoidCallback? onRetry,
  }) {
    return AppErrorWidget(
      icon: Icons.wifi_off_outlined,
      message: message ?? '网络连接失败',
      details: '请检查网络设置后重试',
      onRetry: onRetry,
    );
  }

  /// 服务器错误
  factory AppErrorWidget.server({
    String? message,
    VoidCallback? onRetry,
  }) {
    return AppErrorWidget(
      icon: Icons.cloud_off_outlined,
      message: message ?? '服务器错误',
      details: '服务暂时不可用，请稍后重试',
      onRetry: onRetry,
    );
  }

  /// 未授权
  factory AppErrorWidget.unauthorized({
    String? message,
    VoidCallback? onLogin,
  }) {
    return AppErrorWidget(
      icon: Icons.lock_outline,
      message: message ?? '未授权',
      details: '请先登录后再试',
      retryText: '去登录',
      onRetry: onLogin,
    );
  }

  /// 加载失败
  factory AppErrorWidget.loadFailed({
    String? message,
    VoidCallback? onRetry,
  }) {
    return AppErrorWidget(
      message: message ?? '加载失败',
      details: '数据加载失败，请重试',
      onRetry: onRetry,
    );
  }
}
