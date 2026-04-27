part of 'clients_bloc.dart';

abstract class ClientsEvent extends Equatable {
  const ClientsEvent();

  @override
  List<Object?> get props => [identityHashCode(this)];
}

class LoadClientsListEvent extends ClientsEvent {
  const LoadClientsListEvent();
}
