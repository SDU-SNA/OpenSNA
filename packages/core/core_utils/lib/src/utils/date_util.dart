import 'package:intl/intl.dart';

/// Date utility class providing common date operations
class DateUtil {
  DateUtil._();

  /// Format date to string with given pattern
  /// 
  /// Example:
  /// ```dart
  /// DateUtil.format(DateTime.now(), 'yyyy-MM-dd HH:mm:ss')
  /// ```
  static String format(DateTime date, String pattern) {
    return DateFormat(pattern).format(date);
  }

  /// Parse string to DateTime with given pattern
  /// 
  /// Example:
  /// ```dart
  /// DateUtil.parse('2024-03-11', 'yyyy-MM-dd')
  /// ```
  static DateTime? parse(String dateString, String pattern) {
    try {
      return DateFormat(pattern).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get formatted date string (yyyy-MM-dd)
  static String formatDate(DateTime date) {
    return format(date, 'yyyy-MM-dd');
  }

  /// Get formatted time string (HH:mm:ss)
  static String formatTime(DateTime date) {
    return format(date, 'HH:mm:ss');
  }

  /// Get formatted datetime string (yyyy-MM-dd HH:mm:ss)
  static String formatDateTime(DateTime date) {
    return format(date, 'yyyy-MM-dd HH:mm:ss');
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Get relative time string (e.g., "2 hours ago", "3 days ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}周前';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}个月前';
    } else {
      return '${(difference.inDays / 365).floor()}年前';
    }
  }

  /// Get start of day (00:00:00)
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day (23:59:59)
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
