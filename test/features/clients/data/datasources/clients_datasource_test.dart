import 'package:flutter_template/core/enums/api_response_status_enum.dart';
import 'package:flutter_template/core/errors/errors_export.dart';
import 'package:flutter_template/core/services/api_service.dart';
import 'package:flutter_template/core/services/apis/api_endpoints.dart';
import 'package:flutter_template/core/entities/api_response.dart';
import 'package:flutter_template/features/clients/data/datasources/clients_datasource.dart';
import 'package:flutter_template/features/clients/data/models/clients_model.dart';
import 'package:flutter_test/flutter_test.dart';

class MockApiService implements ApiService {
  ApiResponse? result;
  String? lastEndpoint;

  @override
  Future<ApiResponse> call({
    required String endpoint,
    required ApiRequest request,
    required String devLog,
    required StackTrace currentStackTrace,
    int apiRequestTimeout = 30,
    bool useIsolateForDecode = false,
  }) async {
    lastEndpoint = endpoint;
    return result ?? ApiResponse(status: ApiResponseStatus.errorGeneric);
  }
}

void main() {
  late MockApiService mockApiService;
  late ClientsDatasource datasource;

  setUp(() {
    mockApiService = MockApiService();
    datasource = ClientsDatasource(apiService: mockApiService);
  });

  group('ClientsDatasource', () {
    test(
      'deve retornar ClientsModel quando sucesso com map validos',
      () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.success,
          result: {
            'data': [
              {
                '_id': '1',
                'index': 0,
                'guid': 'guid1',
                'isActive': true,
                'balance': '100',
                'name': 'Client 1',
                'picture': 'pic.jpg',
                'age': 30,
                'about': 'About',
                'registered': '2023-01-01',
                'tags': ['tag1'],
              },
            ],
          },
        );

        final result = await datasource.getClientsList();

        expect(mockApiService.lastEndpoint, ApiEndpoints.getMassData.url);
        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Deveria ser Right'),
          (r) {
            expect(r, isA<ClientsModel>());
            expect(r.clientsLength, 1);
            expect(r.clientsList.first.name, 'Client 1');
          },
        );
      },
    );

    test(
      'deve retornar Left com nulo quando der erro de parser',
      () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.success,
          result: {
            'data': [
              {
                'invalido': 'sim',
              }, // Sem chaves necessárias vai falhar no parser ou não dependendo do fromMap
            ],
          },
        );

        // Actually if fromMap is robust it just uses defaults. Let's send something that causes error
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.success,
          result:
              null, // this will throw since it tries to get ['data'] on null
        );

        final result = await datasource.getClientsList();

        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, isNull),
          (r) => fail('Deveria ser Left'),
        );
      },
    );

    test(
      'deve retornar TimeoutFailure quando estatus for errorTimeout',
      () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.errorTimeout,
        );

        final result = await datasource.getClientsList();

        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, isA<TimeoutFailure>()),
          (r) => fail('Deveria ser Left'),
        );
      },
    );

    test(
      'deve retornar SessionExpiredFailure quando estatus for errorSessionExpired',
      () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.errorSessionExpired,
        );

        final result = await datasource.getClientsList();

        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, isA<SessionExpiredFailure>()),
          (r) => fail('Deveria ser Left'),
        );
      },
    );

    test(
      'deve retornar Left com nulo quando for qualquer outro erro de API',
      () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.errorGeneric,
        );

        final result = await datasource.getClientsList();

        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, isNull),
          (r) => fail('Deveria ser Left'),
        );
      },
    );
  });
}
