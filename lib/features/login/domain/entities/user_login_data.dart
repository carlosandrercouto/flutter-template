import 'package:equatable/equatable.dart';
import 'package:flutter_template/core/enums/login_error_type_enum.dart';

import 'login_error_data.dart';

/// Entidade de domínio que representa os dados do usuário após login bem-sucedido.
class UserLoginData extends Equatable {
  final String token;
  final String userId;
  final String name;
  final String email;
  final LoginErrorType? error;

  const UserLoginData({
    required this.token,
    required this.userId,
    required this.name,
    required this.email,
    required this.error,
  });

  bool get isAuthenticated => token.isNotEmpty && userId.isNotEmpty;

  UserLoginData copyWith({
    String? token,
    String? userId,
    String? name,
    String? email,
    LoginErrorType? error,
  }) {
    return UserLoginData(
      token: token ?? this.token,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [token, userId, name, email, error];
}
