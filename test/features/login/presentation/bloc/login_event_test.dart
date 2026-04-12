import 'package:flutter_template/features/login/presentation/bloc/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginEvent', () {
    group('RequestLoginEvent', () {
      test('supports value assignments correcty', () {
        const event = RequestLoginEvent(email: 'test@email.com', password: '123');
        expect(event.email, 'test@email.com');
        expect(event.password, '123');
      });
    });

    group('ResetLoginEvent', () {
      test('can be instantiated', () {
        const event = ResetLoginEvent();
        expect(event, isNotNull);
      });
    });
  });
}
