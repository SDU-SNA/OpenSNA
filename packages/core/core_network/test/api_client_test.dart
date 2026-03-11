import 'package:flutter_test/flutter_test.dart';
import 'package:core_network/core_network.dart';

void main() {
  group('ApiClient Tests', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = ApiClient(
        config: NetworkConfig.development(),
        getToken: () async => 'test_token',
      );
    });

    test('ApiClient should be created successfully', () {
      expect(apiClient, isNotNull);
    });

    test('NetworkConfig development should have correct baseUrl', () {
      final config = NetworkConfig.development();
      expect(config.baseUrl, 'https://dev-api.sdu.edu.cn');
      expect(config.enableLog, true);
    });

    test('NetworkConfig production should have correct baseUrl', () {
      final config = NetworkConfig.production();
      expect(config.baseUrl, 'https://api.sdu.edu.cn');
      expect(config.enableLog, false);
    });

    test('ApiResponse should parse JSON correctly', () {
      final json = {
        'code': 200,
        'message': 'success',
        'data': {'id': 1, 'name': 'test'},
        'timestamp': 1234567890,
      };

      final response = ApiResponse.fromJson(json, null);
      expect(response.code, 200);
      expect(response.message, 'success');
      expect(response.isSuccess, true);
    });
  });
}
