import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/error_state_type_enum.dart';
import '../../../../core/errors/errors_export.dart';
import '../../data/datasources/clients_datasource.dart';
import '../../domain/entities/clients_entity.dart';
import '../../domain/repositories/clients_repository.dart';
import '../../domain/usecases/get_clients_list_usecase.dart';

part 'clients_event.dart';
part 'clients_state.dart';

/// BLoC responsável pelo gerenciamento de estado da feature Clients.
///
/// Orquestra o carregamento dos clientes e expõe os estados
/// correspondentes para a camada de apresentação.
class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  final ClientsRepository _clientsRepository;

  ClientsBloc({ClientsRepository? clientsRepository})
      : _clientsRepository = clientsRepository ?? ClientsDatasource(),
        super(ClientsInitialState()) {
    on<LoadClientsListEvent>(_onLoadClientsList);
  }

  /// Carrega os dados da tela Clients.
  Future<void> _onLoadClientsList(
    LoadClientsListEvent event,
    Emitter<ClientsState> emit,
  ) async {
    emit(LoadingClientsListState());

    /// TODO: Adicionar verificação de device offline

    final getClientsListUseCase = GetClientsListUseCase(
      _clientsRepository,
    );
    final getClientsListData = await getClientsListUseCase();

    getClientsListData.fold(
      (failure) {
        if (failure is TimeoutFailure) {
          emit(
            ErrorLoadClientsListState(
              errorStateType: ErrorStateType.timeout,
            ),
          );
        } else if (failure is SessionExpiredFailure) {
          emit(
            ErrorLoadClientsListState(
              errorStateType: ErrorStateType.sessionExpired,
            ),
          );
        } else {
          emit(
            ErrorLoadClientsListState(
              errorStateType: ErrorStateType.genericError,
            ),
          );
        }
      },
      (ClientsEntity data) {
        emit(LoadedClientsListState(clientsEntity: data));
      },
    );
  }
}
