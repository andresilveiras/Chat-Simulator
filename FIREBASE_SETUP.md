# Configuração do Firebase para Chat Simulator

## Configuração do Firestore

### 1. Estrutura de Dados

O app usa a seguinte estrutura no Firestore:

```
users/{userId}/
  conversations/{conversationId}/
    messages/{messageId}
```

### 2. Configuração do Firebase Storage (OPCIONAL - Versão Futura)

> **Nota**: Atualmente o app está funcionando apenas com Firestore. O Firebase Storage será configurado em uma versão futura.

#### 2.1 Ativar Firebase Storage (Quando necessário)

1. No console do Firebase, vá para **Storage**
2. Clique em **"Get started"**
3. Escolha **"Start in test mode"** (para desenvolvimento)
4. Selecione uma região (recomendado: `us-central1` ou `southamerica-east1`)

#### 2.2 Regras do Storage (Para versão futura)

No console do Firebase Storage, vá para **Rules** e configure:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Permitir upload de imagens de conversas para usuários autenticados
    match /conversation_images/{userId}/{conversationId}.{extension} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Negar acesso a todos os outros arquivos
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}
```

### 3. Versão Atual: Apenas Firestore

#### 3.1 Funcionalidade de Imagens (Temporária)

- ✅ **Recorte de imagem**: Funciona perfeitamente
- ✅ **Processamento**: Imagem é recortada e comprimida
- ⚠️ **Armazenamento**: Apenas metadados salvos no Firestore
- ⚠️ **Persistência**: Imagem não é salva na nuvem (apenas localmente)
- ⚠️ **Sincronização**: Imagens não sincronizam entre dispositivos

#### 3.2 Metadados Salvos no Firestore

Quando uma imagem é processada, são salvos os seguintes metadados:

```json
{
  "imageUrl": "local://{conversationId}_{timestamp}.jpg",
  "imageMetadata": {
    "fileName": "{conversationId}_{timestamp}.jpg",
    "timestamp": "2024-01-01T12:00:00.000Z",
    "size": 123456,
    "dimensions": "1:1 (quadrada)",
    "status": "local_only"
  }
}
```

### 4. Regras de Segurança

As regras do Firestore (`firestore.rules`) garantem que:
- Apenas usuários autenticados podem acessar seus dados
- Cada usuário só pode acessar suas próprias conversas e mensagens
- Usuários anônimos não salvam dados na nuvem (apenas localmente)

### 5. Como Aplicar as Regras

1. No console do Firebase, vá para Firestore Database
2. Clique na aba "Rules"
3. Cole o conteúdo do arquivo `firestore.rules`
4. Clique em "Publish"

### 6. Funcionalidades Implementadas

#### Para Usuários Logados:
- ✅ Conversas salvas na nuvem
- ✅ Mensagens persistentes
- ✅ Contador de mensagens atualizado
- ✅ Sincronização entre dispositivos
- ✅ Dados preservados após logout/login
- ✅ Edição de título das conversas
- ✅ Exclusão de conversas
- ✅ Processamento de imagens (recorte e compressão)
- ⚠️ Upload de imagens (versão temporária - apenas local)

#### Para Usuários Anônimos:
- ✅ Dados salvos localmente
- ✅ Funcionalidade completa sem persistência na nuvem
- ✅ Dados perdidos ao fechar o app
- ✅ Edição de título das conversas (local)
- ✅ Exclusão de conversas (local)
- ✅ Processamento de imagens (local)

### 7. Estrutura dos Documentos

#### Conversa:
```json
{
  "title": "Nome da conversa",
  "imageUrl": "local://{conversationId}_{timestamp}.jpg (opcional)",
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

### 8. Índices Necessários

O Firestore pode solicitar a criação de índices para consultas eficientes. Se necessário, crie os seguintes índices:

**Collection:** `users/{userId}/conversations`
- **Fields:** `lastMessageAt` (Descending)

**Collection:** `users/{userId}/conversations/{conversationId}/messages`
- **Fields:** `timestamp` (Ascending)

### 9. Testando a Funcionalidade

1. Faça login com uma conta (Google ou email)
2. Crie uma conversa
3. Envie algumas mensagens
4. Volte para a lista de conversas
5. Verifique se a contagem de mensagens está correta
6. Entre na conversa novamente - as mensagens devem estar lá
7. Teste em outro dispositivo com a mesma conta
8. **Teste a edição de título**: toque no ícone ✏️ ao lado da conversa
9. **Teste a exclusão**: toque no ícone 🗑️ ao lado da conversa
10. **Teste processamento de imagem**: toque no ícone 📷 ao lado da conversa

### 10. Funcionalidades da Interface

#### Lista de Conversas:
- **Toque na conversa**: Abre o chat
- **Ícone ✏️**: Edita o título da conversa
- **Ícone 🗑️**: Exclui a conversa
- **Ícone 📷**: Processa imagem da conversa (versão temporária)
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

### 11. Solução de Problemas

**Erro de permissão:** Verifique se as regras do Firestore estão aplicadas corretamente.

**Dados não aparecem:** Verifique se o usuário está autenticado e não é anônimo.

**Contador não atualiza:** Verifique se a função `updateLastMessage` está sendo chamada após enviar mensagens.

**Título não atualiza:** Verifique se o método `updateConversation` está sendo chamado corretamente.

**Processamento de imagem falha:** 
1. Verifique se o usuário está autenticado
2. Verifique se há permissão para acessar a galeria
3. Verifique se há espaço suficiente no dispositivo
4. Verifique a conectividade com a internet

### 12. Próximos Passos (Versão Futura)

Quando o Firebase Storage for configurado:

1. **Ativar Firebase Storage** no console
2. **Configurar regras** de segurança
3. **Modificar código** para fazer upload real
4. **Testar sincronização** entre dispositivos
5. **Implementar cache** de imagens
6. **Adicionar compressão** inteligente
7. **Implementar fallback** para imagens não carregadas 