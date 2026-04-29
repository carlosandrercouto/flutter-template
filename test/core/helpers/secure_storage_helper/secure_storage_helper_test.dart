import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_template/core/helpers/secure_storage_helper/secure_storage_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late SecureStorageHelper secureStorageHelper;
  late MockFlutterSecureStorage mockFlutterSecureStorage;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    secureStorageHelper = SecureStorageHelper(secureStorage: mockFlutterSecureStorage);
  });

  tearDown(() {
    reset(mockFlutterSecureStorage);
  });

  group('SecureStorageHelper', () {
    const tKey = SecureStorageHelperKeys.userToken;
    const tValue = 'test-token';

    test('should call write on FlutterSecureStorage when saveData is called', () async {
      // Arrange
      when(() => mockFlutterSecureStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      // Act
      await secureStorageHelper.saveData(key: tKey, value: tValue);

      // Assert
      verify(() => mockFlutterSecureStorage.write(key: tKey.keyName, value: tValue)).called(1);
      verifyNoMoreInteractions(mockFlutterSecureStorage);
    });

    test('should call read on FlutterSecureStorage and return data when getData is called', () async {
      // Arrange
      when(() => mockFlutterSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => tValue);

      // Act
      final result = await secureStorageHelper.getData(key: tKey);

      // Assert
      expect(result, tValue);
      verify(() => mockFlutterSecureStorage.read(key: tKey.keyName)).called(1);
      verifyNoMoreInteractions(mockFlutterSecureStorage);
    });

    test('should call delete on FlutterSecureStorage when deleteData is called', () async {
      // Arrange
      when(() => mockFlutterSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      // Act
      await secureStorageHelper.deleteData(key: tKey);

      // Assert
      verify(() => mockFlutterSecureStorage.delete(key: tKey.keyName)).called(1);
      verifyNoMoreInteractions(mockFlutterSecureStorage);
    });
  });
}
