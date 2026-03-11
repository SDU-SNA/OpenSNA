# core_utils

Core utilities package providing common utility classes and extension methods for the SDU-SNA application.

## Features

- **Date Utilities**: Date formatting, parsing, and manipulation
- **String Utilities**: String operations and transformations
- **Validators**: Common validation methods for email, phone, URL, etc.
- **Extension Methods**: Convenient extensions for String, DateTime, and Num types
- **Log Integration**: Re-exports log_kit for convenient logging

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  core_utils:
    path: ../core/core_utils
```

## Usage

### Date Utilities

```dart
import 'package:core_utils/core_utils.dart';

// Format date
final date = DateTime.now();
print(DateUtil.formatDate(date)); // 2024-03-11
print(DateUtil.formatTime(date)); // 15:30:45
print(DateUtil.formatDateTime(date)); // 2024-03-11 15:30:45

// Custom format
print(DateUtil.format(date, 'yyyy年MM月dd日')); // 2024年03月11日

// Check date
print(DateUtil.isToday(date)); // true
print(DateUtil.isYesterday(date)); // false

// Relative time
print(DateUtil.getRelativeTime(date)); // 刚刚 / 5分钟前 / 2小时前

// Start/End of day
final start = DateUtil.startOfDay(date); // 2024-03-11 00:00:00
final end = DateUtil.endOfDay(date); // 2024-03-11 23:59:59
```

### String Utilities

```dart
import 'package:core_utils/core_utils.dart';

// Check empty/blank
print(StringUtil.isEmpty('')); // true
print(StringUtil.isBlank('   ')); // true

// Case conversion
print(StringUtil.capitalize('hello')); // Hello
print(StringUtil.toCamelCase('hello_world')); // helloWorld
print(StringUtil.toSnakeCase('helloWorld')); // hello_world

// Truncate
print(StringUtil.truncate('Hello World', 5)); // Hello...

// Mask sensitive data
print(StringUtil.maskPhone('13812345678')); // 138****5678
print(StringUtil.maskEmail('test@example.com')); // tes***@example.com

// Type checking
print(StringUtil.isNumeric('123')); // true
print(StringUtil.isAlpha('abc')); // true
print(StringUtil.isAlphanumeric('abc123')); // true
```

### Validators

```dart
import 'package:core_utils/core_utils.dart';

// Email validation
print(Validator.isEmail('test@example.com')); // true

// Phone validation (Chinese mobile)
print(Validator.isPhone('13812345678')); // true

// URL validation
print(Validator.isUrl('https://example.com')); // true

// Password strength
print(Validator.isStrongPassword('Password123')); // true
print(Validator.isStrongPassword('weak')); // false

// Student ID
print(Validator.isStudentId('20240001')); // true

// IP address
print(Validator.isIpAddress('192.168.1.1')); // true

// MAC address
print(Validator.isMacAddress('00:1A:2B:3C:4D:5E')); // true

// Number range
print(Validator.isInRange(5, 1, 10)); // true

// Username (4-20 chars, starts with letter)
print(Validator.isUsername('user123')); // true
```

### String Extensions

```dart
import 'package:core_utils/core_utils.dart';

// Check empty/blank
print(''.isEmpty); // true
print('   '.isBlank); // true

// Case conversion
print('hello'.capitalize); // Hello
print('hello_world'.toCamelCase); // helloWorld
print('helloWorld'.toSnakeCase); // hello_world

// Truncate
print('Hello World'.truncate(5)); // Hello...

// Remove whitespace
print('hello world'.removeWhitespace); // helloworld

// Type checking
print('123'.isNumeric); // true
print('abc'.isAlpha); // true
print('abc123'.isAlphanumeric); // true
print('test@example.com'.isEmail); // true
print('13812345678'.isPhone); // true
print('https://example.com'.isUrl); // true

// Parse
print('123'.toIntOrNull()); // 123
print('3.14'.toDoubleOrNull()); // 3.14
print('2024-03-11'.toDateTimeOrNull()); // DateTime object
```

### DateTime Extensions

```dart
import 'package:core_utils/core_utils.dart';

final date = DateTime.now();

// Format
print(date.toDateString); // 2024-03-11
print(date.toTimeString); // 15:30:45
print(date.toDateTimeString); // 2024-03-11 15:30:45
print(date.format('yyyy年MM月dd日')); // 2024年03月11日

// Check
print(date.isToday); // true
print(date.isYesterday); // false
print(date.isTomorrow); // false

// Relative time
print(date.relativeTime); // 刚刚 / 5分钟前 / 2小时前

