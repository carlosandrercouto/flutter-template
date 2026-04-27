part of 'secure_storage_helper.dart';

enum SecureStorageHelperKeys {
  accessToken('accessToken'),
  refreshToken('refreshToken'),
  userToken('token'),
  userId('userId'),
  ;

  final String keyName;

  const SecureStorageHelperKeys(this.keyName);
}
