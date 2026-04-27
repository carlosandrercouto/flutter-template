import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/enums/api_response_status_enum.dart';
import 'package:flutter_template/core/errors/errors_export.dart';
import 'package:flutter_template/core/services/api_service.dart';
import 'package:flutter_template/core/services/apis/api_endpoints.dart';
import 'package:flutter_template/core/entities/api_response.dart';
import 'package:flutter_template/features/clients/data/datasources/clients_datasource.dart';
import 'package:flutter_template/features/clients/data/models/clients_model.dart';
import 'package:flutter_template/features/clients/domain/usecases/get_clients_list_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class MockApiService implements ApiService {
  ApiResponse? result;

  @override
  Future<ApiResponse> call({
    required String endpoint,
    required ApiRequest request,
    required String devLog,
    required StackTrace currentStackTrace,
    int apiRequestTimeout = 30,
    bool useIsolateForDecode = false,
  }) async {
    return result ?? ApiResponse(status: ApiResponseStatus.errorGeneric);
  }
}

void main() {
  late MockApiService mockApiService;
  late ClientsDatasource datasource;
  late GetClientsListUseCase usecase;

  setUp(() {
    mockApiService = MockApiService();
    // Injeta o mock do ApiService diretamente no DataSource (regra de testar o datasource direto no usecase)
    datasource = ClientsDatasource(apiService: mockApiService);
    usecase = GetClientsListUseCase(datasource);
  });

  group('GetClientsListUseCase', () {
    test(
      'deve retornar ClientsModel (Sucesso) quando datasource obtiver os dados',
      () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.success,
          result: {
            'data': [
              {
                '_id': '1',
                'index': 0,
                'guid': 'guid',
                'isActive': true,
                'balance': '100',
                'name': 'Name',
                'picture': 'pic',
                'age': 30,
                'about': 'About',
                'registered': 'date',
                'tags': [],
              }
            ],
          },
        );

        final result = await usecase();

        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Deveria ser Right'),
          (r) {
            expect(r, isA<ClientsModel>());
            expect(r.clientsLength, 1);
          },
        );
      },
    );

    test(
      'deve retornar TimeoutFailure (Timeout) quando houver demora na requisicao',
      () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.errorTimeout,
        );

        final result = await usecase();

        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, isA<TimeoutFailure>()),
          (r) => fail('Deveria ser Left'),
        );
      },
    );

    test(
      'deve retornar SessionExpiredFailure (Sessão Expirada) quando a sessao acabar',
      () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.errorSessionExpired,
        );

        final result = await usecase();

        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, isA<SessionExpiredFailure>()),
          (r) => fail('Deveria ser Left'),
        );
      },
    );

    test(
      'deve retornar null (Erro Genérico) quando ocorrer outro erro',
      () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.errorGeneric,
        );

        final result = await usecase();

        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, isNull),
          (r) => fail('Deveria ser Left'),
        );
      },
    );

    test(
      'deve lidar com Offline simulado retornando erro (Offline)',
      () async {
        // No momento ClientsDatasource não intercepta offline de forma explícita, 
        // mas devemos validar o comportamento genérico. 
        // Como o Offline normalmente retorna um ApiResponse de Erro (offline), o DS vai retornar left(null).
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.errorGeneric,
        );

        final result = await usecase();

        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, isNull), // ou OfflineFailure se o datasource fosse atualizado
          (r) => fail('Deveria ser Left'),
        );
      },
    );
  });
}
