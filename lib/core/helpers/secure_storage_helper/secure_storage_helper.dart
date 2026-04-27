import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'secure_storage_helper_keys.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _secureStorage;

  SecureStorageHelper({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<void> saveData({
    required SecureStorageHelperKeys key,
    required String value,
  }) async {
    await _secureStorage.write(key: key.keyName, value: value);
  }

  Future<String?> getData({required SecureStorageHelperKeys key}) async {
    return await _secureStorage.read(key: key.keyName);
  }

  Future<void> deleteData({required SecureStorageHelperKeys key}) async {
    await _secureStorage.delete(key: key.keyName);
  }
}
