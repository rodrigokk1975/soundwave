# SoundWave

Aplicativo de streaming e reprodução de músicas desenvolvido em **Flutter** como projeto acadêmico para uma disciplina da faculdade, utilizando arquitetura em camadas com **BLoC**, injeção de dependências com **GetIt** e backend em **Firebase** (Authentication + Cloud Firestore).

## Funcionalidades

- **Autenticação completa**: cadastro, login, logout e exclusão de conta com reautenticação.
- **Reprodutor de música**: controle de play/pause, próxima música, música anterior e barra de progresso (seek).
- **Descoberta e Playlists**: listagem de lançamentos recentes e playlist principal ordenadas via Firestore.
- **Favoritos**: adicionar/remover músicas favoritas e visualizar lista dedicada no perfil.
- **Perfil do usuário**: visualização de dados e edição de nome, e-mail, senha e foto de perfil.
- **Tema dinâmico**: alternância entre modo claro e modo escuro com `TemaBloc`.

## Tecnologias e Arquitetura

- **Flutter / Dart** (`sdk: ^3.7.0`)
- **Gerenciamento de Estado**: `flutter_bloc` / `bloc`
- **Injeção de Dependências**: `get_it`
- **Tratamento Funcional de Erros**: `dartz` (`Either`)
- **Backend**: `firebase_core`, `firebase_auth`, `cloud_firestore`
- **Áudio e UI**: `audioplayers`, `flutter_svg`, `iconsax`, fonte customizada `Gabarito`

### Estrutura de Pastas

```text
lib/
├── camada_bloc/          # BLoCs, eventos e estados (Autenticação, Configurações, Música, Perfil)
├── camada_dados/
│   ├── dados/            # Models e data sources Firebase (Auth e Música)
│   └── dominio/          # Entidades e casos de uso (UseCases)
├── interface_grafica/
│   ├── componentes/      # AppBar, BottomAppBar, botões reutilizáveis
│   └── telas/            # Splash, Intro, Auth, Home, Player, Perfil e Configurações
├── nucleo/               # Service Locator, tema, assets e configuração do Firebase
└── main.dart
```

## Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.7.0`)
- Conta e projeto configurados no [Firebase Console](https://console.firebase.google.com/)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/) instalada globalmente

## Como Executar Localmente

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/rodrigokk1975/soundwave.git
   cd soundwave
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase:**
   Por segurança, `lib/nucleo/firebase_options.dart` não é versionado neste repositório. Gere o arquivo automaticamente com:
   ```bash
   flutterfire configure --out=lib/nucleo/firebase_options.dart
   ```
   Ou copie [`lib/nucleo/firebase_options.example.dart`](lib/nucleo/firebase_options.example.dart) para `lib/nucleo/firebase_options.dart` e preencha com as credenciais do seu projeto.

4. **Configure o Firebase Authentication e Cloud Firestore:**
   - Ative o provedor **E-mail/Senha** no Firebase Authentication.
   - Crie as coleções esperadas no Cloud Firestore:
     - `Songs`: documentos com `title` (String), `artist` (String), `duration` (number), `releaseDate` (Timestamp), `coverURL` (String) e `songURL` (String).
     - `profilePhoto`: documentos com `name` (String) e `imageURL` (String) para as opções de avatar.
     - `Users`: criada automaticamente no cadastro (com subcoleção `Favorites` contendo `{ songId }`).

5. **Execute o aplicativo:**
   ```bash
   flutter run
   ```

## Testes e Análise Estática

```bash
flutter analyze
flutter test
```

## Capturas de Tela

> Adicione aqui screenshots ou GIFs das principais telas (Splash, Login, Home, Player e Perfil) após publicar o repositório.

## Licença

Este projeto está licenciado sob a licença **MIT** — veja o arquivo [LICENSE](LICENSE) para mais detalhes.
