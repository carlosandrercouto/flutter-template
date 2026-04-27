import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_export.dart';
import '../entities/clients_entity.dart';

/// Contrato para o repositório de clientes.
abstract class ClientsRepository {
  /// Retorna a lista completa de clientes.
  ///
  /// Retorna um [Either] contendo uma falha ou [ClientsEntity].
  Future<Either<Failure?, ClientsEntity>> getClientsList();
}
