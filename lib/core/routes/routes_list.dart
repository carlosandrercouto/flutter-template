// ignore_for_file: constant_identifier_names

enum RoutesList {
  // Login
  LoginScreen('LoginScreen'),

  // Home
  HomeScreen('HomeScreen'),

  // Feature Clients
  ClientsScreen('ClientsScreen');

  // Não altere os parametros
  final String routeName;

  const RoutesList(this.routeName);
}
