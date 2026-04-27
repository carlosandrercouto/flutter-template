import '../../domain/entities/clients_entity.dart';
import 'client_item_model.dart';

/// Model raiz da lista de clientes.
class ClientsModel extends ClientsEntity {
  const ClientsModel({
    required super.clientsLength,
    required super.clientsList,
  });

  /// Realiza o parse da lista de mapas para o modelo principal.
  /// 
  /// Este método é pesado e deve ser chamado dentro de um Isolate.
  factory ClientsModel.fromMapList(List<dynamic> list) {
    final clientsList = list
        .map((item) => ClientItemModel.fromMap(item as Map<String, dynamic>))
        .toList();

    return ClientsModel(
      clientsLength: clientsList.length,
      clientsList: clientsList,
    );
  }
}
