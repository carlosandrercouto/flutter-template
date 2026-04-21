/// Enum que representa os tipos de erro de login.
///
/// Segue o padrão de parse estático:
/// cada valor carrega seu próprio [errorMessage] como parâmetro,
/// e o lookup [fromFirebaseCode] mapeia os códigos do [FirebaseAuthException].
enum LoginErrorType {
  userNotFound(
    errorMessage: 'Usuário ou Senha Inválidos',
    firebaseAuthErrorMessage: 'user-not-found',
  ),
  wrongPassword(
    errorMessage: 'Usuário ou Senha Inválidos',
    firebaseAuthErrorMessage: 'wrong-password',
  ),
  invalidUserOrPassword(
    errorMessage: 'Usuário ou Senha Inválidos',
    firebaseAuthErrorMessage: 'invalid-credential',
  ),
  inactiveUser(
    errorMessage: 'Usuário inativo!',
    firebaseAuthErrorMessage: 'user-disabled',
  ),
  genericError(
    errorMessage: 'Ocorreu um erro inesperado no processo de login.',
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
