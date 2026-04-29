import 'package:flutter_template/core/helpers/shared_preferences_helper/shared_preferences_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferencesHelper sharedPreferencesHelper;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() async {
    mockSharedPreferences = MockSharedPreferences();
    sharedPreferencesHelper = SharedPreferencesHelper();
    await sharedPreferencesHelper.init(sharedPreferences: mockSharedPreferences);
  });

  tearDown(() {
    reset(mockSharedPreferences);
  });

  group('SharedPreferencesHelper Save', () {
    const tKey = SharedPreferencesHelperKeys.currentLanguage;

    test('saveBoolValue should call setBool and return true', () async {
      when(() => mockSharedPreferences.setBool(any(), any())).thenAnswer((_) async => true);
      final result = await sharedPreferencesHelper.saveBoolValue(key: tKey, value: true);
      expect(result, isTrue);
      verify(() => mockSharedPreferences.setBool(tKey.keyName, true)).called(1);
    });

    test('saveDoubleValue should call setDouble and return true', () async {
      when(() => mockSharedPreferences.setDouble(any(), any())).thenAnswer((_) async => true);
      final result = await sharedPreferencesHelper.saveDoubleValue(key: tKey, value: 1.5);
      expect(result, isTrue);
      verify(() => mockSharedPreferences.setDouble(tKey.keyName, 1.5)).called(1);
    });

    test('saveIntValue should call setInt and return true', () async {
      when(() => mockSharedPreferences.setInt(any(), any())).thenAnswer((_) async => true);
      final result = await sharedPreferencesHelper.saveIntValue(key: tKey, value: 42);
      expect(result, isTrue);
      verify(() => mockSharedPreferences.setInt(tKey.keyName, 42)).called(1);
    });

    test('saveListStringValue should call setStringList and return true', () async {
      when(() => mockSharedPreferences.setStringList(any(), any())).thenAnswer((_) async => true);
      final result = await sharedPreferencesHelper.saveListStringValue(key: tKey, value: ['test']);
      expect(result, isTrue);
      verify(() => mockSharedPreferences.setStringList(tKey.keyName, ['test'])).called(1);
    });

    test('saveStringValue should call setString and return true', () async {
      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);
      final result = await sharedPreferencesHelper.saveStringValue(key: tKey, value: 'test');
      expect(result, isTrue);
      verify(() => mockSharedPreferences.setString(tKey.keyName, 'test')).called(1);
    });
  });

  group('SharedPreferencesHelper Get', () {
    const tKey = SharedPreferencesHelperKeys.currentLanguage;

    test('getBoolValue should call getBool and return correct value', () {
      when(() => mockSharedPreferences.getBool(any())).thenReturn(true);
      final result = sharedPreferencesHelper.getBoolValue(key: tKey);
      expect(result, isTrue);
      verify(() => mockSharedPreferences.getBool(tKey.keyName)).called(1);
    });

    test('getDoubleValue should call getDouble and return correct value', () {
      when(() => mockSharedPreferences.getDouble(any())).thenReturn(1.5);
      final result = sharedPreferencesHelper.getDoubleValue(key: tKey);
      expect(result, 1.5);
      verify(() => mockSharedPreferences.getDouble(tKey.keyName)).called(1);
    });

    test('getIntValue should call getInt and return correct value', () {
      when(() => mockSharedPreferences.getInt(any())).thenReturn(42);
      final result = sharedPreferencesHelper.getIntValue(key: tKey);
      expect(result, 42);
      verify(() => mockSharedPreferences.getInt(tKey.keyName)).called(1);
    });

    test('getListStringValue should call getStringList and return correct value', () {
      when(() => mockSharedPreferences.getStringList(any())).thenReturn(['test']);
      final result = sharedPreferencesHelper.getListStringValue(key: tKey);
      expect(result, ['test']);
      verify(() => mockSharedPreferences.getStringList(tKey.keyName)).called(1);
    });

    test('getStringValue should call getString and return correct value', () {
      when(() => mockSharedPreferences.getString(any())).thenReturn('test');
      final result = sharedPreferencesHelper.getStringValue(key: tKey);
      expect(result, 'test');
      verify(() => mockSharedPreferences.getString(tKey.keyName)).called(1);
    });
  });

  group('SharedPreferencesHelper Remove and Clear', () {
    const tKey = SharedPreferencesHelperKeys.currentLanguage;

    test('removeKeyAndValue should call remove and return true', () async {
      when(() => mockSharedPreferences.remove(any())).thenAnswer((_) async => true);
      final result = await sharedPreferencesHelper.removeKeyAndValue(key: tKey);
      expect(result, isTrue);
      verify(() => mockSharedPreferences.remove(tKey.keyName)).called(1);
    });

    test('cleanValues should call clear and return true', () async {
      when(() => mockSharedPreferences.clear()).thenAnswer((_) async => true);
      final result = await sharedPreferencesHelper.cleanValues();
      expect(result, isTrue);
      verify(() => mockSharedPreferences.clear()).called(1);
    });
  });
}
