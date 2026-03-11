/// String utility class providing common string operations
class StringUtil {
  StringUtil._();

  /// Check if string is null or empty
  static bool isEmpty(String? str) {
    return str == null || str.isEmpty;
  }

  /// Check if string is not null and not empty
  static bool isNotEmpty(String? str) {
    return !isEmpty(str);
  }

  /// Check if string is null, empty or contains only whitespace
  static bool isBlank(String? str) {
    return str == null || str.trim().isEmpty;
  }

  /// Check if string is not blank
  static bool isNotBlank(String? str) {
    return !isBlank(str);
  }

  /// Capitalize first letter of string
  /// 
  /// Example:
  /// ```dart
  /// StringUtil.capitalize('hello') // 'Hello'
  /// ```
  static String capitalize(String str) {
    if (isEmpty(str)) return str;
    return str[0].toUpperCase() + str.substring(1);
  }

  /// Convert string to camelCase
  /// 
  /// Example:
  /// ```dart
  /// StringUtil.toCamelCase('hello_world') // 'helloWorld'
  /// ```
  static String toCamelCase(String str) {
    if (isEmpty(str)) return str;
    final words = str.split(RegExp(r'[_\s-]+'));
    if (words.isEmpty) return str;
    
    return words.first.toLowerCase() +
        words.skip(1).map((word) => capitalize(word.toLowerCase())).join();
  }

  /// Convert string to snake_case
  /// 
  /// Example:
  /// ```dart
  /// StringUtil.toSnakeCase('helloWorld') // 'hello_world'
  /// ```
  static String toSnakeCase(String str) {
    if (isEmpty(str)) return str;
    return str
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => '_${match.group(0)!.toLowerCase()}',
        )
        .replaceAll(RegExp(r'^_'), '');
  }

  /// Truncate string to specified length with ellipsis
  /// 
  /// Example:
  /// ```dart
  /// StringUtil.truncate('Hello World', 5) // 'Hello...'
  /// ```
  static String truncate(String str, int maxLength, {String ellipsis = '...'}) {
    if (str.length <= maxLength) return str;
    return str.substring(0, maxLength) + ellipsis;
  }

  /// Mask string (e.g., for phone numbers, emails)
  /// 
  /// Example:
  /// ```dart
  /// StringUtil.mask('13812345678', start: 3, end: 7) // '138****5678'
  /// ```
  static String mask(
    String str, {
    required int start,
    required int end,
    String maskChar = '*',
  }) {
    if (isEmpty(str) || start >= end || end > str.length) return str;
    
    final prefix = str.substring(0, start);
    final suffix = str.substring(end);
    final masked = maskChar * (end - start);
    
    return prefix + masked + suffix;
  }

  /// Mask phone number (e.g., 138****5678)
  static String maskPhone(String phone) {
    if (phone.length != 11) return phone;
    return mask(phone, start: 3, end: 7);
  }

  /// Mask email (e.g., abc***@example.com)
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 3) return email;
    
    final maskedUsername = username.substring(0, 3) + '***';
    return '$maskedUsername@$domain';
  }

  /// Remove all whitespace from string
  static String removeWhitespace(String str) {
    return str.replaceAll(RegExp(r'\s+'), '');
  }

  /// Check if string contains only digits
  static bool isNumeric(String str) {
    if (isEmpty(str)) return false;
    return RegExp(r'^\d+$').hasMatch(str);
  }

  /// Check if string contains only letters
  static bool isAlpha(String str) {
    if (isEmpty(str)) return false;
    return RegExp(r'^[a-zA-Z]+$').hasMatch(str);
  }

  /// Check if string contains only letters and digits
  static bool isAlphanumeric(String str) {
    if (isEmpty(str)) return false;
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(str);
  }
}
