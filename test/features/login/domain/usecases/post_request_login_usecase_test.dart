import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_template/core/enums/login_error_type_enum.dart';
import 'package:flutter_template/core/errors/failure.dart';
import 'package:flutter_template/core/helpers/firebase_auth_helper.dart';
import 'package:flutter_template/features/login/data/datasources/login_datasource.dart';
import 'package:flutter_template/features/login/domain/entities/user_login_data.dart';
import 'package:flutter_template/features/login/domain/usecases/post_request_login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeUser extends Fake implements User {
  @override
  String get uid => 'uid-001';

  @override
  String? get displayName => 'Test User';

  @override
  String? get email => 'test@test.com';
}

class _FakeUserCredential extends Fake implements UserCredential {
  @override
  User? get user => _FakeUser();
}

class _FakeAuthHelper extends FirebaseAuthHelper {
  _FakeAuthHelper({
    required this.credential,
    required this.idToken,
    this.throwError,
  }) : super.forTesting();

  final UserCredential? credential;
  final String? idToken;
  final Object? throwError;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (throwError != null) throw throwError!;
    return credential!;
  }

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => idToken;
}

// ---------------------------------------------------------------------------
// Helper para construir o usecase com datasource real + authHelper fake
// ---------------------------------------------------------------------------

PostRequestLoginUseCase _buildUseCase(FirebaseAuthHelper authHelper) {
  final datasource = LoginDatasource(authHelper: authHelper);
  return PostRequestLoginUseCase(repository: datasource);
}

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  group('PostRequestLoginUseCase', () {
    test(
      'should return Right(UserLoginData) when login succeeds',
      () async {
        final authHelper = _FakeAuthHelper(
          credential: _FakeUserCredential(),
          idToken: 'valid-token',
        );
        final usecase = _buildUseCase(authHelper);

        final result = await usecase(
          PostRequestLoginParams(
            email: 'test@test.com',
            password: 'password123',
          ),
        );

        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Deveria ser Right'),
          (r) {
            expect(r, isA<UserLoginData>());
            expect(r.token, 'valid-token');
            expect(r.isAuthenticated, isTrue);
            expect(r.error, isNull);
          },
        );
      },
    );

    test(
      'should return Right with error when FirebaseAuthException is thrown',
      () async {
        final authHelper = _FakeAuthHelper(
          credential: null,
          idToken: null,
          throwError: FirebaseAuthException(code: 'invalid-credential'),
        );
        final usecase = _buildUseCase(authHelper);

        final result = await usecase(
          PostRequestLoginParams(
            email: 'test@test.com',
            password: 'wrong',
          ),
        );

        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Deveria ser Right'),
          (r) {
            expect(r.error, LoginErrorType.invalidUserOrPassword);
            expect(r.isAuthenticated, isFalse);
          },
        );
      },
    );

    test(
      'should return Left(null) when idToken is null after login',
      () async {
        final authHelper = _FakeAuthHelper(
          credential: _FakeUserCredential(),
          idToken: null,
        );
        final usecase = _buildUseCase(authHelper);

        final result = await usecase(
          PostRequestLoginParams(
            email: 'test@test.com',
            password: 'password123',
          ),
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, isNull),
          (r) => fail('Deveria ser Left'),
        );
      },
    );

    test(
      'should return Left(null) on unexpected generic exception',
      () async {
        final authHelper = _FakeAuthHelper(
          credential: null,
          idToken: null,
          throwError: Exception('Unexpected'),
        );
        final usecase = _buildUseCase(authHelper);

        final result = await usecase(
          PostRequestLoginParams(email: 'test@test.com', password: '123'),
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (l) {
            expect(l, isNull);
            expect(l, isNot(isA<Failure>()));
          },
          (r) => fail('Deveria ser Left'),
        );
      },
    );
  });
}
