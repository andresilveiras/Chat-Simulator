# Chat Simulator

Chat Simulator é um aplicativo Flutter que permite simular conversas entre dois lados controlados manualmente pelo usuário. O app usa Firebase para autenticação e armazenamento em nuvem (Firestore), garantindo que suas conversas sejam salvas e sincronizadas entre dispositivos.

## 🎯 Funcionalidades

### ✅ **Autenticação e Segurança**
- **Login com Email e Senha** - Criação de conta e login tradicional
- **Login com Google** - Autenticação rápida com conta Google
- **Login Anônimo** - Para uso rápido sem criar conta
- **Recuperação de Senha** - Envio de email para redefinir senha
- Conversas privadas por usuário

### ✅ **Gerenciamento de Conversas**
- Tela de menu com lista de conversas (estilo WhatsApp/Telegram)
- Criação de novas conversas com título personalizado
- **Edição de título direto na lista de conversas**
- Exclusão de conversas
- Contador de mensagens por conversa
- **Classificação/ordenação de conversas** por:
  - Mais recentes
  - Ordem alfabética
  - Mais antigas
  - Mais mensagens
  - Menos mensagens
- **Dropdown de ordenação** com destaque visual para a opção selecionada
- **Indicador visual** mostrando o critério de ordenação atual

### ✅ **Simulação de Conversas**
- **Dois botões de envio**: um para cada lado da conversa
- Interface intuitiva com botões "Você" e "Outro Lado"
- Mensagens organizadas cronologicamente
- Limpeza de conversas
- Edição do nome do outro lado dentro do chat

### ✅ **Armazenamento na Nuvem**
- Salvamento automático de mensagens no Firestore
- Sincronização entre dispositivos
- Backup automático das conversas

## 📱 Como Usar

### 1. **Login**
- **Email/Senha**: Digite seu email e senha para criar conta ou fazer login
- **Google**: Toque em "Google" para login rápido
- **Anônimo**: Toque em "Anônimo" para uso sem conta
- **Recuperar Senha**: Use "Esqueci a senha" para receber email de recuperação

### 2. **Criar Conversa**
- Toque no botão "+" para criar nova conversa
- Digite o título da conversa (ex: "Conversa com João")
- Toque em "Criar"

### 3. **Classificar/Ordenar Conversas**
- Toque no ícone 📊 no topo da tela de conversas
- Escolha o critério de ordenação desejado (mais recentes, alfabética, etc.)
- O critério selecionado fica destacado e aparece um indicador acima da lista

### 4. **Editar Título da Conversa**
- Toque no ícone ✏️ ao lado do título da conversa na lista
- Digite o novo título e salve

### 5. **Simular Conversa**
- Use o campo de texto para digitar mensagens
- **Botão "Outro Lado"**: simula mensagem do outro participante
- **Botão "Você"**: simula sua mensagem
- As mensagens aparecem em lados opostos da tela

### 6. **Gerenciar Conversas**
- Toque em uma conversa para abrir
- Use o ícone 🗑️ para deletar conversas
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
│   ├── login_screen.dart       # Tela de login (email/senha, Google, anônimo)
│   ├── conversations_screen.dart # Menu de conversas
│   └── chat_screen.dart        # Tela de conversa
├── services/
│   ├── auth_service.dart       # Autenticação Firebase (email/senha, Google, anônimo)
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

## 🔥 Configuração do Firebase

Para habilitar o salvamento na nuvem:

1. **Crie projeto no Firebase Console**
   - Acesse [console.firebase.google.com](https://console.firebase.google.com)
   - Crie novo projeto

2. **Configure autenticação**
   - Vá em Authentication → Sign-in method
   - Habilite **Email/Password** e **Google Sign-in**

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

- [x] Login com Email/Senha
- [x] Login com Google
- [x] Login Anônimo
- [x] Recuperação de Senha
- [x] Edição de título direto na lista
- [x] Classificação/ordenação de conversas
- [x] Indicador visual de ordenação
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
