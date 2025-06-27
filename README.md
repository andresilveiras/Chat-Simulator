# Chat Simulator

Chat Simulator é um aplicativo Flutter que simula conversas entre dois lados controlados manualmente. O app usa Firebase para autenticação com Google e armazenamento em nuvem (Firestore).

## Funcionalidades
- Login com conta Google
- Simulação de conversa entre dois lados
- Salvamento de mensagens por usuário na nuvem (Firestore)

## Estrutura do Projeto
```
lib/
├── app.dart
├── core/
│   ├── firebase_options.dart
│   └── themes.dart
├── models/
│   └── message.dart
├── screens/
│   ├── chat_screen.dart
│   └── login_screen.dart
├── services/
│   ├── auth_service.dart
│   └── chat_service.dart
├── widgets/
│   ├── message_bubble.dart
│   └── message_input.dart
└── main.dart
```

## Como usar
1. Clone o repositório
2. Configure um projeto Firebase e baixe o arquivo `google-services.json`
3. Coloque o `google-services.json` na pasta `android/app`
4. Rode `flutter pub get`
5. Execute o app em um dispositivo
