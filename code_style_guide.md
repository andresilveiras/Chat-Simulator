# 📚 Padrões de Código e Boas Práticas - Chat Simulator (Flutter + Firebase)

Este documento define os padrões de código e boas práticas a serem seguidos durante o desenvolvimento do aplicativo **Chat Simulator**.

---

## 🔤 Nomenclatura

### Arquivos
- Use `snake_case` para nomes de arquivos: `login_screen.dart`, `auth_service.dart`

### Classes
- Use `UpperCamelCase`: `LoginScreen`, `AuthService`, `MessageModel`

### Variáveis e métodos
- Use `lowerCamelCase`: `sendMessage`, `userId`, `messageController`

### Constantes
- Use `UPPER_SNAKE_CASE`: `MAX_MESSAGE_LENGTH`

---

## 📁 Estrutura de Diretórios

```
lib/
├── app.dart                # Entry point com MaterialApp e rotas
├── main.dart               # Inicialização e Firebase setup
├── core/                   # Configurações e temas
├── models/                 # Modelos de dados
├── screens/                # Telas principais
├── services/               # Firebase/Auth lógica
├── widgets/                # Componentes reutilizáveis
└── routes/                 # (Opcional) Gerenciamento de rotas
```

---

## 📦 Boas Práticas Gerais

### Modularização
- Separe responsabilidades em arquivos distintos: lógica, UI, dados.
- Evite classes grandes. Quebre funcionalidades em partes reutilizáveis.

### Responsividade
- Utilize `MediaQuery`, `LayoutBuilder`, e widgets responsivos sempre que possível.

### Gerenciamento de estado
- Use `setState` com cautela. Para projetos maiores, considere `Provider` ou `Riverpod`.

### Comentários e documentação
- Comente trechos complexos.
- Use `///` para documentar classes e métodos públicos.

### Firebase
- Nunca exponha dados sensíveis ou lógica crítica no cliente.
- Sempre associe dados do Firestore a `uid` do usuário.
- Trate exceções como falhas de login, conexões ou permissões.

### Preferência por Emojis

- Sempre que possível, utilize **emojis** em botões, menus e ações visuais no lugar de ícones tradicionais.
- Emojis tornam a interface mais amigável, divertida e consistente com o estilo do app.
- Exemplos:
  - Use ✏️ para editar, 🗑️ para excluir, ➕ para adicionar, 📊 para ordenar, etc.
- Só utilize ícones tradicionais quando não houver emoji adequado ou quando for necessário para acessibilidade.

---

## 🧪 Testes

- Priorize testes de lógica (unitários) e integração com Firebase.
- Mantenha arquivos de teste espelhando a estrutura do `lib/`.

---

## ✅ Checklist para Pull Requests

- [ ] Código limpo e organizado
- [ ] Funções pequenas e com uma única responsabilidade
- [ ] Uso correto dos padrões de nomenclatura
- [ ] Sem `print` ou código de debug desnecessário
- [ ] Testado localmente em emulador ou dispositivo real

---

## 📌 Convenções de Estilo

- Máximo de 80–100 colunas por linha (ajustável ao time)
- Utilize o `flutter format .` para manter padronização automática
- Siga os lints do pacote `flutter_lints` no `analysis_options.yaml`

---

Feliz codificação! 🚀
