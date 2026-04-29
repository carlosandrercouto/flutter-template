import 'package:flutter_template/core/enums/api_response_status_enum.dart';
import 'package:flutter_template/core/helpers/mock_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockHelper mockHelper;

  setUp(() {
    mockHelper = MockHelper.instance;
  });

  group('MockHelper', () {
    test('should return the same instance (Singleton)', () {
      final instance1 = MockHelper.instance;
      final instance2 = MockHelper.instance;
      expect(identical(instance1, instance2), isTrue);
    });

    test('shouldMockRoute should return true for registered routes', () {
      expect(mockHelper.shouldMockRoute('/auth/login'), isTrue);
      expect(mockHelper.shouldMockRoute('/auth/reset-password'), isTrue);
      expect(mockHelper.shouldMockRoute('/home/transactions'), isTrue);
      expect(mockHelper.shouldMockRoute('/mass-data'), isTrue);
    });

    test('shouldMockRoute should return false for unregistered routes', () {
      expect(mockHelper.shouldMockRoute('/unregistered/route'), isFalse);
    });

    test('call should return ApiResponseStatus.errorGeneric for unknown endpoint', () async {
      // Act
      final result = await mockHelper.call(endpoint: '/unknown');

      // Assert
      expect(result.status, ApiResponseStatus.errorGeneric);
    });

    test('call should return success for /auth/login with valid credentials', () async {
      // Act
      final result = await mockHelper.call(
        endpoint: '/auth/login',
        body: {'email': 'user@test.com', 'password': '123456'},
      );

      // Assert
      expect(result.status, ApiResponseStatus.success);
      expect(result.result, isA<Map<String, dynamic>>());
      final resultMap = result.result as Map<String, dynamic>;
      expect(resultMap['token'], isNotEmpty);
      expect(resultMap['userId'], 'user-001');
    });

    test('call should return success but with error message for /auth/login with invalid credentials', () async {
      // Act
      final result = await mockHelper.call(
        endpoint: '/auth/login',
        body: {'email': 'wrong@test.com', 'password': 'wrong'},
      );

      // Assert
      expect(result.status, ApiResponseStatus.success);
      final resultMap = result.result as Map<String, dynamic>;
      expect(resultMap['error'], 'Usuário ou Senha Inválidos');
      expect(resultMap['token'], isEmpty);
    });

    test('call should return success for /auth/reset-password', () async {
      // Act
      final result = await mockHelper.call(
        endpoint: '/auth/reset-password',
        body: {'email': 'user@test.com'},
      );

      // Assert
      expect(result.status, ApiResponseStatus.success);
      final resultMap = result.result as Map<String, dynamic>;
      expect(resultMap['message'], 'E-mail de recuperação enviado com sucesso.');
    });

    test('call should return success and correct data for /home/transactions', () async {
      // Act
      final result = await mockHelper.call(endpoint: '/home/transactions');

      // Assert
      expect(result.status, ApiResponseStatus.success);
      final resultMap = result.result as Map<String, dynamic>;
      expect(resultMap['balance'], isNotNull);
      expect(resultMap['transactions'], isA<List>());
      expect((resultMap['transactions'] as List).length, 7);
    });

    test('call should return success and correct data for /mass-data', () async {
      // Act
      final result = await mockHelper.call(endpoint: '/mass-data');

      // Assert
      expect(result.status, ApiResponseStatus.success);
      final resultMap = result.result as Map<String, dynamic>;
      expect(resultMap['data'], isA<List>());
      expect((resultMap['data'] as List).length, 2);
    });
  });
}
