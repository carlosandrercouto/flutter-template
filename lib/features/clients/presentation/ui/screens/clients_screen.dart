import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      appBar: AppBar(
        title: const Text(
          'Clientes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D0F14),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
    // Utilizamos o CupertinoActivityIndicator para demonstrar que
    // a animação NÃO congela enquanto o Isolate faz o parse de 65MB
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(radius: 16, color: Color(0xFF6C63FF)),
          SizedBox(height: 16),
          Text(
            'Processando 1.6M linhas no Isolate...',
            style: TextStyle(color: Color(0xFF9BA3B8), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _loadedClientsListState(List<ClientItemEntity> clients) {
    if (clients.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum cliente encontrado.',
          style: TextStyle(color: Color(0xFF9BA3B8), fontSize: 14),
        ),
      );
    }
    return ClientsListWidget(clients: clients);
  }

  Widget _errorHandleLoadClientsListState(ErrorLoadClientsListState state) {
    return Center(
      child: InkWell(
        onTap: () => _clientsBloc.add(const LoadClientsListEvent()),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFF9BA3B8),
                size: 42,
              ),
              const SizedBox(height: 12),
              Text(
                state.errorStateType.message,
                style: const TextStyle(
                  color: Color(0xFF9BA3B8),
                  fontSize: 14,
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
