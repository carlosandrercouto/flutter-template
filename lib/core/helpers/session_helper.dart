import 'dart:developer';

import 'package:flutter_template/core/helpers/secure_storage_helper/secure_storage_helper.dart';
import 'package:get_it/get_it.dart' show GetIt;

import '../../features/login/domain/entities/user_login_data.dart';

/// Gerencia os dados da sessão do usuário em memória.
///
/// Singleton que centraliza o acesso ao token de API e dados do usuário,
/// eliminando a necessidade de passar o token em cada DataSource individualmente.
///
/// Deve ser inicializado logo após o login bem-sucedido via [initUserLoginData].
///
/// Exemplo de uso no DataSource:
/// ```dart
/// final token = GetIt.instance<SessionHelper>().token;
/// ```
class SessionHelper {
  final SecureStorageHelper _secureStorageHelper;

  SessionHelper({SecureStorageHelper? secureStorageHelper})
    : _secureStorageHelper =
          secureStorageHelper ?? GetIt.instance<SecureStorageHelper>();

  late UserLoginData _userLoginData;

  /// Dados completos do usuário logado.
  UserLoginData get userLoginData => _userLoginData;

  /// Token de acesso à API.
  String get token => _userLoginData.token;

  /// ID do usuário logado.
  String get userId => _userLoginData.userId;

  /// Nome do usuário logado.
  String get userName => _userLoginData.name;

  /// E-mail do usuário logado.
  String get userEmail => _userLoginData.email;

  /// Whether o usuário está autenticado (possui token e userId válidos).
  bool get isAuthenticated => _userLoginData.isAuthenticated;

  /// Inicializa os dados do usuário após login bem-sucedido.
  ///
  /// Deve ser chamado imediatamente após receber os dados de login,
  /// antes de qualquer navegação ou chamada autenticada à API.
  void initUserLoginData({required UserLoginData userLoginData}) {
    _userLoginData = userLoginData;
    _secureStorageHelper.saveData(
      key: SecureStorageHelperKeys.userToken,
      value: _userLoginData.token,
    );
    _secureStorageHelper.saveData(
      key: SecureStorageHelperKeys.userId,
      value: _userLoginData.userId,
    );

    log(userLoginData.userId, name: '👤 SessionHelper: userId');
    log(
      userLoginData.token.isNotEmpty ? userLoginData.token : '[token empty]',
      name: '👤 SessionHelper: token',
    );
  }
}
