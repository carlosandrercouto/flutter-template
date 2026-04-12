import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/enums/error_state_type_enum.dart';
import 'package:flutter_template/core/errors/errors_export.dart';
import 'package:flutter_template/core/helpers/session_helper.dart';
import 'package:flutter_template/features/login/domain/entities/entities_export.dart';
import 'package:flutter_template/features/login/domain/repositories/login_repository.dart';
import 'package:flutter_template/features/login/presentation/bloc/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockLoginRepository implements LoginRepository {
  Either<Failure?, UserLoginData>? result;

  @override
  Future<Either<Failure?, UserLoginData>> postRequestLogin({
    required String email,
    required String password,
  }) async {
    return result ?? const Left(null);
  }
}

class MockSessionHelper implements SessionHelper {
  UserLoginData? initializedData;

  @override
  void initUserLoginData({required UserLoginData userLoginData}) {
    initializedData = userLoginData;
  }

  // A documentação do mock para testes que não implementam tudo corretamente exige métodos do mixin.
  // Vamos usar noSuchMethod caso existam outras dependências omitidas.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockLoginRepository mockLoginRepository;
  late MockSessionHelper mockSessionHelper;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    mockSessionHelper = MockSessionHelper();
  });

  group('LoginBloc', () {
    test('initial state is LoginInitialState', () {
      final bloc = LoginBloc(
        loginRepository: mockLoginRepository,
        sessionHelper: mockSessionHelper,
      );
      expect(bloc.state, isA<LoginInitialState>());
      bloc.close();
    });

    blocTest<LoginBloc, LoginState>(
      'should emit [RequestingLoginState, RequestedLoginState] on success',
      build: () {
        mockLoginRepository.result = const Right(UserLoginData(
          token: 'abc',
          userId: '1',
          name: 'User',
          email: 'user@test.com',
        ));
        return LoginBloc(
          loginRepository: mockLoginRepository,
          sessionHelper: mockSessionHelper,
        );
      },
      act: (bloc) => bloc.add(const RequestLoginEvent(email: 'test', password: '123')),
      expect: () => [
        isA<RequestingLoginState>(),
        isA<RequestedLoginState>().having(
          (state) => state.user,
          'user',
          const UserLoginData(
            token: 'abc',
            userId: '1',
            name: 'User',
            email: 'user@test.com',
          ),
        ),
      ],
      verify: (_) {
        expect(mockSessionHelper.initializedData?.token, 'abc');
      },
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [RequestingLoginState, ErrorRequestLoginState] on TimeoutFailure',
      build: () {
        mockLoginRepository.result = Left(TimeoutFailure());
        return LoginBloc(
          loginRepository: mockLoginRepository,
          sessionHelper: mockSessionHelper,
        );
      },
      act: (bloc) => bloc.add(const RequestLoginEvent(email: 'test', password: '123')),
      expect: () => [
        isA<RequestingLoginState>(),
        isA<ErrorRequestLoginState>().having(
          (state) => state.errorStateMessage,
          'message',
          ErrorStateType.timeout.message,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [RequestingLoginState, ErrorRequestLoginState] on SessionExpiredFailure',
      build: () {
        mockLoginRepository.result = Left(SessionExpiredFailure());
        return LoginBloc(
          loginRepository: mockLoginRepository,
          sessionHelper: mockSessionHelper,
        );
      },
      act: (bloc) => bloc.add(const RequestLoginEvent(email: 'test', password: '123')),
      expect: () => [
        isA<RequestingLoginState>(),
        isA<ErrorRequestLoginState>().having(
          (state) => state.errorStateMessage,
          'message',
          ErrorStateType.sessionExpired.message,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [RequestingLoginState, ErrorRequestLoginState] on generic failure',
      build: () {
        mockLoginRepository.result = const Left(null);
        return LoginBloc(
          loginRepository: mockLoginRepository,
          sessionHelper: mockSessionHelper,
        );
      },
      act: (bloc) => bloc.add(const RequestLoginEvent(email: 'test', password: '123')),
      expect: () => [
        isA<RequestingLoginState>(),
        isA<ErrorRequestLoginState>().having(
          (state) => state.errorStateMessage,
          'message',
          ErrorStateType.genericError.message,
        ),
      ],
    );
  });
}
