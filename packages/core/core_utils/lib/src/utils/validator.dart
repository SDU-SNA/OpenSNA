/// Validator class providing common validation methods
class Validator {
  Validator._();

  /// Validate email format
  static bool isEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Validate phone number (Chinese mobile phone)
  static bool isPhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    return RegExp(r'^1[3-9]\d{9}$').hasMatch(phone);
  }

  /// Validate URL format
  static bool isUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    ).hasMatch(url);
  }

  /// Validate password strength
  /// 
  /// Requirements:
  /// - At least [minLength] characters (default: 8)
  /// - Contains at least one uppercase letter (if [requireUppercase] is true)
  /// - Contains at least one lowercase letter (if [requireLowercase] is true)
  /// - Contains at least one digit (if [requireDigit] is true)
  /// - Contains at least one special character (if [requireSpecial] is true)
  static bool isStrongPassword(
    String? password, {
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireDigit = true,
    bool requireSpecial = false,
  }) {
    if (password == null || password.length < minLength) return false;

    if (requireUppercase && !RegExp(r'[A-Z]').hasMatch(password)) {
      return false;
    }

    if (requireLowercase && !RegExp(r'[a-z]').hasMatch(password)) {
      return false;
    }

    if (requireDigit && !RegExp(r'\d').hasMatch(password)) {
      return false;
    }

    if (requireSpecial &&
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return false;
    }

    return true;
  }

  /// Validate Chinese ID card number (18 digits)
  static bool isIdCard(String? idCard) {
    if (idCard == null || idCard.length != 18) return false;

    // Check format
    if (!RegExp(r'^\d{17}[\dXx]$').hasMatch(idCard)) return false;

    // Validate checksum
    final weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
    final checksums = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'];

    var sum = 0;
    for (var i = 0; i < 17; i++) {
      sum += int.parse(idCard[i]) * weights[i];
    }

    final checksum = checksums[sum % 11];
    return idCard[17].toUpperCase() == checksum;
  }

  /// Validate student ID (8-12 digits)
  static bool isStudentId(String? studentId) {
    if (studentId == null || studentId.isEmpty) return false;
    return RegExp(r'^\d{8,12}$').hasMatch(studentId);
  }

  /// Validate IP address (IPv4)
  static bool isIpAddress(String? ip) {
    if (ip == null || ip.isEmpty) return false;
    return RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    ).hasMatch(ip);
  }

  /// Validate MAC address
  static bool isMacAddress(String? mac) {
    if (mac == null || mac.isEmpty) return false;
    return RegExp(
      r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$',
    ).hasMatch(mac);
  }

  /// Validate number range
  static bool isInRange(num? value, num min, num max) {
    if (value == null) return false;
    return value >= min && value <= max;
  }

  /// Validate string length range
  static bool isLengthInRange(String? str, int min, int max) {
    if (str == null) return false;
    return str.length >= min && str.length <= max;
  }

  /// Validate required field (not null and not empty)
  static bool isRequired(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Validate username format
  /// - 4-20 characters
  /// - Only letters, digits, and underscores
  /// - Must start with a letter
  static bool isUsername(String? username) {
    if (username == null || username.isEmpty) return false;
    return RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{3,19}$').hasMatch(username);
  }
}
