import 'package:intl/intl.dart';

/// DateTime extension methods
extension DateTimeExtensions on DateTime {
  /// Format to string with pattern
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }

  /// Format to date string (yyyy-MM-dd)
  String get toDateString => format('yyyy-MM-dd');

  /// Format to time string (HH:mm:ss)
  String get toTimeString => format('HH:mm:ss');

  /// Format to datetime string (yyyy-MM-dd HH:mm:ss)
  String get toDateTimeString => format('yyyy-MM-dd HH:mm:ss');

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Get relative time string
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

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
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day (23:59:59)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Check if same day as another date
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Add days
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract days
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Add hours
  DateTime addHours(int hours) => add(Duration(hours: hours));

  /// Subtract hours
  DateTime subtractHours(int hours) => subtract(Duration(hours: hours));

  /// Add minutes
  DateTime addMinutes(int minutes) => add(Duration(minutes: minutes));

  /// Subtract minutes
  DateTime subtractMinutes(int minutes) => subtract(Duration(minutes: minutes));
}
