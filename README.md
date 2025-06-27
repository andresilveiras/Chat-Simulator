# Chat Simulator

Chat Simulator é um aplicativo Flutter que permite simular conversas entre dois lados controlados manualmente pelo usuário. O app usa Firebase para autenticação com Google e armazenamento em nuvem (Firestore), garantindo que suas conversas sejam salvas e sincronizadas entre dispositivos.

## 🎯 Funcionalidades

### ✅ **Autenticação e Segurança**
- Login com conta Google (preparado para implementação)
- Autenticação anônima para desenvolvimento
- Conversas privadas por usuário

### ✅ **Gerenciamento de Conversas**
- Tela de menu com lista de conversas (estilo WhatsApp/Telegram)
- Criação de novas conversas com título personalizado
- Exclusão de conversas
- Contador de mensagens por conversa

### ✅ **Simulação de Conversas**
- **Dois botões de envio**: um para cada lado da conversa
- Interface intuitiva com botões "Você" e "Outro Lado"
- Mensagens organizadas cronologicamente
- Limpeza de conversas

### ✅ **Armazenamento na Nuvem**
- Salvamento automático de mensagens no Firestore
- Sincronização entre dispositivos
- Backup automático das conversas

## 📱 Como Usar

### 1. **Login**
- Toque em "Entrar Anonimamente" para começar
- (Futuro: Login com Google para sincronização)

### 2. **Criar Conversa**
- Toque no botão "+" para criar nova conversa
- Digite o título da conversa (ex: "Conversa com João")
- Toque em "Criar"

### 3. **Simular Conversa**
- Use o campo de texto para digitar mensagens
- **Botão "Outro Lado"**: simula mensagem do outro participante
- **Botão "Você"**: simula sua mensagem
- As mensagens aparecem em lados opostos da tela

### 4. **Gerenciar Conversas**
- Toque em uma conversa para abrir
- Use o menu (3 pontos) para deletar conversas
- Use o botão de limpar para remover todas as mensagens

## 🏗️ Estrutura do Projeto

```
lib/
├── app.dart                    # Entry point com MaterialApp
├── main.dart                   # Inicialização e Firebase setup
├── core/
│   ├── firebase_options.dart   # Configurações do Firebase
│   └── themes.dart             # Temas claro/escuro
├── models/
│   ├── conversation.dart       # Modelo de conversas
│   └── message.dart            # Modelo de mensagens
├── screens/
│   ├── login_screen.dart       # Tela de login
│   ├── conversations_screen.dart # Menu de conversas
│   └── chat_screen.dart        # Tela de conversa
├── services/
│   ├── auth_service.dart       # Autenticação
│   ├── chat_service.dart       # Lógica de mensagens
│   └── conversation_service.dart # Gerenciamento de conversas
└── widgets/
    ├── conversation_tile.dart  # Item de conversa na lista
    ├── message_bubble.dart     # Bolha de mensagem
    └── dual_message_input.dart # Input com dois botões
```

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK 3.8.0+
- Android Studio / VS Code
- Dispositivo Android ou emulador

### Passos
1. **Clone o repositório**
   ```bash
   git clone [url-do-repositorio]
   cd Chat-Simulator
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o app**
   ```bash
   flutter run
   ```

## 🔥 Configuração do Firebase (Opcional)

Para habilitar o salvamento na nuvem:

1. **Crie projeto no Firebase Console**
   - Acesse [console.firebase.google.com](https://console.firebase.google.com)
   - Crie novo projeto

2. **Configure autenticação**
   - Vá em Authentication → Sign-in method
   - Habilite Google Sign-in

3. **Configure Firestore**
   - Vá em Firestore Database
   - Crie banco de dados em modo de teste

4. **Baixe configurações**
   - Adicione app Android com package: `com.andresilveiras.chatsimulator`
   - Baixe `google-services.json` e coloque em `android/app/`

5. **Configure o app**
   ```bash
   flutterfire configure
   ```

## 📋 Roadmap

- [ ] Login com Google
- [ ] Upload de imagens para conversas
- [ ] Exportação de conversas
- [ ] Temas personalizados
- [ ] Notificações push
- [ ] Compartilhamento de conversas

## 🤝 Contribuição

Siga as convenções de código definidas em `code_style_guide.md`:
- Nomenclatura: `snake_case` para arquivos, `UpperCamelCase` para classes
- Estrutura modular e bem documentada
- Testes unitários e de integração

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

---

**Desenvolvido com ❤️ usando Flutter e Firebase**
