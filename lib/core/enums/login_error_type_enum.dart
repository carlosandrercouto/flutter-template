/// Enum que representa os tipos de erro de login.
///
/// Segue o padrão de parse estático:
/// cada valor carrega seu próprio [errorMessage] como parâmetro,
/// e o lookup [fromFirebaseCode] mapeia os códigos do [FirebaseAuthException].
enum LoginErrorType {
  userNotFound(
    errorMessage: 'error_login_user_not_found',
    firebaseAuthErrorMessage: 'user-not-found',
  ),
  wrongPassword(
    errorMessage: 'error_login_wrong_password',
    firebaseAuthErrorMessage: 'wrong-password',
  ),
  invalidUserOrPassword(
    errorMessage: 'error_login_invalid_user_or_password',
    firebaseAuthErrorMessage: 'invalid-credential',
  ),
  inactiveUser(
    errorMessage: 'error_login_inactive_user',
    firebaseAuthErrorMessage: 'user-disabled',
  ),
  genericError(
    errorMessage: 'error_login_generic',
    firebaseAuthErrorMessage: '',
  )
  ;

  final String errorMessage;
  final String firebaseAuthErrorMessage;

  const LoginErrorType({
    required this.errorMessage,
    required this.firebaseAuthErrorMessage,
  });

  /// Retorna o [LoginErrorType] correspondente à mensagem de erro da API.
  ///
  /// Retorna [genericError] se a mensagem não for encontrada.
  static LoginErrorType fromString(String? message) {
    return LoginErrorType.values.firstWhere(
      (type) => type.firebaseAuthErrorMessage == message,
      orElse: () => LoginErrorType.genericError,
    );
  }
}
