---
trigger: always_on
---

# Regras Gerais do Projeto

## 1. Princípios Chave e Dart/Flutter
- **Código:** Escreva Dart conciso, técnico e declarativo. Use nomes descritivos com verbos auxiliares (ex: `isLoading`).
- **Idioma:** Português (Brasil) para documentação; Inglês para código.
- **Arquitetura:** Utilize **Clean Architecture** e **Bloc** para gerenciamento de estado.
- **Sintaxe:** Use `const` para widgets imutáveis e variáveis constantes, `arrow syntax` para métodos simples e vírgulas finais para formatação.

## 2. Padrões por Camada (Clean Architecture)

### Camada de Data
- **Padrão:** Siga a implementação de DataSources e Models conforme exemplos em `lib/features/withdraw/data/`.
- **Tratamento:** Use `try-catch` em DataSources, registre erros no `FirebaseCrashlytics` e use `log()` para debug.

### Camada de Domain
- **Padrão:** Siga Entities, Repositories e UseCases conforme exemplos em `lib/features/withdraw/domain/`.
- **Retorno:** Métodos de repository devem sempre retornar `Either<Failure?, T>`.

### Camada de Presentation (Bloc)
- **States:** Implemente estados de Loading, Error e Success. Use `identityHashCode(this)` na classe base para garantir unicidade.
- **Events:** Devem incluir propriedades nos `props` para comparação de igualdade.
- **Otimização:** Use `buildWhen` e `listenWhen`. Prefira `BlocBuilder` para UI e `BlocListener` para efeitos colaterais (navegação, diálogos).
- **Exports:** Somente as pastas `widgets`, `usecases`, `entities` e `models` devem ter arquivos de export nas features.

## 3. Serviços e Infraestrutura
- **ApiService:** Siga o padrão em `lib/core/services/api_service.dart`. Passe `devLog` e `currentStackTrace`.
- **Persistência:** Use `SharedPreferencesHelper` para dados gerais e `SecureStorageHelper` para sensíveis (tokens).
- **Conectividade:** Sempre valide com `ConnectivityHelper.isConnectionDown()` antes de chamadas de API.

## 4. UI e Estilo
- **Widgets:** Crie classes pequenas e privadas em vez de métodos `_build...`. Use `CustomButton` e `ProgressUtils`.
- **Estilo:** Use `AppStyles` (textos), `AppLocalizations` (strings/tradução) e extensões de tema para cores.
- **TextFields:** Sempre defina `textCapitalization`, `keyboardType` e `textInputAction`.
- **Imagens:** `AssetImage` para locais; `cached_network_image` com `errorBuilder` para remotas.

## 5. Tratamento de Erros e Navegação
- **Falhas Comuns:** Trate `TimeoutFailure`, `OfflineFailure` e `UserSessionFailure`.
- **Sessão Expirada:** Deslogue o usuário para `RoutesList.ExpiredSessionScreen`.
- **Feedback:** Use `StandardErrorUi` para erros de tela inteira e `UiUtils.showSnackBar...` para feedbacks rápidos.
- **Rotas:** Use o enum `RoutesList` e classes `Args` específicas para passar parâmetros.

## 6. Logs e Analytics
- **Analytics:** Use `AnalyticsHelper.instance.sendAnalyticsEvent()` com constantes de `AnalyticsEvents`.
- **Logs:** Registre erros críticos no Crashlytics com contexto detalhado (parâmetros, stacktrace).

## 7. Regras de Testes (Resumo)
*Para detalhes, consulte `unit_tests_rules.md`.*
- **Padrão:** Use AAA (Arrange, Act, Assert) e `Mocktail`.
- **UseCase:** Use o DataSource diretamente (injetando mocks nele) em vez de mockar o Repository.
- **Bloc:** Use `blocTest` com `verify:` para side effects. Configure mocks no `build:`.
- **Mocks:** Use `reset()` no `tearDown()`. Prefira helpers centrais em `test/core/helpers/`.
- **Fixtures:** Devem ser `static const Map<String, dynamic>` para Models e `static const Entity` para Entities. Nunca use JSON Strings.
- **Igualdade:** Use `HelpersTestUtils.testObjectEquality` para validar `Equatable` em entities/models.

## 8. Diversos
- **Linhas:** Máximo de 120 caracteres. Use vírgulas para quebra de linha em funções longas.
- **Git:** Nunca execute comandos git via terminal de agente.
- **Warnings:** Use `ignore_for_file` apenas quando estritamente necessário.

---
**Referências:** Siga as documentações oficiais de Flutter, Bloc e Firebase.