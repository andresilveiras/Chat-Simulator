import '../models/message.dart';

/// Serviço responsável pelas operações de chat (versão mock para desenvolvimento)
/// Segue as convenções de nomenclatura e boas práticas
class ChatService {
  final Map<String, List<Message>> _mockMessages = {
    // Mapa vazio para não iniciar com mensagens de teste
  };

  /// Obtém todas as mensagens de uma conversa específica
  Future<List<Message>> getMessages(String conversationId) async {
    try {
      // Simula delay de rede
      await Future.delayed(const Duration(milliseconds: 500));
      return List.from(_mockMessages[conversationId] ?? []);
    } catch (e) {
      print('Erro ao buscar mensagens: $e');
      return [];
    }
  }

  /// Envia uma nova mensagem do lado direito (usuário)
  Future<Message> sendUserMessage(String conversationId, String text) async {
    try {
      // Simula delay de rede
      await Future.delayed(const Duration(milliseconds: 300));

      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: conversationId,
        text: text.trim(),
        userId: 'user_123',
        userName: 'Você',
        timestamp: DateTime.now(),
        isFromUser: true,
      );

      _addMessageToConversation(conversationId, message);
      return message;
    } catch (e) {
      print('Erro ao enviar mensagem do usuário: $e');
      rethrow;
    }
  }

  /// Envia uma nova mensagem do lado esquerdo (outro lado)
  Future<Message> sendOtherSideMessage(String conversationId, String text) async {
    try {
      // Simula delay de rede
      await Future.delayed(const Duration(milliseconds: 300));

      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: conversationId,
        text: text.trim(),
        userId: 'other_side',
        userName: 'Outro Lado',
        timestamp: DateTime.now(),
        isFromUser: false,
      );

      _addMessageToConversation(conversationId, message);
      return message;
    } catch (e) {
      print('Erro ao enviar mensagem do outro lado: $e');
      rethrow;
    }
  }

  /// Adiciona uma mensagem à conversa
  void _addMessageToConversation(String conversationId, Message message) {
    if (!_mockMessages.containsKey(conversationId)) {
      _mockMessages[conversationId] = [];
    }
    _mockMessages[conversationId]!.add(message);
  }

  /// Deleta uma mensagem específica
  Future<void> deleteMessage(String conversationId, String messageId) async {
    try {
      final messages = _mockMessages[conversationId];
      if (messages != null) {
        messages.removeWhere((message) => message.id == messageId);
      }
    } catch (e) {
      print('Erro ao deletar mensagem: $e');
      rethrow;
    }
  }

  /// Limpa todas as mensagens de uma conversa
  Future<void> clearConversation(String conversationId) async {
    try {
      _mockMessages[conversationId]?.clear();
    } catch (e) {
      print('Erro ao limpar conversa: $e');
      rethrow;
    }
  }
}