import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 应用文字样式
class AppTextStyles {
  AppTextStyles._();

  // ==================== 标题样式 ====================

  /// 超大标题 (32px)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  /// 大标题 (28px)
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  /// 中标题 (24px)
  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // ==================== 标题样式 ====================

  /// H1 标题 (22px)
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  /// H2 标题 (20px)
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  /// H3 标题 (18px)
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ==================== 正文样式 ====================

  /// 大正文 (16px)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  /// 中正文 (14px)
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  /// 小正文 (12px)
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  // ==================== 标签样式 ====================

  /// 大标签 (14px)
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// 中标签 (12px)
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// 小标签 (10px)
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // ==================== 按钮样式 ====================

  /// 按钮文字
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// 大按钮文字
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// 小按钮文字
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // ==================== 特殊样式 ====================

  /// 链接文字
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  /// 提示文字
  static const TextStyle hint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textHint,
  );

  /// 错误文字
  static const TextStyle error = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.error,
  );

  /// 成功文字
  static const TextStyle success = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.success,
  );

  /// 警告文字
  static const TextStyle warning = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.warning,
  );

  // ==================== 深色模式样式 ====================

  /// 深色模式标题
  static TextStyle get displayLargeDark => displayLarge.copyWith(
        color: AppColors.textPrimaryDark,
      );

  static TextStyle get headlineLargeDark => headlineLarge.copyWith(
        color: AppColors.textPrimaryDark,
      );

  static TextStyle get bodyLargeDark => bodyLarge.copyWith(
        color: AppColors.textPrimaryDark,
      );

  static TextStyle get bodyMediumDark => bodyMedium.copyWith(
        color: AppColors.textPrimaryDark,
      );

  static TextStyle get bodySmallDark => bodySmall.copyWith(
        color: AppColors.textSecondaryDark,
      );
}
