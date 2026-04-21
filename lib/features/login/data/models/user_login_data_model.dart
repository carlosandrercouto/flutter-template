import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/enums/enums_export.dart';
import '../../domain/entities/user_login_data.dart';

/// Model de dados do usuário após login Firebase.
///
/// Construtor privado [_internal] com super nos parâmetros +
/// factory [fromFirebase] responsável pelo mapeamento do [UserCredential].
class UserLoginDataModel extends UserLoginData {
  const UserLoginDataModel._internal({
    required super.token,
    required super.userId,
    required super.name,
    required super.email,
    super.error,
  }) : super();

  /// Cria um [UserLoginDataModel] a partir de uma [UserCredential] e do [idToken] JWT.
  factory UserLoginDataModel.fromFirebase({
    required UserCredential userCredential,
    required String idToken,
  }) {
    final user = userCredential.user!;
    return UserLoginDataModel._internal(
      token: idToken,
      userId: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  factory UserLoginDataModel.fromFirebaseError({
    required String? error,
  }) {
    return UserLoginDataModel._internal(
      token: '',
      userId: '',
      name: '',
      email: '',
      error: error != null ? LoginErrorType.fromString(error) : null,
    );
  }
}
