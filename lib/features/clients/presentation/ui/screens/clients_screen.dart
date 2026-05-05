import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/localization/app_localizations_extension.dart';
import 'package:flutter_template/core/ui/constants/app_styles.dart';
import 'package:flutter_template/core/ui/constants/extension_colors_text.dart';
import 'package:flutter_template/features/clients/domain/entities/client_item_entity.dart';
import '../../bloc/clients_bloc.dart';
import '../widgets/widgets_export.dart';

/// Tela responsável por exibir a grande massa de dados de clientes,
/// demonstrando o uso de Isolates e renderização eficiente via Slivers.
class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  late ClientsBloc _clientsBloc;

  @override
  void initState() {
    _clientsBloc = BlocProvider.of<ClientsBloc>(context);
    _clientsBloc.add(const LoadClientsListEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textColors = Theme.of(context).extension<TextColors>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate('clients'),
          style: AppStyles.bold20().copyWith(color: textColors?.general),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColors?.general),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<ClientsBloc, ClientsState>(
        bloc: _clientsBloc,
        buildWhen: (previous, current) {
          return (current is LoadingClientsListState ||
              current is LoadedClientsListState ||
              current is ErrorLoadClientsListState);
        },
        builder: (BuildContext context, ClientsState currentState) {
          if (currentState is LoadedClientsListState) {
            return _loadedClientsListState(
              currentState.clientsEntity.clientsList,
            );
          } else if (currentState is ErrorLoadClientsListState) {
            return _errorHandleLoadClientsListState(currentState);
          }

          return _loadingClientsListState();
        },
      ),
    );
  }

  // Retorna widget de acordo com o estado retornado pelo Bloc
  // ===================================================================================================================

  Widget _loadingClientsListState() {
    final textColors = Theme.of(context).extension<TextColors>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(
            radius: 16,
            color: Color(0xFF6C63FF),
          ),
          const SizedBox(height: 16),
          Text(
            context.translate('processing_isolates'),
            style: AppStyles.regular14().copyWith(
              color: textColors?.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadedClientsListState(List<ClientItemEntity> clients) {
    final textColors = Theme.of(context).extension<TextColors>();

    if (clients.isEmpty) {
      return Center(
        child: Text(
          context.translate('no_clients_found'),
          style: AppStyles.regular14().copyWith(
            color: textColors?.secondary,
          ),
        ),
      );
    }
    return ClientsListWidget(clients: clients);
  }

  Widget _errorHandleLoadClientsListState(ErrorLoadClientsListState state) {
    final textColors = Theme.of(context).extension<TextColors>();

    return Center(
      child: InkWell(
        onTap: () => _clientsBloc.add(const LoadClientsListEvent()),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: textColors?.secondary,
                size: 42,
              ),
              const SizedBox(height: 12),
              Text(
                context.translate(state.errorStateType.message),
                style: AppStyles.regular14().copyWith(
                  color: textColors?.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
