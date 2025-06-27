# Configuração do Firebase para Chat Simulator

## Configuração do Firestore

### 1. Estrutura de Dados

O app usa a seguinte estrutura no Firestore:

```
users/{userId}/
  conversations/{conversationId}/
    messages/{messageId}
```

### 2. Regras de Segurança

As regras do Firestore (`firestore.rules`) garantem que:
- Apenas usuários autenticados podem acessar seus dados
- Cada usuário só pode acessar suas próprias conversas e mensagens
- Usuários anônimos não salvam dados na nuvem (apenas localmente)

### 3. Como Aplicar as Regras

1. No console do Firebase, vá para Firestore Database
2. Clique na aba "Rules"
3. Cole o conteúdo do arquivo `firestore.rules`
4. Clique em "Publish"

### 4. Funcionalidades Implementadas

#### Para Usuários Logados:
- ✅ Conversas salvas na nuvem
- ✅ Mensagens persistentes
- ✅ Contador de mensagens atualizado
- ✅ Sincronização entre dispositivos
- ✅ Dados preservados após logout/login
- ✅ Edição de título das conversas
- ✅ Exclusão de conversas

#### Para Usuários Anônimos:
- ✅ Dados salvos localmente
- ✅ Funcionalidade completa sem persistência na nuvem
- ✅ Dados perdidos ao fechar o app
- ✅ Edição de título das conversas (local)
- ✅ Exclusão de conversas (local)

### 5. Estrutura dos Documentos

#### Conversa:
```json
{
  "title": "Nome da conversa",
  "imageUrl": "URL da imagem (opcional)",
  "otherSideName": "Nome do outro lado",
  "createdAt": "Timestamp",
  "lastMessageAt": "Timestamp",
  "messageCount": 0
}
```

#### Mensagem:
```json
{
  "text": "Conteúdo da mensagem",
  "userId": "ID do usuário",
  "userName": "Nome do usuário",
  "timestamp": "Timestamp",
  "isFromUser": true/false
}
```

### 6. Índices Necessários

O Firestore pode solicitar a criação de índices para consultas eficientes. Se necessário, crie os seguintes índices:

**Collection:** `users/{userId}/conversations`
- **Fields:** `lastMessageAt` (Descending)

**Collection:** `users/{userId}/conversations/{conversationId}/messages`
- **Fields:** `timestamp` (Ascending)

### 7. Testando a Funcionalidade

1. Faça login com uma conta (Google ou email)
2. Crie uma conversa
3. Envie algumas mensagens
4. Volte para a lista de conversas
5. Verifique se a contagem de mensagens está correta
6. Entre na conversa novamente - as mensagens devem estar lá
7. Teste em outro dispositivo com a mesma conta
8. **Teste a edição de título**: toque no ícone ✏️ ao lado da conversa
9. **Teste a exclusão**: toque no ícone 🗑️ ao lado da conversa

### 8. Funcionalidades da Interface

#### Lista de Conversas:
- **Toque na conversa**: Abre o chat
- **Ícone ✏️**: Edita o título da conversa
- **Ícone 🗑️**: Exclui a conversa
- **Botão ➕**: Cria nova conversa
- **Ícone 📊**: Ordena as conversas por diferentes critérios

#### Opções de Ordenação:
- **Mais Recentes**: Ordena por data da última mensagem (padrão)
- **Ordem Alfabética**: Ordena por título da conversa (A-Z)
- **Mais Antigas**: Ordena por data da última mensagem (mais antigas primeiro)
- **Mais Mensagens**: Ordena por quantidade de mensagens (maior para menor)
- **Menos Mensagens**: Ordena por quantidade de mensagens (menor para maior)

#### Chat:
- **Ícone 📝**: Edita o nome do outro lado
- **Ícone 🧹**: Limpa todas as mensagens
- **Botões de mensagem**: Envia mensagens dos dois lados

### 9. Solução de Problemas

**Erro de permissão:** Verifique se as regras do Firestore estão aplicadas corretamente.

**Dados não aparecem:** Verifique se o usuário está autenticado e não é anônimo.

**Contador não atualiza:** Verifique se a função `updateLastMessage` está sendo chamada após enviar mensagens.

**Título não atualiza:** Verifique se o método `updateConversation` está sendo chamado corretamente. 