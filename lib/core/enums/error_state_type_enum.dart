enum ErrorStateType {
  timeout(message: 'error_timeout'),
  noInternetConnection(message: 'error_no_internet_connection'),
  sessionExpired(message: 'error_session_expired'),
  genericError(message: 'error_generic');

  final String message;

  const ErrorStateType({required this.message});
}
