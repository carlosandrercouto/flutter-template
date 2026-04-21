---
trigger: always_on
---

# Regras de Documentação de Código

## 1. Princípios Gerais
- **Idioma:** Português (Brasil) para documentação; Inglês para código (classes, vars, etc).
- **Effective Dart:** Siga as [diretrizes oficiais](https://dart.dev/effective-dart/documentation).
- **Prioridade:** 1. APIs Públicas (Obrigatório) | 2. Lógicas Complexas | 3. Decisões de Arquitetura.
- **Evite:** Documentar código autoexplicativo, overrides simples ou getters/setters triviais.

## 2. Doc Comments (///)

### Formatação Essencial
- **Primeira linha:** Sumário curto que faz sentido sozinho.
- **Parágrafos:** Separados por uma linha em branco.
- **Identificadores:** Use colchetes `[Classe]` para referenciar símbolos do código.
- **Limite:** Mantenha linhas em até 80 caracteres.

### Estilo de Escrita
- **Métodos:** Use verbos na 3ª pessoa. *"Calcula o saldo..."*
- **Propriedades:** Use frases nominais. *"O saldo atual..."*
- **Booleanos:** Comece com "Whether". *"Whether o usuário está logado."*
- **Exceções:** Liste falhas ou erros possíveis na descrição.

```dart
/// Calcula o saldo disponível.
///
/// Retorna um [Either] com [Failure] ou [double].
Future<Either<Failure, double>> calculateBalance() async { ... }

/// Whether a conexão está ativa.
final bool isOnline;
```

## 3. Comentários Especiais
- **TODO(user):** Tarefas pendentes com autor e descrição.
- **FIXME:** Erros conhecidos que precisam de correção imediata.
- **ignore/ignore_for_file:** Use para suprimir avisos do linter quando necessário.

## 4. Padrões por Camada (Clean Architecture)

### Domain (Entities, Repositories, UseCases)
Documente o **propósito de negócio**, invariantes de estado e possíveis falhas de domínio.
```dart
/// Representa um saque no domínio.
/// [amount] deve ser sempre positivo.
class WithdrawEntity extends Equatable { ... }
```

### Data (Models, DataSources)
Foque em **detalhes técnicos**: conversões de API, persistência local e mapeamento de erros.
```dart
/// Datasource para operações de saque via API.
/// Mapeia erros HTTP para [Failure].
class WithdrawDataSource implements WithdrawRepository { ... }
```

### Presentation (Blocs, States, Widgets)
Descreva o **gerenciamento de estado**, eventos suportados e comportamento visual de componentes.
```dart
/// Gerencia o fluxo de saques da UI.
/// Emite [WithdrawLoadingState] durante a requisição.
class WithdrawBloc extends Bloc<WithdrawEvent, WithdrawState> { ... }
```

## 5. Logs e Debugging
- **Produção:** Use `dart:developer` `log()` com o parâmetro `name`. **Nunca use `print()`**.
- **Crashlytics:** Use `recordError` para exceções não tratadas com contexto útil.
- **Analytics:** Documente eventos e parâmetros enviados via `AnalyticsHelper`.

```dart
developer.log('Usuário carregado', name: 'UserDataSource', level: 800);

await FirebaseCrashlytics.instance.recordError(error, stack, reason: 'Falha no login');
```

## 6. Checklist de Qualidade
- [ ] Classe/Método público possui doc comment com sumário?
- [ ] Identificadores estão entre colchetes `[]`?
- [ ] Comentários inline explicam o "porquê" (lógica complexa)?
- [ ] TODOs seguem o formato `// TODO(username): descrição`?
- [ ] Logs nomeados e sem `print()`?
- [ ] Erros críticos registrados no Crashlytics?

---
**Nota:** Para regras de testes unitários, consulte `.cursor/rules/cursorrules-unit-tests.mdc`.