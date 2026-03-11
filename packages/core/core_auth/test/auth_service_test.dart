import 'package:flutter_test/flutter_test.dart';
import 'package:core_auth/core_auth.dart';

void main() {
  group('User Model Tests', () {
    test('should create User from JSON', () {
      final json = {
        'id': '123',
        'username': 'testuser',
        'email': 'test@example.com',
        'avatar': 'https://example.com/avatar.jpg',
      };

      final user = User.fromJson(json);

      expect(user.id, '123');
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.avatar, 'https://example.com/avatar.jpg');
    });

    test('should convert User to JSON', () {
      final user = User(
        id: '123',
        username: 'testuser',
        email: 'test@example.com',
      );

      final json = user.toJson();

      expect(json['id'], '123');
      expect(json['username'], 'testuser');
      expect(json['email'], 'test@example.com');
    });

    test('should copy User with modifications', () {
      final user = User(
        id: '123',
        username: 'testuser',
        email: 'test@example.com',
      );

      final copiedUser = user.copyWith(username: 'newuser');

      expect(copiedUser.id, '123');
      expect(copiedUser.username, 'newuser');
      expect(copiedUser.email, 'test@example.com');
    });
  });

  group('AuthToken Model Tests', () {
    test('should create AuthToken from JSON', () {
      final json = {
        'access_token': 'test_access_token',
        'refresh_token': 'test_refresh_token',
        'expires_in': 3600,
        'token_type': 'Bearer',
      };

      final token = AuthToken.fromJson(json);

      expect(token.accessToken, 'test_access_token');
      expect(token.refreshToken, 'test_refresh_token');
      expect(token.tokenType, 'Bearer');
    });

    test('should check if token is expired', () {
      final expiredToken = AuthToken(
        accessToken: 'test',
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
      );
      expect(expiredToken.isExpired, true);

      final validToken = AuthToken(
        accessToken: 'test',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );
      expect(validToken.isExpired, false);
    });

    test('should check if token is expiring soon', () {
      final expiringSoonToken = AuthToken(
        accessToken: 'test',
        expiresAt: DateTime.now().add(const Duration(minutes: 3)),
      );
      expect(expiringSoonToken.isExpiringSoon, true);

      final notExpiringSoonToken = AuthToken(
        accessToken: 'test',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );
      expect(notExpiringSoonToken.isExpiringSoon, false);
    });
  });

  group('AuthState Model Tests', () {
    test('should create initial state', () {
      const state = AuthState.initial();

      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
      expect(state.token, isNull);
      expect(state.isUnauthenticated, true);
    });

    test('should create authenticated state', () {
      final user = User(
        id: '123',
        username: 'testuser',
        email: 'test@example.com',
      );
      final token = AuthToken(
        accessToken: 'test_token',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );

      final state = AuthState.authenticated(user: user, token: token);

      expect(state.status, AuthStatus.authenticated);
      expect(state.user, user);
      expect(state.token, token);
      expect(state.isAuthenticated, true);
    });

    test('should create failed state', () {
      const state = AuthState.failed('Login failed');

      expect(state.status, AuthStatus.failed);
      expect(state.errorMessage, 'Login failed');
      expect(state.isFailed, true);
    });
  });
}
