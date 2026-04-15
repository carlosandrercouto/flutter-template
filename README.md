# 🚀 Flutter Template Base

Este repositório é um **Template Base de Arquitetura** para aceleração e padronização no desenvolvimento de novos aplicativos Flutter. Ele engloba as melhores práticas de Engenharia de Software focadas no desenvolvimento Mobile, orientadas a escalabilidade, manutenibilidade e modularidade.

## 🛠️ Tecnologias e Padrões Principais

* **Clean Architecture:** Separação estrita em camadas (Domain, Data, Presentation).
* **BLoC (Business Logic Component):** Gerenciamento de estado reativo e previsível.
* **FVM (Flutter Version Manager):** Garantia de consistência da versão do Flutter em toda a equipe.
* **Environment Configuration (`.env`):** Gerenciamento de variáveis sensíveis e chaveamento fácil entre Prod/Dev.
* **Sistema Centralizado de Mocks:** Arquitetura para dev-mode sem dependência de APIs em backend.
* **Integração Nativa com IA (Antigravity):** Regras de arquitetura e Workflows acoplados ao projeto.

---

## 🏗️ Design do Sistema & Arquitetura

O projeto adota os princípios de Clean Architecture, garantindo que as regras de negócio sejam isoladas do UI e de pacotes externos, respeitando a regra de dependência de fora para dentro. Cada funcionalidade é tratada como um módulo dentro da pasta `lib/features/`:

```text
lib/
 ├─ core/            # (Infraestrutura) Serviços base, clients HTTP, Helpers, injetores e Enums base.
 └─ features/
     └─ [feature]/
         ├─ domain/       # UseCases, Entities e Repositories (Regras de Negócio).
         ├─ data/         # Models e DataSources (Comunicação Externa e Parsing de dados).
         └─ presentation/ # Pages, Widgets e Bloc/States (Interface de Usuário).
```

### Regra do Factory Constructors nos Models
Os Models (`data/models/`) exigem construtores de classe factory nomeados (`fromMap`, `fromJson`), combinados com getters ou mapeamento de enums internamente. Isso evita construtores inchados e previne superposições com a Entidade.

---

## ⚙️ Configurações Iniciais e Instalação

### 1. Flutter Version Manager (FVM)
Este projeto utiliza FVM para travar a versão do SDK. É requisito ter o `fvm` instalado globalmente.

Instale as dependências com a versão correta do projeto vinculada na pasta `.fvm/`:
```bash
fvm install
fvm flutter pub get
```
*Dica para VSCode:* Garanta que o caminho do Flutter aponta para `.fvm/flutter_sdk` nas configurações da sua workspace.

### 2. Variáveis de Ambiente (`.env`)
Todo o chaveamento de URLs e Flags deve ser feito via variáveis de ambiente.

1. Na raiz do projeto, copie ou crie o arquivo `.env`:
```text
BASE_URL=https://api.exemplo.com.br/v1
USE_MOCK=true
```
2. A classe `EnvironmentHelper` (no core do app) carrega automaticamente este arquivo antes do `runApp()`.

### 3. Configuração do Firebase
Este projeto utiliza **Firebase Auth** e **Crashlytics**. Por motivos de segurança e boas práticas de CI/CD, os arquivos de configuração **não são commitados**.

Para configurar seu ambiente local:

1. Crie um projeto no [Console do Firebase](https://console.firebase.google.com/).
2. Adicione os aplicativos Android e iOS utilizando os Package Names / Bundle IDs adequados.
3. Baixe os arquivos de configuração e coloque-os nos seguintes diretórios:
    *   **Android:** `android/app/google-services.json`
    *   **iOS:** `ios/Runner/GoogleService-Info.plist`
4. (Somente iOS) Certifique-se de associar o arquivo ao projeto no Xcode.
5. Se for utilizar Google Sign-In, registre seu SHA-1 no console do Firebase.

---

## 🧪 Como funciona o Sistema de Mocks (Desenvolvimento Offline)

A arquitetura já possui um mecanismo avançado para simulação de respostas via API chamado **`MockHelper`**.

* **Ativação:** Modifique `USE_MOCK=true` no `.env`.
* **Como intercepta:** O seu `DataSource` pode checar a propriedade `EnvironmentHelper.instance.useMock`. Caso seja ativa, ele solicita os dados para a classe estática `MockHelper` que intercepta requisições baseadas no Enum `ApiEndpoints`.
* **Como adicionar novos Mocks:** Basta criar os dados brutos JSON na classe `MockHelper` e associá-los à URL de endpoint adequada. Nenhuma linha do seu UseCase ou Bloc precisa ser tocada!

---

## 🤖 Automação e IA (Antigravity e Agentes)

Esse projeto está pré-configurado para agir em conjunto com LLMs de code-gen como o **Deepmind Antigravity** e outras ferramentas baseadas no Cursor/Cline.

* **Regras de Arquitetura (`.agents/rules/`):** A IA lê inerentemente nossos guias de System Design, elaboração de testes unitários e criação de Doc comments. Não precisa pedir, os agentes já conhecem o padrão.
* **Workflows Interativos (`.agents/workflows/`):** Contêiner nativo para rodar rotinas automatizadas no prompt via Slash command (`/`):
  * `/check_dependencies` : Audita o `pubspec.yaml`.
  * `/flutter_clean_full` : Limpeza brutal de metadados e reinstalação de dependências nativas (Pods).
  * `/prepare_build_release` : Script guiado para bump release version.
  * `/validate_requirements` : Ferramenta de reflexão (prevenção de código Over-Engineered).

---

Feito com extrema atenção aos detalhes para a construção de projetos robustos. Bom desenvolvimento! ☕