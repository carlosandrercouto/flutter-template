import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/enums/error_state_type_enum.dart';
import 'package:flutter_template/core/enums/login_error_type_enum.dart';
import 'package:flutter_template/core/errors/errors_export.dart';
import 'package:flutter_template/core/helpers/session_helper.dart';
import 'package:flutter_template/features/login/domain/entities/entities_export.dart';
import 'package:flutter_template/features/login/domain/repositories/login_repository.dart';
import 'package:flutter_template/features/login/presentation/bloc/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class _MockLoginRepository implements LoginRepository {
  Either<Failure?, UserLoginData>? result;

  @override
  Future<Either<Failure?, UserLoginData>> postRequestLogin({
    required String email,
    required String password,
  }) async =>
      result ?? const Left(null);
}

class _MockSessionHelper implements SessionHelper {
  UserLoginData? initializedData;

  @override
  void initUserLoginData({required UserLoginData userLoginData}) {
    initializedData = userLoginData;
  }

  // Getters de SessionHelper que o mock não usa nos testes,
  // mas devem estar presentes para satisfazer o contrato.
  @override
  UserLoginData get userLoginData => throw UnimplementedError();

  @override
  String get token => throw UnimplementedError();

  @override
  String get userId => throw UnimplementedError();

  @override
  String get userName => throw UnimplementedError();

  @override
  String get userEmail => throw UnimplementedError();

  @override
  bool get isAuthenticated => throw UnimplementedError();
}

// ---------------------------------------------------------------------------
// Constantes de teste
// ---------------------------------------------------------------------------

const _tUserLoginData = UserLoginData(
  token: 'abc',
  userId: '1',
  name: 'User',
  email: 'user@test.com',
);

const _tEmail = 'test@test.com';
const _tPassword = '123';

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  late _MockLoginRepository mockLoginRepository;
  late _MockSessionHelper mockSessionHelper;

  setUp(() {
    mockLoginRepository = _MockLoginRepository();
    mockSessionHelper = _MockSessionHelper();
  });

  group('LoginBloc', () {
    test('initial state should be LoginInitialState', () {
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
        mockLoginRepository.result = const Right(_tUserLoginData);
        return LoginBloc(
          loginRepository: mockLoginRepository,
          sessionHelper: mockSessionHelper,
        );
      },
      act: (bloc) =>
          bloc.add(const RequestLoginEvent(email: _tEmail, password: _tPassword)),
      expect: () => [
        isA<RequestingLoginState>(),
        isA<RequestedLoginState>().having(
          (s) => s.user,
          'user',
          _tUserLoginData,
        ),
      ],
      verify: (_) {
        expect(mockSessionHelper.initializedData?.token, 'abc');
        expect(mockSessionHelper.initializedData?.userId, '1');
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
      act: (bloc) =>
          bloc.add(const RequestLoginEvent(email: _tEmail, password: _tPassword)),
      expect: () => [
        isA<RequestingLoginState>(),
        isA<ErrorRequestLoginState>().having(
          (s) => s.errorStateMessage,
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
      act: (bloc) =>
          bloc.add(const RequestLoginEvent(email: _tEmail, password: _tPassword)),
      expect: () => [
        isA<RequestingLoginState>(),
        isA<ErrorRequestLoginState>().having(
          (s) => s.errorStateMessage,
          'message',
          ErrorStateType.sessionExpired.message,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [RequestingLoginState, ErrorRequestLoginState] on generic Left(null)',
      build: () {
        mockLoginRepository.result = const Left(null);
        return LoginBloc(
          loginRepository: mockLoginRepository,
          sessionHelper: mockSessionHelper,
        );
      },
      act: (bloc) =>
          bloc.add(const RequestLoginEvent(email: _tEmail, password: _tPassword)),
      expect: () => [
        isA<RequestingLoginState>(),
        isA<ErrorRequestLoginState>().having(
          (s) => s.errorStateMessage,
          'message',
          ErrorStateType.genericError.message,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [RequestingLoginState, ErrorRequestLoginState] '
      'when UserLoginData has a LoginErrorType error',
      build: () {
        mockLoginRepository.result = const Right(
          UserLoginData(
            token: '',
            userId: '',
            name: '',
            email: '',
            error: LoginErrorType.invalidUserOrPassword,
          ),
        );
        return LoginBloc(
          loginRepository: mockLoginRepository,
          sessionHelper: mockSessionHelper,
        );
      },
      act: (bloc) =>
          bloc.add(const RequestLoginEvent(email: _tEmail, password: _tPassword)),
      expect: () => [
        isA<RequestingLoginState>(),
        isA<ErrorRequestLoginState>().having(
          (s) => s.errorStateMessage,
          'message',
          LoginErrorType.invalidUserOrPassword.errorMessage,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [LoginInitialState] on ResetLoginEvent',
      build: () => LoginBloc(
        loginRepository: mockLoginRepository,
        sessionHelper: mockSessionHelper,
      ),
      act: (bloc) => bloc.add(const ResetLoginEvent()),
      expect: () => [isA<LoginInitialState>()],
    );
  });
}
