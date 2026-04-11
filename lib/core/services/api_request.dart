part of 'api_service.dart';

/// Encapsula os dados de uma requisição HTTP.
///
/// Estrutura de dados encapsuladora padrão para disparos web.
class ApiRequest {
  final Map<String, String>? headers;
  final Map<String, String>? params;
  final Object body;
  final ApiRequestType requestType;

  ApiRequest({
    required this.requestType,
    this.headers,
    this.body = const {},
    this.params,
  });
}
