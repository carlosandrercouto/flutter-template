import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_template/core/enums/login_error_type_enum.dart';
import 'package:flutter_template/features/login/data/models/user_login_data_model.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Fakes de FirebaseAuth para isolar testes de model
// ---------------------------------------------------------------------------

class _FakeUser extends Fake implements User {
  final String _uid;
  final String? _displayName;
  final String? _email;

  _FakeUser({
    required String uid,
    String? displayName,
    String? email,
  })  : _uid = uid,
        _displayName = displayName,
        _email = email;

  @override
  String get uid => _uid;

  @override
  String? get displayName => _displayName;

  @override
  String? get email => _email;
}

class _FakeUserCredential extends Fake implements UserCredential {
  final User? _user;

  _FakeUserCredential({required User? user}) : _user = user;

  @override
  User? get user => _user;
}

// ---------------------------------------------------------------------------
// Testes
// ---------------------------------------------------------------------------

void main() {
  group('UserLoginDataModel', () {
    group('fromFirebase', () {
      test(
        'should map UserCredential and idToken correctly',
        () {
          final fakeCredential = _FakeUserCredential(
            user: _FakeUser(
              uid: 'uid-001',
              displayName: 'Test User',
              email: 'test@test.com',
            ),
          );

          final model = UserLoginDataModel.fromFirebase(
            userCredential: fakeCredential,
            idToken: 'jwt-token-abc',
          );

          expect(model.token, 'jwt-token-abc');
          expect(model.userId, 'uid-001');
          expect(model.name, 'Test User');
          expect(model.email, 'test@test.com');
          expect(model.error, isNull);
          expect(model.isAuthenticated, isTrue);
        },
      );

      test(
        'should use empty string as fallback for null displayName and email',
        () {
          final fakeCredential = _FakeUserCredential(
            user: _FakeUser(
              uid: 'uid-002',
              displayName: null,
              email: null,
            ),
          );

          final model = UserLoginDataModel.fromFirebase(
            userCredential: fakeCredential,
            idToken: 'jwt-token-xyz',
          );

          expect(model.name, '');
          expect(model.email, '');
          expect(model.token, 'jwt-token-xyz');
        },
      );
    });

    group('fromFirebaseError', () {
      test(
        'should map known Firebase error code to correct LoginErrorType',
        () {
          final model = UserLoginDataModel.fromFirebaseError(
            error: 'invalid-credential',
          );

          expect(model.error, LoginErrorType.invalidUserOrPassword);
          expect(model.token, '');
          expect(model.userId, '');
          expect(model.isAuthenticated, isFalse);
        },
      );

      test(
        'should map user-not-found to LoginErrorType.userNotFound',
        () {
          final model = UserLoginDataModel.fromFirebaseError(
            error: 'user-not-found',
          );

          expect(model.error, LoginErrorType.userNotFound);
        },
      );

      test(
        'should map user-disabled to LoginErrorType.inactiveUser',
        () {
          final model = UserLoginDataModel.fromFirebaseError(
            error: 'user-disabled',
          );

          expect(model.error, LoginErrorType.inactiveUser);
        },
      );

      test(
        'should fallback to LoginErrorType.genericError for unknown error codes',
        () {
          final model = UserLoginDataModel.fromFirebaseError(
            error: 'unknown-code',
          );

          expect(model.error, LoginErrorType.genericError);
        },
      );

      test(
        'should fallback to LoginErrorType.genericError when error is null',
        () {
          final model = UserLoginDataModel.fromFirebaseError(error: null);

          expect(model.error, isNull);
        },
      );
    });
  });
}
