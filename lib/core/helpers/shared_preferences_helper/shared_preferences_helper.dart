import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_helper_keys.dart';

class SharedPreferencesHelper {
  late final SharedPreferences _sharedPreferences;

  Future<void> init({SharedPreferences? sharedPreferences}) async {
    _sharedPreferences =
        sharedPreferences ?? await SharedPreferences.getInstance();
  }

  // Métodos save
  // ===================================================================================================================
  Future<bool> saveBoolValue({
    required SharedPreferencesHelperKeys key,
    required bool value,
  }) async {
    return _sharedPreferences.setBool(key.keyName, value);
  }

  Future<bool> saveDoubleValue({
    required SharedPreferencesHelperKeys key,
    required double value,
  }) async {
    return _sharedPreferences.setDouble(key.keyName, value);
  }

  Future<bool> saveIntValue({
    required SharedPreferencesHelperKeys key,
    required int value,
  }) async {
    return _sharedPreferences.setInt(key.keyName, value);
  }

  Future<bool> saveListStringValue({
    required SharedPreferencesHelperKeys key,
    required List<String> value,
  }) async {
    return _sharedPreferences.setStringList(key.keyName, value);
  }

  Future<bool> saveStringValue({
    required SharedPreferencesHelperKeys key,
    required String value,
  }) async {
    return _sharedPreferences.setString(key.keyName, value);
  }

  // Métodos get
  // ===================================================================================================================
  bool? getBoolValue({required SharedPreferencesHelperKeys key}) {
    return _sharedPreferences.getBool(key.keyName);
  }

  double? getDoubleValue({required SharedPreferencesHelperKeys key}) {
    return _sharedPreferences.getDouble(key.keyName);
  }

  int? getIntValue({required SharedPreferencesHelperKeys key}) {
    return _sharedPreferences.getInt(key.keyName);
  }

  List<String>? getListStringValue({required SharedPreferencesHelperKeys key}) {
    return _sharedPreferences.getStringList(key.keyName);
  }

  String? getStringValue({required SharedPreferencesHelperKeys key}) {
    return _sharedPreferences.getString(key.keyName);
  }

  // Métodos remove
  // ===================================================================================================================

  Future<bool> removeKeyAndValue({
    required SharedPreferencesHelperKeys key,
  }) async {
    return await _sharedPreferences.remove(key.keyName);
  }

  /// Remove todas as chaves e valores do SharedPreferences
  Future<bool> cleanValues() async {
    return await _sharedPreferences.clear();
  }
}
