import '../models/conversation.dart';

/// Serviço responsável pelas operações de conversas (versão mock para desenvolvimento)
/// Segue as convenções de nomenclatura e boas práticas
class ConversationService {
  final List<Conversation> _mockConversations = [];

  /// Obtém todas as conversas do usuário
  Future<List<Conversation>> getConversations() async {
    try {
      // Simula delay de rede
      await Future.delayed(const Duration(milliseconds: 500));
      return List.from(_mockConversations);
    } catch (e) {
      print('Erro ao buscar conversas: $e');
      return [];
    }
  }

  /// Cria uma nova conversa
  Future<Conversation> createConversation(String title, {String? imageUrl}) async {
    try {
      // Simula delay de rede
      await Future.delayed(const Duration(milliseconds: 300));

      final conversation = Conversation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        lastMessageAt: DateTime.now(),
        messageCount: 0,
      );

      _mockConversations.add(conversation);
      return conversation;
    } catch (e) {
      print('Erro ao criar conversa: $e');
      rethrow;
    }
  }

  /// Atualiza uma conversa existente
  Future<Conversation> updateConversation(Conversation conversation) async {
    try {
      // Simula delay de rede
      await Future.delayed(const Duration(milliseconds: 200));

      final index = _mockConversations.indexWhere((c) => c.id == conversation.id);
      if (index != -1) {
        _mockConversations[index] = conversation;
      }

      return conversation;
    } catch (e) {
      print('Erro ao atualizar conversa: $e');
      rethrow;
    }
  }

  /// Deleta uma conversa
  Future<void> deleteConversation(String conversationId) async {
    try {
      _mockConversations.removeWhere((c) => c.id == conversationId);
    } catch (e) {
      print('Erro ao deletar conversa: $e');
      rethrow;
    }
  }

  /// Atualiza a última mensagem de uma conversa
  Future<void> updateLastMessage(String conversationId, DateTime timestamp) async {
    try {
      final index = _mockConversations.indexWhere((c) => c.id == conversationId);
      if (index != -1) {
        final conversation = _mockConversations[index];
        _mockConversations[index] = conversation.copyWith(
          lastMessageAt: timestamp,
          messageCount: conversation.messageCount + 1,
        );
      }
    } catch (e) {
      print('Erro ao atualizar última mensagem: $e');
    }
  }
} 