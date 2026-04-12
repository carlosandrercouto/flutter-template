import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/error_state_type_enum.dart';
import '../../../../core/errors/errors_export.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/datasources/home_datasource.dart';
import '../../domain/entities/entities_export.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/usecases_export.dart';

part 'home_event.dart';
part 'home_state.dart';

/// BLoC responsável pelo gerenciamento de estado da Home.
///
/// Orquestra o carregamento das transações e expõe os estados
/// correspondentes para a camada de apresentação.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({HomeRepository? homeRepository})
    : _homeRepository = homeRepository ?? HomeDatasource(),
      super(HomeInitialState()) {
    on<LoadHomeTransactionsEvent>(_onLoadHomeTransactions);
  }

  /// Carrega os dados da tela Home.
  Future<void> _onLoadHomeTransactions(
    LoadHomeTransactionsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(LoadingHomeTransactionsState());

    /// TODO: Adicionar verificação de device offline

    final getHomeTransactionDataUseCase = GetHomeTransactionDataUseCase(
      repository: _homeRepository,
    );
    final getHomeTransactionData = await getHomeTransactionDataUseCase(
      NoParams(),
    );

    getHomeTransactionData.fold(
      (failure) {
        if (failure is TimeoutFailure) {
          emit(
            ErrorLoadHomeTransactionsState(
              errorStateType: ErrorStateType.timeout,
            ),
          );
        } else if (failure is SessionExpiredFailure) {
          emit(
            ErrorLoadHomeTransactionsState(
              errorStateType: ErrorStateType.sessionExpired,
            ),
          );
        } else {
          emit(
            ErrorLoadHomeTransactionsState(
              errorStateType: ErrorStateType.genericError,
            ),
          );
        }
      },
      (HomeDataEntity data) {
        emit(LoadedHomeTranactionsState(homeData: data));
      },
    );
  }
}
