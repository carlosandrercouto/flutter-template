part of 'clients_bloc.dart';

/// Estado base da feature Clients.
abstract class ClientsState extends Equatable {
  @override
  List<Object?> get props => [identityHashCode(this)];
}

/// Estado inicial — antes de qualquer carregamento.
class ClientsInitialState extends ClientsState {}

// Relacionado ao evento LoadClientsListEvent
// =====================================================================================================================
class LoadingClientsListState extends ClientsState {}

class LoadedClientsListState extends ClientsState {
  LoadedClientsListState({required this.clientsEntity});

  final ClientsEntity clientsEntity;

  @override
  List<Object?> get props => [clientsEntity];
}

class ErrorLoadClientsListState extends ClientsState {
  ErrorLoadClientsListState({required this.errorStateType});

  final ErrorStateType errorStateType;

  @override
  List<Object?> get props => [errorStateType];
}
