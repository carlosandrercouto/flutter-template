import 'package:flutter_template/core/helpers/firebase_auth_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirebaseAuthHelper', () {
    test('should return the same instance (Singleton)', () {
      // Act
      final instance1 = FirebaseAuthHelper.instance;
      final instance2 = FirebaseAuthHelper.instance;

      // Assert
      expect(identical(instance1, instance2), isTrue);
    });
  });
}
