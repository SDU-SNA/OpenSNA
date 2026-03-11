import 'package:flutter_test/flutter_test.dart';
import 'package:core_router/core_router.dart';

void main() {
  group('AppRoutes Tests', () {
    test('should have correct route paths', () {
      expect(AppRoutes.root, '/');
      expect(AppRoutes.login, '/login');
      expect(AppRoutes.register, '/register');
      expect(AppRoutes.home, '/home');
      expect(AppRoutes.profile, '/profile');
      expect(AppRoutes.settings, '/settings');
    });
  });

  group('AppRouter Tests', () {
    test('should create router with default configuration', () {
      final router = AppRouter.createRouter();
      expect(router, isNotNull);
      expect(router.routerDelegate, isNotNull);
    });

    test('should create router with custom initial location', () {
      final router = AppRouter.createRouter(
        initialLocation: AppRoutes.home,
      );
      expect(router, isNotNull);
    });
  });
}
