import 'package:flutter_template/core/helpers/secure_storage_helper/secure_storage_helper.dart';
import 'package:flutter_template/core/helpers/session_helper.dart';
import 'package:flutter_template/features/login/domain/entities/user_login_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

// 1. Definição da Classe de Mock
// Esta classe estende 'Mock' (do pacote mocktail) e implementa a sua classe real.
// Isso diz ao Dart: "Crie um objeto que se pareça com o SecureStorageHelper,
// mas que eu possa controlar o que ele responde".
class MockSecureStorageHelper extends Mock implements SecureStorageHelper {}

void main() {
  // Variáveis que serão usadas nos testes
  late SessionHelper sessionHelper;
  late MockSecureStorageHelper mockSecureStorageHelper;
  final getIt = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(SecureStorageHelperKeys.userToken);
  });

  // O setUp roda antes de CADA teste individualmente
  setUp(() {
    // Limpa o GetIt para garantir que um teste não interfira no outro
    getIt.reset();

    // 2. Instanciamos o Mock que definimos lá no topo
    mockSecureStorageHelper = MockSecureStorageHelper();

    // 3. Registramos o Mock no GetIt
    // Quando o SessionHelper pedir um SecureStorageHelper, o GetIt entregará o Mock.
    getIt.registerSingleton<SecureStorageHelper>(mockSecureStorageHelper);

    // 4. Instanciamos a classe que queremos testar
    sessionHelper = SessionHelper();
  });

  test(
    'Deve salvar token e userId no SecureStorage quando initUserLoginData for chamado',
    () async {
      // ARRANGE (Preparação)
      final tUserLoginData = UserLoginData(
        token: 'meu_token_jwt',
        userId: '12345',
        name: 'Carlos Couto',
        email: 'carlos@email.com',
      );

      // Ensinamos ao Mock o que fazer quando saveData for chamado
      // Como saveData retorna um Future<void>, usamos .thenAnswer((_) async => {});
      when(
        () => mockSecureStorageHelper.saveData(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      // ACT (Ação)
      sessionHelper.initUserLoginData(userLoginData: tUserLoginData);

      // ASSERT (Verificação)
      // Verificamos se o SessionHelper realmente chamou o método de salvar o TOKEN
      verify(
        () => mockSecureStorageHelper.saveData(
          key: SecureStorageHelperKeys.userToken,
          value: 'meu_token_jwt',
        ),
      ).called(1);

      // Verificamos se ele também salvou o USER ID
      verify(
        () => mockSecureStorageHelper.saveData(
          key: SecureStorageHelperKeys.userId,
          value: '12345',
        ),
      ).called(1);

      // Garantimos que os dados na memória do SessionHelper estão corretos
      expect(sessionHelper.token, 'meu_token_jwt');
      expect(sessionHelper.userId, '12345');
    },
  );
}
