import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_template/core/ui/constants/app_styles.dart';
import 'package:flutter_template/core/ui/constants/extension_colors_background.dart';
import 'package:flutter_template/core/ui/constants/extension_colors_text.dart';
import '../../../domain/entities/client_item_entity.dart';

/// Widget responsável por exibir um item de cliente na lista.
class ClientItemWidget extends StatelessWidget {
  const ClientItemWidget({super.key, required this.client});

  final ClientItemEntity client;

  @override
  Widget build(BuildContext context) {
    final textColors = Theme.of(context).extension<TextColors>();
    final backgroundColors = Theme.of(context).extension<BackgroundExtensionColors>();

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: backgroundColors?.surface,
        backgroundImage: client.picture.isNotEmpty
            ? CachedNetworkImageProvider(client.picture)
            : null,
        child: client.picture.isEmpty
            ? Icon(Icons.person, color: textColors?.general)
            : null,
      ),
      title: Text(
        client.name,
        style: AppStyles.bold14().copyWith(color: textColors?.general),
      ),
      subtitle: Text(
        'Idade: ${client.age} • Saldo: ${client.balance}',
        style: AppStyles.regular12().copyWith(color: textColors?.secondary),
      ),
      trailing: Icon(
        Icons.circle,
        size: 12,
        color: client.isActive ? Colors.green : const Color(0xFFFF6B8A),
      ),
    );
  }
}
