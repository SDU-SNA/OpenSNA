import 'dart:async';
import 'package:flutter/foundation.dart';
// import 'package:log_kit/log_kit.dart';
// import 'package:crash_reporter_kit/crash_reporter_kit.dart';

/// Toolkit包初始化服务
/// 
/// 负责初始化所有Toolkit包，包括：
/// - log_kit: 日志系统
/// - crash_reporter_kit: 崩溃收集
/// - permission_kit: 权限管理（按需使用）
class ToolkitInitializer {
  ToolkitInitializer._();

  static bool _initialized = false;

  /// 初始化所有Toolkit包
  static Future<void> initialize({
    bool enableFileLog = true,
    bool enableRemoteLog = false,
    String? remoteLogUrl,
    String? crashReportUrl,
    String? appVersion,
  }) async {
    if (_initialized) {
      debugPrint('Toolkit已经初始化，跳过重复初始化');
      return;
    }

    try {
      // 1. 初始化日志系统 (log_kit)
      await _initializeLogger(
        enableFileLog: enableFileLog,
        enableRemoteLog: enableRemoteLog,
        remoteUrl: remoteLogUrl,
      );

      // 2. 初始化崩溃收集 (crash_reporter_kit)
      await _initializeCrashReporter(
        apiUrl: crashReportUrl,
        appVersion: appVersion,
      );

      _initialized = true;
      debugPrint('✅ Toolkit包初始化完成');
    } catch (e, stackTrace) {
      debugPrint('❌ Toolkit包初始化失败: $e');
      debugPrint('StackTrace: $stackTrace');
      rethrow;
    }
  }

  /// 初始化日志系统
  static Future<void> _initializeLogger({
    required bool enableFileLog,
    required bool enableRemoteLog,
    String? remoteUrl,
  }) async {
    try {
      // TODO: 取消注释以启用log_kit
      // await LogKit.init(
      //   level: kDebugMode ? LogLevel.debug : LogLevel.info,
      //   enableFileLog: enableFileLog,
      //   enableRemoteLog: enableRemoteLog,
      //   remoteUrl: remoteUrl ?? 'https://log.sdu.edu.cn/api/logs',
      //   maxFileSize: 10 * 1024 * 1024, // 10MB
      //   maxFileCount: 5,
      // );
      
      debugPrint('✅ 日志系统初始化完成');
      debugPrint('  - 文件日志: ${enableFileLog ? "启用" : "禁用"}');
      debugPrint('  - 远程日志: ${enableRemoteLog ? "启用" : "禁用"}');
      
      // 记录初始化日志
      // LogKit.info('应用启动', tag: 'App');
    } catch (e) {
      debugPrint('❌ 日志系统初始化失败: $e');
      // 日志系统初始化失败不应该阻止应用启动
    }
  }

  /// 初始化崩溃收集
  static Future<void> _initializeCrashReporter({
    String? apiUrl,
    String? appVersion,
  }) async {
    try {
      // TODO: 取消注释以启用crash_reporter_kit
      // await CrashReporterKit.init(
      //   apiUrl: apiUrl ?? 'https://crash.sdu.edu.cn/api/report',
      //   appVersion: appVersion ?? '1.0.0',
      //   enableInDebugMode: kDebugMode,
      //   autoReport: true,
      // );
      
      debugPrint('✅ 崩溃收集初始化完成');
      debugPrint('  - API地址: ${apiUrl ?? "默认"}');
      debugPrint('  - 应用版本: ${appVersion ?? "1.0.0"}');
      
      // 记录初始化日志
      // LogKit.info('崩溃收集系统已启动', tag: 'CrashReporter');
    } catch (e) {
      debugPrint('❌ 崩溃收集初始化失败: $e');
      // 崩溃收集初始化失败不应该阻止应用启动
    }
  }

  /// 检查是否已初始化
  static bool get isInitialized => _initialized;

  /// 记录日志（便捷方法）
  static void log(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    // TODO: 取消注释以使用log_kit
    // if (_initialized) {
    //   LogKit.info(message, tag: tag, error: error, stackTrace: stackTrace);
    // } else {
    //   debugPrint('[$tag] $message');
    // }
    debugPrint('[$tag] $message');
  }

  /// 记录错误（便捷方法）
  static void logError(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    // TODO: 取消注释以使用log_kit
    // if (_initialized) {
    //   LogKit.error(message, tag: tag, error: error, stackTrace: stackTrace);
    // } else {
    //   debugPrint('❌ [$tag] $message');
    //   if (error != null) debugPrint('Error: $error');
    //   if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    // }
    debugPrint('❌ [$tag] $message');
    if (error != null) debugPrint('Error: $error');
    if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
  }

  /// 上报崩溃（便捷方法）
  static Future<void> reportCrash(
    dynamic error,
    StackTrace stackTrace, {
    Map<String, dynamic>? extras,
  }) async {
    // TODO: 取消注释以使用crash_reporter_kit
    // if (_initialized) {
    //   await CrashReporterKit.report(error, stackTrace, extras: extras);
    // } else {
    //   debugPrint('❌ 崩溃上报失败：Toolkit未初始化');
    //   debugPrint('Error: $error');
    //   debugPrint('StackTrace: $stackTrace');
    // }
    debugPrint('❌ 崩溃: $error');
    debugPrint('StackTrace: $stackTrace');
  }
}
