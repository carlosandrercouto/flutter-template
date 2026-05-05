import 'package:flutter/material.dart';
import 'package:flutter_template/core/ui/constants/app_styles.dart';
import 'package:flutter_template/core/ui/constants/extension_colors_text.dart';

import '../../../domain/entities/client_item_entity.dart';
import 'client_item_widget.dart';

/// Widget responsável por exibir a lista de clientes via [SliverList].
class ClientsListWidget extends StatelessWidget {
  const ClientsListWidget({super.key, required this.clients});

  final List<ClientItemEntity> clients;

  @override
  Widget build(BuildContext context) {
    final textColors = Theme.of(context).extension<TextColors>();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Total de Clientes: ${clients.length}',
              style: AppStyles.semiBold14().copyWith(
                fontSize: 13,
                color: textColors?.secondary,
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
