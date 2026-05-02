import 'dart:developer';
import 'dart:isolate';

import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../../../core/enums/api_response_status_enum.dart';
import '../../../../core/errors/errors_export.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/apis/api_endpoints.dart';
import '../../../../core/entities/api_response.dart';

import '../../domain/repositories/clients_repository.dart';
import '../models/clients_model.dart';

/// Datasource responsável por obter e processar a lista de clientes.
class ClientsDatasource extends ClientsRepository {
  final ApiService _apiService;

  ClientsDatasource({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  @override
  Future<Either<Failure?, ClientsModel>> getClientsList() async {
    final ApiEndpoints endpoint = ApiEndpoints.getMassData;

    final ApiResponse apiResponse = await _apiService(
      endpoint: endpoint.url,
      request: ApiRequest(requestType: endpoint.requestType, body: {}),
      devLog: 'ClientsDatasource: getClientsList',
      currentStackTrace: StackTrace.current,
      useIsolateForDecode: true, // Habilita o parse via isolate no Service
    );

    if (apiResponse.status == ApiResponseStatus.success) {
      try {
        final List<dynamic> dataList =
            apiResponse.result!['data'] as List<dynamic>? ?? [];

        // Realizamos o parse do JSON Map -> Model dentro de outro Isolate
        // Para não travar a UI ao mapear mais de 1.6M de objetos
        final parsedModel = await Isolate.run(
          () => ClientsModel.fromMapList(dataList),
        );

        return Right(parsedModel);
      } catch (error, stackTrace) {
        log(
          'Error: ${error.toString()}',
          name: 'ClientsDatasource: getClientsList',
        );

        FirebaseCrashlytics.instance.recordError(error, stackTrace);
        return const Left(null);
      }
    } else if (apiResponse.status == ApiResponseStatus.errorTimeout) {
      return Left(TimeoutFailure());
    } else if (apiResponse.status == ApiResponseStatus.errorSessionExpired) {
      return Left(SessionExpiredFailure());
    }

    return const Left(null);
  }
}
