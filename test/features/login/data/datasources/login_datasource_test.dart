import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_template/core/enums/login_error_type_enum.dart';
import 'package:flutter_template/core/helpers/firebase_auth_helper.dart';
import 'package:flutter_template/features/login/data/datasources/login_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Fakes de FirebaseAuth
// ---------------------------------------------------------------------------

class _FakeUser extends Fake implements User {
  @override
  String get uid => 'fake-uid-123';

  @override
  String? get displayName => 'Fake User';

  @override
  String? get email => 'fake@test.com';

  @override
  Future<String?> getIdToken([bool forceRefresh = false]) async => 'fake-token';
}

class _FakeUserCredential extends Fake implements UserCredential {
  @override
  User? get user => _FakeUser();
}

// ---------------------------------------------------------------------------
// FakeFirebaseAuthHelper — subclasse via construtor protegido forTesting()
// ---------------------------------------------------------------------------

class _FakeFirebaseAuthHelper extends FirebaseAuthHelper {
  _FakeFirebaseAuthHelper({
    required this.credential,
    required this.idToken,
    this.throwError,
  }) : super.forTesting();

  final UserCredential? credential;
  final String? idToken;
  final FirebaseAuthException? throwError;

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
// Testes
// ---------------------------------------------------------------------------

void main() {
  group('LoginDatasource', () {
    test(
      'should return Right(UserLoginData) when Firebase returns a valid credential',
      () async {
        final authHelper = _FakeFirebaseAuthHelper(
          credential: _FakeUserCredential(),
          idToken: 'fake-token',
        );
        final datasource = LoginDatasource(authHelper: authHelper);

        final result = await datasource.postRequestLogin(
          email: 'fake@test.com',
          password: 'password123',
        );

        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Deveria ser Right'),
          (r) {
            expect(r.token, 'fake-token');
            expect(r.userId, 'fake-uid-123');
            expect(r.name, 'Fake User');
            expect(r.email, 'fake@test.com');
            expect(r.error, isNull);
            expect(r.isAuthenticated, isTrue);
          },
        );
      },
    );

    test(
      'should return Left(null) when idToken is null after login',
      () async {
        final authHelper = _FakeFirebaseAuthHelper(
          credential: _FakeUserCredential(),
          idToken: null,
        );
        final datasource = LoginDatasource(authHelper: authHelper);

        final result = await datasource.postRequestLogin(
          email: 'fake@test.com',
          password: 'password123',
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, isNull),
          (r) => fail('Deveria ser Left'),
        );
      },
    );

    test(
      'should return Right with invalid-credential error on FirebaseAuthException',
      () async {
        final authHelper = _FakeFirebaseAuthHelper(
          credential: null,
          idToken: null,
          throwError: FirebaseAuthException(code: 'invalid-credential'),
        );
        final datasource = LoginDatasource(authHelper: authHelper);

        final result = await datasource.postRequestLogin(
          email: 'fake@test.com',
          password: 'wrong-password',
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
      'should return Right with user-not-found error on FirebaseAuthException',
      () async {
        final authHelper = _FakeFirebaseAuthHelper(
          credential: null,
          idToken: null,
          throwError: FirebaseAuthException(code: 'user-not-found'),
        );
        final datasource = LoginDatasource(authHelper: authHelper);

        final result = await datasource.postRequestLogin(
          email: 'notfound@test.com',
          password: '123',
        );

        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Deveria ser Right'),
          (r) => expect(r.error, LoginErrorType.userNotFound),
        );
      },
    );

    test(
      'should return Right with user-disabled error on FirebaseAuthException',
      () async {
        final authHelper = _FakeFirebaseAuthHelper(
          credential: null,
          idToken: null,
          throwError: FirebaseAuthException(code: 'user-disabled'),
        );
        final datasource = LoginDatasource(authHelper: authHelper);

        final result = await datasource.postRequestLogin(
          email: 'disabled@test.com',
          password: '123',
        );

        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Deveria ser Right'),
          (r) => expect(r.error, LoginErrorType.inactiveUser),
        );
      },
    );

    test(
      'should return Left(null) on unexpected generic exception',
      () async {
        final authHelper = _UnexpectedErrorAuthHelper();
        final datasource = LoginDatasource(authHelper: authHelper);

        final result = await datasource.postRequestLogin(
          email: 'fake@test.com',
          password: '123',
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (l) => expect(l, isNull),
          (r) => fail('Deveria ser Left'),
        );
      },
    );
  });
}

/// Simula uma exceção genérica (não FirebaseAuthException) no [signInWithEmailAndPassword].
class _UnexpectedErrorAuthHelper extends FirebaseAuthHelper {
  _UnexpectedErrorAuthHelper() : super.forTesting();

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw Exception('Unexpected error');
  }

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => null;
}
