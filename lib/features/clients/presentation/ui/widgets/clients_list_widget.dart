import 'package:flutter/material.dart';

import '../../../domain/entities/client_item_entity.dart';
import 'client_item_widget.dart';

/// Widget responsável por exibir a lista de clientes via [SliverList].
class ClientsListWidget extends StatelessWidget {
  const ClientsListWidget({super.key, required this.clients});

  final List<ClientItemEntity> clients;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Total de Clientes: ${clients.length}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9BA3B8),
              ),
            ),
          ),
        ),
        SliverList.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) =>
              ClientItemWidget(client: clients[index]),
        ),
      ],
    );
  }
}
