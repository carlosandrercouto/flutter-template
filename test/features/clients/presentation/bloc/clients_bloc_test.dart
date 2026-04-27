import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/enums/error_state_type_enum.dart';
import 'package:flutter_template/core/errors/errors_export.dart';
import 'package:flutter_template/features/clients/domain/entities/clients_entity.dart';
import 'package:flutter_template/features/clients/domain/repositories/clients_repository.dart';
import 'package:flutter_template/features/clients/presentation/bloc/clients_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClientsRepository extends Mock implements ClientsRepository {}

void main() {
  late MockClientsRepository mockRepository;
  late ClientsBloc bloc;

  setUp(() {
    mockRepository = MockClientsRepository();
    bloc = ClientsBloc(clientsRepository: mockRepository);
  });

  tearDown(() {
    reset(mockRepository);
    bloc.close();
  });

  group('ClientsBloc', () {
    const tClientsEntity = ClientsEntity(
      clientsLength: 0,
      clientsList: [],
    );

    test('estado inicial deve ser ClientsInitialState', () {
      expect(bloc.state, isA<ClientsInitialState>());
    });

    blocTest<ClientsBloc, ClientsState>(
      'deve emitir [LoadingClientsListState, LoadedClientsListState] quando LoadClientsListEvent for chamado com sucesso',
      build: () {
        when(() => mockRepository.getClientsList())
            .thenAnswer((_) async => const Right(tClientsEntity));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadClientsListEvent()),
      expect: () => [
        isA<LoadingClientsListState>(),
        isA<LoadedClientsListState>(),
      ],
      verify: (bloc) {
        verify(() => mockRepository.getClientsList()).called(1);
        verifyNoMoreInteractions(mockRepository);
        
        final lastState = bloc.state as LoadedClientsListState;
        expect(lastState.clientsEntity, equals(tClientsEntity));
      },
    );

    blocTest<ClientsBloc, ClientsState>(
      'deve emitir [LoadingClientsListState, ErrorLoadClientsListState] com timeout quando repositorio retornar TimeoutFailure',
      build: () {
        when(() => mockRepository.getClientsList())
            .thenAnswer((_) async => Left(TimeoutFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadClientsListEvent()),
      expect: () => [
        isA<LoadingClientsListState>(),
        isA<ErrorLoadClientsListState>(),
      ],
      verify: (bloc) {
        verify(() => mockRepository.getClientsList()).called(1);
        
        final lastState = bloc.state as ErrorLoadClientsListState;
        expect(lastState.errorStateType, ErrorStateType.timeout);
      },
    );

    blocTest<ClientsBloc, ClientsState>(
      'deve emitir [LoadingClientsListState, ErrorLoadClientsListState] com sessionExpired quando repositorio retornar SessionExpiredFailure',
      build: () {
        when(() => mockRepository.getClientsList())
            .thenAnswer((_) async => Left(SessionExpiredFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadClientsListEvent()),
      expect: () => [
        isA<LoadingClientsListState>(),
        isA<ErrorLoadClientsListState>(),
      ],
      verify: (bloc) {
        verify(() => mockRepository.getClientsList()).called(1);
        
        final lastState = bloc.state as ErrorLoadClientsListState;
        expect(lastState.errorStateType, ErrorStateType.sessionExpired);
      },
    );

    blocTest<ClientsBloc, ClientsState>(
      'deve emitir [LoadingClientsListState, ErrorLoadClientsListState] com genericError quando repositorio retornar outra Failure',
      build: () {
        when(() => mockRepository.getClientsList())
            .thenAnswer((_) async => const Left(null)); // null acts as generic error
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadClientsListEvent()),
      expect: () => [
        isA<LoadingClientsListState>(),
        isA<ErrorLoadClientsListState>(),
      ],
      verify: (bloc) {
        verify(() => mockRepository.getClientsList()).called(1);
        
        final lastState = bloc.state as ErrorLoadClientsListState;
        expect(lastState.errorStateType, ErrorStateType.genericError);
      },
    );
  });
}
