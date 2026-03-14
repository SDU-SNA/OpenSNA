/// String extension methods
extension StringExtensions on String {
  /// Check if string is empty
  bool get isEmpty => this == '';

  /// Check if string is not empty
  bool get isNotEmpty => !isEmpty;

  /// Check if string is blank (empty or only whitespace)
  bool get isBlank => trim().isEmpty;

  /// Check if string is not blank
  bool get isNotBlank => !isBlank;

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Convert to camelCase
  String get toCamelCase {
    if (isEmpty) return this;
    final words = split(RegExp(r'[_\s-]+'));
    if (words.isEmpty) return this;

    return words.first.toLowerCase() +
        words.skip(1).map((word) => word.capitalize).join();
  }

  /// Convert to snake_case
  String get toSnakeCase {
    if (isEmpty) return this;
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceAll(RegExp(r'^_'), '');
  }

  /// Truncate string to specified length
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return substring(0, maxLength) + ellipsis;
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Check if string is numeric
  bool get isNumeric => RegExp(r'^\d+$').hasMatch(this);

  /// Check if string is alpha
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Check if string is alphanumeric
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Check if string is email
  bool get isEmail => RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(this);

  /// Check if string is phone number
  bool get isPhone => RegExp(r'^1[3-9]\d{9}$').hasMatch(this);

  /// Check if string is URL
  bool get isUrl => RegExp(
        r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
      ).hasMatch(this);

  /// Parse to int (returns null if parsing fails)
  int? toIntOrNull() => int.tryParse(this);

  /// Parse to double (returns null if parsing fails)
  double? toDoubleOrNull() => double.tryParse(this);

  /// Parse to DateTime (returns null if parsing fails)
  DateTime? toDateTimeOrNull() => DateTime.tryParse(this);
}
