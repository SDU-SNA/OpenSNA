/// Num extension methods
extension NumExtensions on num {
  /// Check if number is in range
  bool inRange(num min, num max) => this >= min && this <= max;

  /// Clamp number to range
  num clampToRange(num min, num max) => clamp(min, max);

  /// Convert to percentage string
  String toPercentage({int decimals = 0}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }

  /// Format with thousand separators
  String toFormattedString({int decimals = 0}) {
    final parts = toStringAsFixed(decimals).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
    return parts.length > 1 ? '$intPart.${parts[1]}' : intPart;
  }

  /// Convert bytes to human readable format
  String toFileSize() {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = toDouble();
    var unitIndex = 0;

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(2)} ${units[unitIndex]}';
  }
}

/// Int extension methods
extension IntExtensions on int {
  /// Check if number is even
  bool get isEven => this % 2 == 0;

  /// Check if number is odd
  bool get isOdd => this % 2 != 0;

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Convert to duration in days
  Duration get days => Duration(days: this);

  /// Convert to duration in hours
  Duration get hours => Duration(hours: this);

  /// Convert to duration in minutes
  Duration get minutes => Duration(minutes: this);

  /// Convert to duration in seconds
  Duration get seconds => Duration(seconds: this);

  /// Convert to duration in milliseconds
  Duration get milliseconds => Duration(milliseconds: this);
}

/// Double extension methods
extension DoubleExtensions on double {
  /// Round to specified decimal places
  double roundToDecimal(int places) {
    final mod = 10.0 * places;
    return (this * mod).round() / mod;
  }

  /// Check if approximately equal to another double
  bool approximatelyEqual(double other, {double epsilon = 0.0001}) {
    return (this - other).abs() < epsilon;
  }
}
