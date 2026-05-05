# Flutter Template Base

Este repositório é um **Template de Arquitetura** para aceleração e padronização no desenvolvimento de novos aplicativos Flutter. Além de um template funcional, este projeto serve como portfólio onde aplico as melhores práticas de Engenharia de Software focadas no desenvolvimento Mobile, orientadas a escalabilidade, manutenibilidade e modularidade.

## Tecnologias e Padrões Principais

- **Clean Architecture:** Separação estrita em camadas (Domain, Data, Presentation) com UseCases.
- **BLoC (Business Logic Component):** Gerenciamento de estado reativo e previsível.
- **Service Locator (get_it):** Injeção de dependência elegante e prática.
- **Functional Programming (dartz):** Tratamento de erros via Either eOption.
- **FVM (Flutter Version Manager):** Garantia de consistência da versão do Flutter.
- **Environment Configuration (.env):** Gerenciamento de variáveis sensíveis e chaveamento Prod/Dev.
- **Sistema Centralizado de Mocks:** Desenvolvimento offline sem dependência de APIs.
- **Integração com IA (Antigravity):** Regras de arquitetura e Workflows耦合 ao projeto.
- ** flutter_secure_storage:** Armazenamento seguro de dados sensíveis.
- **sqflite:** Banco de dados local SQLite.
- **Provider:**輔佐 ao BLoC para provider de estado global.
- **cached_network_image:** Cache de imagens para performance.

---

## Design do Sistema & Arquitetura

O projeto adota Clean Architecture com UseCases e Repository Pattern isolando regras de negócio do UI e pacotes externos. Cada funcionalidade é um módulo em `lib/features/`:

```text
lib/
 ├─ core/                      # Infraestrutura
 │   ├─ entities/              # Entidades genéricas (ApiResponse)
 │   ├─ enums/                 # Enums globais
 │   ├─ errors/                # Failures (ServerFailure, TimeoutFailure, SessionExpiredFailure)
 │   ├─ helpers/               # EnvironmentHelper, SessionHelper, MockHelper, SecureStorageHelper
 │   ├─ localization/         # i18n com Flutter ARB
 │   ├─ providers/            # LocaleProvider, ThemeProvider
 │   ├─ routes/               # Sistema de rotas centralizado
 │   ├─ services/             # ApiService, ApiRequest
 │   ├─ ui/constants/         # AppColors, AppThemes, AppStyles, ThemeExtensions
 │   ├─ usecases/              # UseCase base abstrato
 │   ├─ widgets/              # Componentes reuseáveis (LocaleSelector)
 │   └─ utils/                # SnackbarUtils, LoadUtils
 └─ features/
     └─ [feature]/
         ├─ domain/            # UseCases, Entities, Repositories
         ├─ data/             # Models, DataSources
         └─ presentation/    # BLoC, Pages, Widgets
```

### Padrões Implementados

- **Export Barrels (*_export.dart):** Organización de imports
- **UseCase Pattern:** Abstracts com método call e Either
- **Factory Constructors:**fromMap/fromJson nos Models
- **Repository Pattern:**Interface no domain, implementação no data
- **Error Handling:**Failure classes com Either
- **Dependency Injection:**get_it com registering de factories e singletons
- **Theme Engine Dinâmico:** Gerenciamento de temas (Light/Dark/System) utilizando `ThemeData`, `AppColors` e propriedades tipadas customizadas via `ThemeExtension` (`TextColors`, `BackgroundExtensionColors`) do Flutter.

---

## Configurações Iniciais e Instalação

### 1. Flutter Version Manager (FVM)

Este projeto utiliza FVM para travar a versão do SDK. Requer `fvm` instalado globalmente.

```bash
fvm install
fvm flutter pub get
```

### 2. Variáveis de Ambiente (.env)

Copie `.env.example` ou crie `.env`:

```text
BASE_URL=https://api.exemplo.com.br/v1
USE_MOCK=true
```

### 3. Firebase

Este projeto utiliza **Firebase Auth** e **Crashlytics**. Arquivos de configuração **não são commitados**.

Para configurar:
1. Crie projeto no [Console Firebase](https://console.firebase.google.com/)
2. Adicione apps Android/iOS com Package Names adequados
3. Baixe e place os arquivos:
   - **Android:** `android/app/google-services.json`
   - **iOS:** `ios/Runner/GoogleService-Info.plist`
4. Registre SHA-1 se usar Google Sign-In

---

## Sistema de Mocks (Desenvolvimento Offline)

O `MockHelper` intercepta requisições quando `USE_MOCK=true`:

- **Ativação:** `USE_MOCK=true` no `.env`
- **Como funciona:** DataSource checa `EnvironmentHelper.instance.useMock` e retorna dados do MockHelper
- **Como adicionar:** Adicione JSON na classe MockHelper associada ao endpoint

---

## Automação e IA (Agentes)

Projeto pré-configurado paraLLMs como **Deepmind Antigravity** e ferramentas Cursor/Cline.

- **.agents/rules/:** Guias de System Design, testes unitários, Doc comments
- **.agents/workflows/:** Rotinas automatizadas via slash commands:
  - `/check_dependencies` - Audita pubspec.yaml
  - `/flutter_clean_full` - Limpa metadados e pods
  - `/prepare_build_release` - Script de bump version
  - `/validate_requirements` - Reflexão contra over-engineering

---

Feito com extrema atenção aos detalhes para construção de projetos robustos. Bom desenvolvimento!