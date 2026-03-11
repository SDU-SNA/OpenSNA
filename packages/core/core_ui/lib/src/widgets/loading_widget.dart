import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// 加载组件
class LoadingWidget extends StatelessWidget {
  /// 加载文字
  final String? message;

  /// 是否显示文字
  final bool showMessage;

  /// 指示器大小
  final double size;

  /// 指示器颜色
  final Color? color;

  const LoadingWidget({
    super.key,
    this.message,
    this.showMessage = true,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primary,
              ),
            ),
          ),
          if (showMessage && message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// 全屏加载
  static Widget fullScreen({
    String? message,
    Color? backgroundColor,
  }) {
    return Container(
      color: backgroundColor ?? AppColors.overlay,
      child: LoadingWidget(
        message: message,
      ),
    );
  }

  /// 对话框加载
  static Future<void> show(
    BuildContext context, {
    String? message,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => WillPopScope(
        onWillPop: () async => barrierDismissible,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: LoadingWidget(
              message: message,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }

  /// 隐藏加载对话框
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
