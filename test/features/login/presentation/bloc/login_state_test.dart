import 'package:flutter_template/features/login/domain/entities/entities_export.dart';
import 'package:flutter_template/features/login/presentation/bloc/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginState', () {
    const tUser = UserLoginData(
      token: 'abc',
      userId: '123',
      name: 'User',
      email: 'test@email.com',
    );

    group('LoginInitialState', () {
      test('should not be equal due to identityHashCode', () {
        final state1 = LoginInitialState();
        final state2 = LoginInitialState();
        expect(state1, isNot(equals(state2)));
      });
    });

    group('RequestingLoginState', () {
      test('should not be equal due to identityHashCode', () {
        final state1 = RequestingLoginState();
        final state2 = RequestingLoginState();
        expect(state1, isNot(equals(state2)));
      });
    });

    group('RequestedLoginState', () {
      test('supports value equality', () {
        expect(
          const RequestedLoginState(user: tUser),
          equals(const RequestedLoginState(user: tUser)),
        );
      });
      
      test('props are correct', () {
        expect(
          const RequestedLoginState(user: tUser).props,
          equals([tUser]),
        );
      });
    });

    group('ErrorRequestLoginState', () {
      test('supports value equality', () {
        expect(
          const ErrorRequestLoginState(errorStateMessage: 'error'),
          equals(const ErrorRequestLoginState(errorStateMessage: 'error')),
        );
      });

      test('props are correct', () {
        expect(
          const ErrorRequestLoginState(errorStateMessage: 'error').props,
          equals(['error']),
        );
      });
    });
  });
}
