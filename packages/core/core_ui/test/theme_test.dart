import 'package:flutter_test/flutter_test.dart';
import 'package:core_ui/core_ui.dart';

void main() {
  group('AppColors Tests', () {
    test('should have correct primary colors', () {
      expect(AppColors.primary, const Color(0xFF1976D2));
      expect(AppColors.primaryLight, const Color(0xFF63A4FF));
      expect(AppColors.primaryDark, const Color(0xFF004BA0));
    });

    test('should have correct functional colors', () {
      expect(AppColors.success, const Color(0xFF4CAF50));
      expect(AppColors.warning, const Color(0xFFFFC107));
      expect(AppColors.error, const Color(0xFFF44336));
      expect(AppColors.info, const Color(0xFF2196F3));
    });

    test('should lighten color correctly', () {
      final lightened = AppColors.lighten(AppColors.primary, 0.2);
      expect(lightened, isNot(AppColors.primary));
    });

    test('should darken color correctly', () {
      final darkened = AppColors.darken(AppColors.primary, 0.2);
      expect(darkened, isNot(AppColors.primary));
    });
  });

  group('AppTextStyles Tests', () {
    test('should have correct display styles', () {
      expect(AppTextStyles.displayLarge.fontSize, 32);
      expect(AppTextStyles.displayMedium.fontSize, 28);
      expect(AppTextStyles.displaySmall.fontSize, 24);
    });

    test('should have correct headline styles', () {
      expect(AppTextStyles.headlineLarge.fontSize, 22);
      expect(AppTextStyles.headlineMedium.fontSize, 20);
      expect(AppTextStyles.headlineSmall.fontSize, 18);
    });

    test('should have correct body styles', () {
      expect(AppTextStyles.bodyLarge.fontSize, 16);
      expect(AppTextStyles.bodyMedium.fontSize, 14);
      expect(AppTextStyles.bodySmall.fontSize, 12);
    });

    test('should have correct button style', () {
      expect(AppTextStyles.button.fontSize, 14);
      expect(AppTextStyles.button.fontWeight, FontWeight.w600);
    });
  });

  group('AppTheme Tests', () {
    test('should create light theme', () {
      final theme = AppTheme.lightTheme;
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.useMaterial3, true);
    });

    test('should create dark theme', () {
      final theme = AppTheme.darkTheme;
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, AppColors.primaryLight);
      expect(theme.useMaterial3, true);
    });

    test('light theme should have correct text theme', () {
      final theme = AppTheme.lightTheme;
      expect(theme.textTheme.displayLarge?.fontSize, 32);
      expect(theme.textTheme.bodyLarge?.fontSize, 16);
    });

    test('dark theme should have correct text theme', () {
      final theme = AppTheme.darkTheme;
      expect(theme.textTheme.displayLarge?.fontSize, 32);
      expect(theme.textTheme.bodyLarge?.fontSize, 16);
    });
  });

  group('Widget Tests', () {
    testWidgets('LoadingWidget should display correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(
              message: 'Loading...',
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('EmptyWidget should display correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyWidget(
              icon: Icons.inbox,
              title: 'No Data',
              description: 'No data available',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('No Data'), findsOneWidget);
      expect(find.text('No data available'), findsOneWidget);
    });

    testWidgets('AppErrorWidget should display correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(
              message: 'Error occurred',
              details: 'Something went wrong',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Error occurred'), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('重试'), findsOneWidget);
    });
  });
}
