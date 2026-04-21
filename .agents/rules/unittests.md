---
trigger: always_on
---

# Regras de Testes Unitários

## 1. Princípios de Escrita
- **Idioma:** Títulos em Inglês (ex: *"should return user..."*); Doc comments em Português para helpers/fixtures.
- **AAA (Arrange, Act, Assert):** Estrutura obrigatória para clareza.
- **Matchers:** Use específicos (`isTrue`, `isNull`, `isEmpty`, `isA<T>`) em vez de `equals()`.
- **Match de Blocs:** Use sempre `blocTest` com a seção `verify:` para side effects.

## 2. Organização e Nomenclatura
- **Estrutura:** Espelhe a pasta `/lib` dentro de `/test`.
- **Sufixos:**
  - Arquivos: `_test.dart`, `_mock.dart`, `_fixture.dart`.
  - Classes: `MockClass`, `FakeClass`, `ClassFixture`.
  - Variáveis: `repositoryMock`, `validData`.
- **Limpeza:** Use `reset(mock)` no `tearDown()`, nunca no `setUp()`.

## 3. Padrões por Tipo de Teste

### UseCases
- **DataSource Direto:** Teste o UseCase usando a implementação real do DataSource (injetando mocks no DataSource), em vez de mockar o Repository.
- **Cenários Obrigatórios:** Sucesso, Erro Genérico, Offline, Timeout e Sessão Expirada.

### Blocs
- **Template:** Use `blocTest` com `seed` (se necessário), `build`, `act`, `expect` e `verify`.
- **Mocks:** Configure comportamentos no `build`, não no `setUp`.
- **Verificação:** Use `verify(...).called(n)` e `verifyNoMoreInteractions(mock)`.

### Models e Entities
- **Models:** Teste `fromApi` com dados válidos e inválidos.
- **Entities:** Use `HelpersTestUtils.testObjectEquality` para testar `Equatable` (props, ==, hashCode).
- **Equality em Blocs:** Use `isA<State>()` no `expect` e verifique propriedades no `verify`.

## 4. Fixtures e Mocks
- **Fixtures:** 
  - Retorne `Map<String, dynamic>` para dados de API (evite JSON Strings).
  - Use `static const` para instâncias estáticas.
  - Reutilize constantes para evitar duplicatas.
- **Mocks:**
  - Use `setupDefaults(mock)` estático para comportamentos comuns (ex: estar online).
  - Use métodos utilitários como `ApiServiceMock.createSuccessResponse()`.

## 5. Boas Práticas (Checklist)
- [ ] Títulos descritivos em Inglês Americano?
- [ ] Testou cenários de erro (offline, timeout, etc.)?
- [ ] Injetou mocks corretamente (DataSource em UseCase)?
- [ ] Usou `verifyNoMoreInteractions()` para garantir limpeza?
- [ ] Usou `isA<Type>()` em Blocs em vez de instâncias específicas?
- [ ] Fixtures são Maps e usam `static const`?
- [ ] `tearDown` possui os `reset()` necessários?

---
**Nota:** Este arquivo é complementar às [Regras de Documentação](documentation_rules.md).