// Start/End of day
print(date.startOfDay); // 2024-03-11 00:00:00
print(date.endOfDay); // 2024-03-11 23:59:59

// Date arithmetic
print(date.addDays(5)); // 5 days later
print(date.subtractDays(3)); // 3 days ago
print(date.addHours(2)); // 2 hours later
print(date.addMinutes(30)); // 30 minutes later

// Compare
final other = DateTime(2024, 3, 11);
print(date.isSameDay(other)); // true
```

### Num Extensions

```dart
import 'package:core_utils/core_utils.dart';

// Range check
print(5.inRange(1, 10)); // true

// Percentage
print(0.5.toPercentage()); // 50%
print(0.755.toPercentage(decimals: 1)); // 75.5%

// Formatted string
print(1234567.toFormattedString()); // 1,234,567

// File size
print(1024.toFileSize()); // 1.00 KB
print(1048576.toFileSize()); // 1.00 MB

// Int extensions
print(4.isEven); // true
print(5.isOdd); // true
print(5.isPositive); // true
print(-5.isNegative); // true

// Duration shortcuts
print(5.days); // Duration(days: 5)
print(3.hours); // Duration(hours: 3)
print(30.minutes); // Duration(minutes: 30)
print(45.seconds); // Duration(seconds: 45)

// Double extensions
print(3.14159.roundToDecimal(2)); // 3.14
print(3.14.approximatelyEqual(3.14001)); // true
```

### Logging (via log_kit)

```dart
import 'package:core_utils/core_utils.dart';

// core_utils re-exports log_kit for convenience
// You can use log_kit directly without additional imports

// Initialize logger (usually in main.dart)
await LogKit.init(
  level: LogLevel.debug,
  enableFileLog: true,
);

// Use logger
LogKit.debug('Debug message');
LogKit.info('Info message');
LogKit.warning('Warning message');
LogKit.error('Error message');
```

## API Reference

### DateUtil

- `format(DateTime date, String pattern)` - Format date with custom pattern
- `parse(String dateString, String pattern)` - Parse string to DateTime
- `formatDate(DateTime date)` - Format as yyyy-MM-dd
- `formatTime(DateTime date)` - Format as HH:mm:ss
- `formatDateTime(DateTime date)` - Format as yyyy-MM-dd HH:mm:ss
- `isToday(DateTime date)` - Check if date is today
- `isYesterday(DateTime date)` - Check if date is yesterday
- `getRelativeTime(DateTime date)` - Get relative time string
- `startOfDay(DateTime date)` - Get start of day (00:00:00)
- `endOfDay(DateTime date)` - Get end of day (23:59:59)
- `isSameDay(DateTime date1, DateTime date2)` - Check if same day

### StringUtil

- `isEmpty(String? str)` - Check if null or empty
- `isNotEmpty(String? str)` - Check if not null and not empty
- `isBlank(String? str)` - Check if null, empty or whitespace
- `isNotBlank(String? str)` - Check if not blank
- `capitalize(String str)` - Capitalize first letter
- `toCamelCase(String str)` - Convert to camelCase
- `toSnakeCase(String str)` - Convert to snake_case
- `truncate(String str, int maxLength)` - Truncate with ellipsis
- `mask(String str, {int start, int end})` - Mask characters
- `maskPhone(String phone)` - Mask phone number
- `maskEmail(String email)` - Mask email address
- `removeWhitespace(String str)` - Remove all whitespace
- `isNumeric(String str)` - Check if only digits
- `isAlpha(String str)` - Check if only letters
- `isAlphanumeric(String str)` - Check if letters and digits

### Validator

- `isEmail(String? email)` - Validate email format
- `isPhone(String? phone)` - Validate Chinese mobile phone
- `isUrl(String? url)` - Validate URL format
- `isStrongPassword(String? password)` - Validate password strength
- `isIdCard(String? idCard)` - Validate Chinese ID card
- `isStudentId(String? studentId)` - Validate student ID
- `isIpAddress(String? ip)` - Validate IPv4 address
- `isMacAddress(String? mac)` - Validate MAC address
- `isInRange(num? value, num min, num max)` - Validate number range
- `isLengthInRange(String? str, int min, int max)` - Validate string length
- `isRequired(String? value)` - Validate required field
- `isUsername(String? username)` - Validate username format

## Testing

Run tests:

```bash
cd packages/core/core_utils
flutter test
```

## Dependencies

- `intl: ^0.20.2` - Internationalization and date formatting
- `log_kit` - Logging functionality (from GitHub)

## License

This package is part of the SDU-SNA project.
