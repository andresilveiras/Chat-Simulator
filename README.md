# Chat Simulator

Chat Simulator é um aplicativo Flutter que permite simular conversas entre dois lados controlados manualmente pelo usuário. O app usa Firebase para autenticação, armazenamento em nuvem (Firestore) e upload de imagens (Storage), garantindo que suas conversas sejam salvas e sincronizadas entre dispositivos.

## 🔒 Configuração de Segurança

⚠️ **IMPORTANTE**: Este repositório não contém arquivos de configuração do Firebase por questões de segurança. Para usar o app, você precisa configurar seu próprio projeto Firebase:

1. **Configure o Firebase** (veja seção "🔥 Configuração do Firebase" abaixo)
2. **Copie os arquivos de exemplo**:
   ```bash
   cp android/app/google-services.json.example android/app/google-services.json
   cp lib/core/firebase_options.dart.example lib/core/firebase_options.dart
   ```
3. **Substitua os valores** nos arquivos copiados com suas configurações reais do Firebase

## 🎯 Funcionalidades

### ✅ **Autenticação e Segurança**
- **Login com Email e Senha** - Criação de conta e login tradicional
- **Login com Google** - Autenticação rápida com conta Google
- **Login Anônimo** - Para uso rápido sem criar conta
- **Recuperação de Senha** - Envio de email para redefinir senha
- Conversas privadas por usuário

### ✅ **Perfil do Usuário**
- **Edição de nome de exibição** - Personalize como seu nome aparece
- **Upload de foto de perfil** - Adicione sua foto pessoal
- **Salvamento na nuvem** - Perfil sincronizado entre dispositivos
- **Fallback local** - Funciona mesmo offline para usuários anônimos

### ✅ **Gerenciamento de Conversas**
- Tela de menu com lista de conversas (estilo WhatsApp/Telegram)
- Criação de novas conversas com título personalizado
- **Upload de imagens para conversas** - Adicione imagens personalizadas
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
- **Modal de opções** - Pressione e segure uma conversa para editar título, imagem ou excluir

### ✅ **Simulação de Conversas**
- **Dois botões de envio**: um para cada lado da conversa
- Interface intuitiva com botões "Você" e "Outro Lado"
- Mensagens organizadas cronologicamente
- **Exibição de perfil em tempo real** - Nome e foto atualizados automaticamente
- Limpeza de conversas
- Edição do nome do outro lado dentro do chat
- **Pressionar e segurar uma mensagem para editar (✏️) ou excluir (🗑️) usando menu com emojis**

### ✅ **Armazenamento na Nuvem**
- Salvamento automático de mensagens no Firestore
- **Upload de imagens no Firebase Storage** - Fotos de perfil e conversas
- **Sincronização de URLs** - Links das imagens salvos no Firestore
- Sincronização entre dispositivos
- Backup automático das conversas
- **Tratamento de erros** - Feedback visual para falhas no upload

## 📱 Como Usar

### 1. **Login**
- **Email/Senha**: Digite seu email e senha para criar conta ou fazer login
- **Google**: Toque em "Google" para login rápido
- **Anônimo**: Toque em "Anônimo" para uso sem conta
- **Recuperar Senha**: Use "Esqueci a senha" para receber email de recuperação

### 2. **Configurar Perfil**
- Toque no ícone de perfil (👤) no topo da tela
- Edite seu nome de exibição
- Toque na foto para adicionar/alterar sua foto de perfil
- As mudanças são salvas automaticamente na nuvem

### 3. **Criar Conversa**
- Toque no botão "+" para criar nova conversa
- Digite o título da conversa (ex: "Conversa com João")
- Toque em "Criar"

### 4. **Adicionar Imagem à Conversa**
- **Pressione e segure** uma conversa na lista
- Selecione "Editar imagem" no modal que aparece
- Escolha uma imagem da galeria
- Recorte a imagem no formato circular
- A imagem será salva na nuvem e sincronizada

### 5. **Classificar/Ordenar Conversas**
- Toque no ícone 📊 no topo da tela de conversas
- Escolha o critério de ordenação desejado (mais recentes, alfabética, etc.)
- O critério selecionado fica destacado e aparece um indicador acima da lista

### 6. **Gerenciar Conversas**
- **Pressione e segure** uma conversa para abrir o modal de opções:
  - ✏️ **Editar título**: Altere o nome da conversa
  - 🖼️ **Editar imagem**: Mude a imagem da conversa
  - 🗑️ **Excluir**: Remova a conversa permanentemente

### 7. **Simular Conversa**
- Use o campo de texto para digitar mensagens
- **Botão "Outro Lado"**: simula mensagem do outro participante
- **Botão "Você"**: simula sua mensagem
- As mensagens aparecem em lados opostos da tela
- **Seu nome e foto** são exibidos automaticamente nas suas mensagens

### 8. **Editar ou Excluir Mensagem**
- **Pressione e segure** uma mensagem na tela do chat
- Um menu com emojis será exibido:
  - ✏️ Editar: permite alterar o texto da mensagem
  - 🗑️ Excluir: remove apenas aquela mensagem

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
│   ├── chat_screen.dart        # Tela de conversa
│   └── profile_screen.dart     # Tela de perfil do usuário
├── services/
│   ├── auth_service.dart       # Autenticação Firebase (email/senha, Google, anônimo)
│   ├── chat_service.dart       # Lógica de mensagens
│   ├── conversation_service.dart # Gerenciamento de conversas
│   ├── profile_service.dart    # Gerenciamento de perfil
│   └── image_storage_service.dart # Upload de imagens no Storage
└── widgets/
    ├── conversation_tile.dart  # Item de conversa na lista
    ├── message_bubble.dart     # Bolha de mensagem
    ├── dual_message_input.dart # Input com dois botões
    └── custom_icon.dart        # Widget para emojis
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

Para habilitar o salvamento na nuvem e upload de imagens:

1. **Crie projeto no Firebase Console**
   - Acesse [console.firebase.google.com](https://console.firebase.google.com)
   - Crie novo projeto

2. **Configure autenticação**
   - Vá em Authentication → Sign-in method
   - Habilite **Email/Password** e **Google Sign-in**

3. **Configure Firestore**
   - Vá em Firestore Database
   - Crie banco de dados em modo de teste
   - Configure as regras de segurança (veja `firestore.rules`)

4. **Configure Storage**
   - Vá em Storage
   - Crie bucket de armazenamento
   - Configure as regras de segurança para permitir upload de imagens

5. **Baixe configurações**
   - Adicione app Android com package: `com.andresilveiras.chatsimulator`
   - Baixe `google-services.json` e coloque em `android/app/`

6. **Configure o app**
   ```bash
   flutterfire configure
   ```

### Regras de Segurança

**Firestore (`firestore.rules`):**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /conversations/{conversationId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
        
        match /messages/{messageId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
      }
      
      match /profile/{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

**Storage (Firebase Console):**
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profile_images/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /conversation_images/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}
```

## 📋 Roadmap

- [x] Login com Email/Senha
- [x] Login com Google
- [x] Login Anônimo
- [x] Recuperação de Senha
- [x] Edição de título direto na lista
- [x] Classificação/ordenação de conversas
- [x] Indicador visual de ordenação
- [x] Editar/excluir mensagem individual (menu com emojis)
- [x] **Upload de imagens para conversas**
- [x] **Upload de foto de perfil**
- [x] **Salvamento de URLs no Firestore**
- [x] **Modal de opções para conversas**
- [x] **Exibição de perfil em tempo real**
- [x] **Tratamento de erros de upload**
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
