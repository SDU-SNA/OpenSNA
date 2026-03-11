import 'package:flutter_test/flutter_test.dart';
import 'package:core_utils/core_utils.dart';

void main() {
  group('DateUtil Tests', () {
    test('format date with pattern', () {
      final date = DateTime(2024, 3, 11, 15, 30, 45);
      expect(DateUtil.format(date, 'yyyy-MM-dd'), '2024-03-11');
      expect(DateUtil.format(date, 'HH:mm:ss'), '15:30:45');
    });

    test('formatDate returns yyyy-MM-dd', () {
      final date = DateTime(2024, 3, 11);
      expect(DateUtil.formatDate(date), '2024-03-11');
    });

    test('formatTime returns HH:mm:ss', () {
      final date = DateTime(2024, 3, 11, 15, 30, 45);
      expect(DateUtil.formatTime(date), '15:30:45');
    });

    test('formatDateTime returns yyyy-MM-dd HH:mm:ss', () {
      final date = DateTime(2024, 3, 11, 15, 30, 45);
      expect(DateUtil.formatDateTime(date), '2024-03-11 15:30:45');
    });

    test('isToday returns true for today', () {
      final today = DateTime.now();
      expect(DateUtil.isToday(today), true);
    });

    test('isYesterday returns true for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(DateUtil.isYesterday(yesterday), true);
    });

    test('getRelativeTime returns correct string', () {
      final now = DateTime.now();
      final fiveMinutesAgo = now.subtract(const Duration(minutes: 5));
      expect(DateUtil.getRelativeTime(fiveMinutesAgo), '5分钟前');
    });

    test('startOfDay returns 00:00:00', () {
      final date = DateTime(2024, 3, 11, 15, 30, 45);
      final start = DateUtil.startOfDay(date);
      expect(start.hour, 0);
      expect(start.minute, 0);
      expect(start.second, 0);
    });

    test('endOfDay returns 23:59:59', () {
      final date = DateTime(2024, 3, 11, 15, 30, 45);
      final end = DateUtil.endOfDay(date);
      expect(end.hour, 23);
      expect(end.minute, 59);
      expect(end.second, 59);
    });

    test('isSameDay returns true for same day', () {
      final date1 = DateTime(2024, 3, 11, 10, 0, 0);
      final date2 = DateTime(2024, 3, 11, 20, 0, 0);
      expect(DateUtil.isSameDay(date1, date2), true);
    });
  });

  group('StringUtil Tests', () {
    test('isEmpty returns true for null and empty string', () {
      expect(StringUtil.isEmpty(null), true);
      expect(StringUtil.isEmpty(''), true);
      expect(StringUtil.isEmpty('hello'), false);
    });

    test('isBlank returns true for whitespace', () {
      expect(StringUtil.isBlank('   '), true);
      expect(StringUtil.isBlank('hello'), false);
    });

    test('capitalize capitalizes first letter', () {
      expect(StringUtil.capitalize('hello'), 'Hello');
      expect(StringUtil.capitalize('HELLO'), 'HELLO');
    });

    test('toCamelCase converts to camelCase', () {
      expect(StringUtil.toCamelCase('hello_world'), 'helloWorld');
      expect(StringUtil.toCamelCase('hello-world'), 'helloWorld');
    });

    test('toSnakeCase converts to snake_case', () {
      expect(StringUtil.toSnakeCase('helloWorld'), 'hello_world');
      expect(StringUtil.toSnakeCase('HelloWorld'), 'hello_world');
    });

    test('truncate truncates string', () {
      expect(StringUtil.truncate('Hello World', 5), 'Hello...');
      expect(StringUtil.truncate('Hi', 5), 'Hi');
    });

    test('maskPhone masks phone number', () {
      expect(StringUtil.maskPhone('13812345678'), '138****5678');
    });

    test('maskEmail masks email', () {
      expect(StringUtil.maskEmail('test@example.com'), 'tes***@example.com');
    });

    test('isNumeric checks if string is numeric', () {
      expect(StringUtil.isNumeric('123'), true);
      expect(StringUtil.isNumeric('abc'), false);
    });

    test('isAlpha checks if string is alpha', () {
      expect(StringUtil.isAlpha('abc'), true);
      expect(StringUtil.isAlpha('abc123'), false);
    });

    test('isAlphanumeric checks if string is alphanumeric', () {
      expect(StringUtil.isAlphanumeric('abc123'), true);
      expect(StringUtil.isAlphanumeric('abc-123'), false);
    });
  });

  group('Validator Tests', () {
    test('isEmail validates email', () {
      expect(Validator.isEmail('test@example.com'), true);
      expect(Validator.isEmail('invalid-email'), false);
    });

    test('isPhone validates phone number', () {
      expect(Validator.isPhone('13812345678'), true);
      expect(Validator.isPhone('12345678901'), false);
    });

    test('isUrl validates URL', () {
      expect(Validator.isUrl('https://example.com'), true);
      expect(Validator.isUrl('not-a-url'), false);
    });

    test('isStrongPassword validates password', () {
      expect(Validator.isStrongPassword('Password123'), true);
      expect(Validator.isStrongPassword('weak'), false);
    });

    test('isStudentId validates student ID', () {
      expect(Validator.isStudentId('20240001'), true);
      expect(Validator.isStudentId('123'), false);
    });

    test('isIpAddress validates IP address', () {
      expect(Validator.isIpAddress('192.168.1.1'), true);
      expect(Validator.isIpAddress('999.999.999.999'), false);
    });

    test('isMacAddress validates MAC address', () {
      expect(Validator.isMacAddress('00:1A:2B:3C:4D:5E'), true);
      expect(Validator.isMacAddress('invalid-mac'), false);
    });

    test('isInRange validates number range', () {
      expect(Validator.isInRange(5, 1, 10), true);
      expect(Validator.isInRange(15, 1, 10), false);
    });

    test('isUsername validates username', () {
      expect(Validator.isUsername('user123'), true);
      expect(Validator.isUsername('123user'), false);
      expect(Validator.isUsername('ab'), false);
    });
  });

  group('String Extensions Tests', () {
    test('capitalize extension', () {
      expect('hello'.capitalize, 'Hello');
    });

    test('toCamelCase extension', () {
      expect('hello_world'.toCamelCase, 'helloWorld');
    });

    test('toSnakeCase extension', () {
      expect('helloWorld'.toSnakeCase, 'hello_world');
    });

    test('truncate extension', () {
      expect('Hello World'.truncate(5), 'Hello...');
    });

    test('isNumeric extension', () {
      expect('123'.isNumeric, true);
      expect('abc'.isNumeric, false);
    });

    test('isEmail extension', () {
      expect('test@example.com'.isEmail, true);
      expect('invalid'.isEmail, false);
    });

    test('toIntOrNull extension', () {
      expect('123'.toIntOrNull(), 123);
      expect('abc'.toIntOrNull(), null);
    });
  });

  group('DateTime Extensions Tests', () {
    test('toDateString extension', () {
      final date = DateTime(2024, 3, 11);
      expect(date.toDateString, '2024-03-11');
    });

    test('isToday extension', () {
      final today = DateTime.now();
      expect(today.isToday, true);
    });

    test('addDays extension', () {
      final date = DateTime(2024, 3, 11);
      final newDate = date.addDays(5);
      expect(newDate.day, 16);
    });

    test('startOfDay extension', () {
      final date = DateTime(2024, 3, 11, 15, 30, 45);
      final start = date.startOfDay;
      expect(start.hour, 0);
      expect(start.minute, 0);
    });
  });

  group('Num Extensions Tests', () {
    test('inRange extension', () {
      expect(5.inRange(1, 10), true);
      expect(15.inRange(1, 10), false);
    });

    test('toPercentage extension', () {
      expect(0.5.toPercentage(), '50%');
      expect(0.755.toPercentage(decimals: 1), '75.5%');
    });

    test('toFileSize extension', () {
      expect(1024.toFileSize(), '1.00 KB');
      expect(1048576.toFileSize(), '1.00 MB');
    });

    test('isEven extension', () {
      expect(4.isEven, true);
      expect(5.isEven, false);
    });

    test('isOdd extension', () {
      expect(5.isOdd, true);
      expect(4.isOdd, false);
    });

    test('days extension', () {
      expect(5.days, const Duration(days: 5));
    });

    test('hours extension', () {
      expect(3.hours, const Duration(hours: 3));
    });
  });
}
