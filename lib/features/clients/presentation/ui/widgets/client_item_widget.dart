import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/client_item_entity.dart';

/// Widget responsável por exibir um item de cliente na lista.
class ClientItemWidget extends StatelessWidget {
  const ClientItemWidget({super.key, required this.client});

  final ClientItemEntity client;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF252A38),
        backgroundImage: client.picture.isNotEmpty
            ? CachedNetworkImageProvider(client.picture)
            : null,
        child: client.picture.isEmpty
            ? const Icon(Icons.person, color: Colors.white)
            : null,
      ),
      title: Text(
        client.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        'Idade: ${client.age} • Saldo: ${client.balance}',
        style: const TextStyle(
          color: Color(0xFF9BA3B8),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(
        Icons.circle,
        size: 12,
        color: client.isActive ? Colors.green : const Color(0xFFFF6B8A),
      ),
    );
  }
}
