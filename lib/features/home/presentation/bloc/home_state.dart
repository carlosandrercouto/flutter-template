part of 'home_bloc.dart';

/// Estado base da feature Home.
abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [identityHashCode(this)];
}

/// Estado inicial — antes de qualquer carregamento.
class HomeInitialState extends HomeState {}

// Relacionado ao evento LoadHomeTransactionsEvent
// =====================================================================================================================
class LoadingHomeTransactionsState extends HomeState {}

class LoadedHomeTranactionsState extends HomeState {
  LoadedHomeTranactionsState({required this.homeData});

  final HomeDataEntity homeData;

  @override
  List<Object?> get props => [homeData];
}

class ErrorLoadHomeTransactionsState extends HomeState {
  ErrorLoadHomeTransactionsState({required this.errorStateType});

  final ErrorStateType errorStateType;

  @override
  List<Object?> get props => [errorStateType];
}
