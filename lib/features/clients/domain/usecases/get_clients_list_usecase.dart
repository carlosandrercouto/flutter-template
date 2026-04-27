import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/clients_entity.dart';
import '../repositories/clients_repository.dart';

/// Caso de uso responsável por obter a lista de clientes.
class GetClientsListUseCase {
  final ClientsRepository repository;

  GetClientsListUseCase(this.repository);

  /// Executa o caso de uso.
  Future<Either<Failure?, ClientsEntity>> call() async {
    return repository.getClientsList();
  }
}
