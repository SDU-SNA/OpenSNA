import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// 空状态组件
class EmptyWidget extends StatelessWidget {
  /// 图标
  final IconData? icon;

  /// 标题
  final String title;

  /// 描述
  final String? description;

  /// 操作按钮文字
  final String? actionText;

  /// 操作按钮回调
  final VoidCallback? onAction;

  /// 图标大小
  final double iconSize;

  const EmptyWidget({
    super.key,
    this.icon,
    required this.title,
    this.description,
    this.actionText,
    this.onAction,
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
            if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: AppColors.textDisabled,
              ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 无数据
  factory EmptyWidget.noData({
    String? title,
    String? description,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyWidget(
      icon: Icons.inbox_outlined,
      title: title ?? '暂无数据',
      description: description,
      actionText: actionText,
      onAction: onAction,
    );
  }

  /// 无搜索结果
  factory EmptyWidget.noSearchResult({
    String? title,
    String? description,
  }) {
    return EmptyWidget(
      icon: Icons.search_off_outlined,
      title: title ?? '未找到相关内容',
      description: description ?? '请尝试其他关键词',
    );
  }

  /// 无网络
  factory EmptyWidget.noNetwork({
    String? title,
    String? description,
    VoidCallback? onRetry,
  }) {
    return EmptyWidget(
      icon: Icons.wifi_off_outlined,
      title: title ?? '网络连接失败',
      description: description ?? '请检查网络设置后重试',
      actionText: '重试',
      onAction: onRetry,
    );
  }
}
