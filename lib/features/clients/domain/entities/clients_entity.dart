import 'package:equatable/equatable.dart';

import 'client_item_entity.dart';

/// Entidade raiz que representa a lista de clientes.
class ClientsEntity extends Equatable {
  final int clientsLength;
  final List<ClientItemEntity> clientsList;

  const ClientsEntity({
    required this.clientsLength,
    required this.clientsList,
  });

  @override
  List<Object?> get props => [clientsLength, clientsList];
}
