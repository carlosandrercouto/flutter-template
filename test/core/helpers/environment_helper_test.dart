import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_template/core/helpers/environment_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDotEnv extends Mock implements DotEnv {}

void main() {
  late EnvironmentHelper environmentHelper;
  late MockDotEnv mockDotEnv;

  setUp(() {
    mockDotEnv = MockDotEnv();
    environmentHelper = EnvironmentHelper(dotEnv: mockDotEnv);
  });

  tearDown(() {
    reset(mockDotEnv);
  });

  test('should load env file and set variables correctly when init is called', () async {
    // Arrange
    when(() => mockDotEnv.load(fileName: any(named: 'fileName')))
        .thenAnswer((_) async {});
    when(() => mockDotEnv.maybeGet('API_BASE_URL', fallback: null))
        .thenReturn('https://api.dev.com');
    when(() => mockDotEnv.maybeGet('USE_MOCK', fallback: null))
        .thenReturn('true');

    // Act
    await environmentHelper.init();

    // Assert
    verify(() => mockDotEnv.load(fileName: '.env')).called(1);
    expect(environmentHelper.apiBaseUrl, 'https://api.dev.com');
    expect(environmentHelper.useMock, isTrue);
    expect(environmentHelper.isDevEnvironment, isTrue);
  });

  test('should throw Exception and handle it if env key is missing', () async {
    // Arrange
    when(() => mockDotEnv.load(fileName: any(named: 'fileName')))
        .thenAnswer((_) async {});
    when(() => mockDotEnv.maybeGet('API_BASE_URL', fallback: null))
        .thenReturn(null);
    when(() => mockDotEnv.maybeGet('USE_MOCK', fallback: null))
        .thenReturn('false');

    // Act
    await environmentHelper.init();

    // Assert
    verify(() => mockDotEnv.load(fileName: '.env')).called(1);
    // Since it catches the exception and logs it, it will return an empty string
    expect(environmentHelper.apiBaseUrl, '');
    expect(environmentHelper.useMock, isFalse);
  });
}
