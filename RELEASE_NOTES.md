# Chat Simulator v1.0.0 - Primeira Versão

## 🎉 Lançamento Inicial

Esta é a primeira versão oficial do **Chat Simulator**, um app Flutter que permite simular conversas entre dois lados controlados manualmente pelo usuário. O app usa Firebase para autenticação, armazenamento em nuvem (Firestore) e upload de imagens (Storage), garantindo que suas conversas sejam salvas e sincronizadas entre dispositivos.

## ✨ Funcionalidades

### 🔐 Autenticação e Segurança
- **Login com Email e Senha** - Criação de conta e login tradicional
- **Login com Google** - Autenticação rápida com conta Google
- **Login Anônimo** - Para uso rápido sem criar conta
- **Recuperação de Senha** - Envio de email para redefinir senha
- Conversas privadas por usuário

### 👤 Perfil do Usuário
- **Edição de nome de exibição** - Personalize como seu nome aparece
- **Upload de foto de perfil** - Adicione sua foto pessoal
- **Salvamento na nuvem** - Perfil sincronizado entre dispositivos
- **Fallback local** - Funciona mesmo offline para usuários anônimos

### 💬 Gerenciamento de Conversas
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

### 💭 Simulação de Conversas
- **Dois botões de envio**: um para cada lado da conversa
- Interface intuitiva com botões "Você" e "Outro Lado"
- Mensagens organizadas cronologicamente
- **Exibição de perfil em tempo real** - Nome e foto atualizados automaticamente
- Limpeza de conversas
- Edição do nome do outro lado dentro do chat
- **Pressionar e segurar uma mensagem para editar (✏️) ou excluir (🗑️) usando menu com emojis**

### ☁️ Armazenamento na Nuvem
- Salvamento automático de mensagens no Firestore
- **Upload de imagens no Firebase Storage** - Fotos de perfil e conversas
- **Sincronização de URLs** - Links das imagens salvos no Firestore
- Sincronização entre dispositivos
- Backup automático das conversas
- **Tratamento de erros** - Feedback visual para falhas no upload

### 📱 Interface
- Design Material Design 3
- Tema escuro/claro
- Interface adaptativa para diferentes tamanhos de tela
- Animações suaves e transições
- **Modal de opções** com emojis para ações
- **Indicadores visuais** de ordenação e status

## 📋 Requisitos do Sistema

### Android
- Android 5.0 (API 21) ou superior
- 100MB de espaço livre
- Conexão com internet (para sincronização na nuvem)

### iOS
- iOS 13.0 ou superior
- iPhone/iPad compatível
- 100MB de espaço livre
- Conexão com internet (para sincronização na nuvem)

## 🚀 Como Instalar

### Android
1. Baixe o arquivo `ChatSimulator-v1.0.0-android.apk`
2. Ative "Fontes desconhecidas" nas configurações
3. Instale o APK
4. Abra o app e faça login

### iOS
1. Baixe o arquivo `ChatSimulator-v1.0.0-ios.app`
2. Use o Xcode ou AltStore para instalar
3. Confie no certificado de desenvolvedor
4. Abra o app e faça login

## 🔧 Tecnologias Utilizadas

- **Flutter** - Framework de desenvolvimento multiplataforma
- **Firebase Authentication** - Autenticação (email/senha, Google, anônimo)
- **Cloud Firestore** - Banco de dados em tempo real
- **Firebase Storage** - Armazenamento de imagens
- **Google Sign-In** - Autenticação social
- **Image Picker** - Seleção de imagens da galeria
- **Image Cropper** - Recorte de imagens

## 📝 Notas da Versão

- ✅ **Primeira versão estável** com todas as funcionalidades core
- ✅ **Sistema de autenticação completo** (email/senha, Google, anônimo)
- ✅ **Gerenciamento de conversas** com ordenação e classificação
- ✅ **Upload de imagens** para perfil e conversas
- ✅ **Simulação de chat** com dois lados controláveis
- ✅ **Edição e exclusão** de mensagens individuais
- ✅ **Sincronização na nuvem** com Firebase
- ✅ **Interface responsiva** e intuitiva
- ✅ **Tema adaptativo** (claro/escuro)

## 🐛 Problemas Conhecidos

- Nenhum problema crítico identificado
- App em fase de testes e validação
- Upload de imagens pode ser lento em conexões lentas

## 📞 Suporte

Para reportar bugs ou solicitar funcionalidades:
- Abra uma issue no GitHub: https://github.com/andresilveiras/Chat-Simulator/issues
- Entre em contato via email

## 🔄 Próximas Versões

### v1.1.0 (Planejado)
- [ ] Exportação de conversas (PDF, TXT)
- [ ] Temas personalizados
- [ ] Notificações push
- [ ] Compartilhamento de conversas
- [ ] Backup local offline

### v1.2.0 (Futuro)
- [ ] Grupos de chat
- [ ] Emojis e stickers
- [ ] Mensagens de voz
- [ ] Criptografia end-to-end
- [ ] Sincronização entre múltiplos dispositivos

### v1.3.0 (Longo Prazo)
- [ ] Videochamadas
- [ ] Modo colaborativo
- [ ] Integração com outros apps
- [ ] API pública para desenvolvedores

## 🔒 Segurança

- Todas as conversas são privadas por usuário
- Autenticação segura via Firebase
- Dados criptografados em trânsito
- Regras de segurança configuradas no Firestore e Storage

---

**Desenvolvido com ❤️ usando Flutter e Firebase** 