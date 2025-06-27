import 'package:flutter_test/flutter_test.dart';
import 'package:chat_simulator/services/chat_service.dart';
import 'package:chat_simulator/services/conversation_service.dart';
import 'package:chat_simulator/models/conversation.dart';
import 'package:chat_simulator/models/message.dart';

void main() {
  group('Persistence Tests', () {
    late ChatService chatService;
    late ConversationService conversationService;

    setUp(() {
      chatService = ChatService();
      conversationService = ConversationService();
    });

    test('should create conversation and persist messages', () async {
      // Criar uma conversa
      final conversation = await conversationService.createConversation('Test Conversation');
      expect(conversation.title, 'Test Conversation');
      expect(conversation.messageCount, 0);

      // Enviar uma mensagem
      final message = await chatService.sendUserMessage(conversation.id, 'Hello World');
      expect(message.text, 'Hello World');
      expect(message.isFromUser, true);

      // Verificar se a mensagem foi persistida
      final messages = await chatService.getMessages(conversation.id);
      expect(messages.length, 1);
      expect(messages.first.text, 'Hello World');

      // Verificar contagem de mensagens
      final messageCount = await chatService.getMessageCount(conversation.id);
      expect(messageCount, 1);
    });

    test('should handle multiple messages correctly', () async {
      // Criar uma conversa
      final conversation = await conversationService.createConversation('Multi Message Test');

      // Enviar várias mensagens
      await chatService.sendUserMessage(conversation.id, 'Message 1');
      await chatService.sendOtherSideMessage(conversation.id, 'Message 2');
      await chatService.sendUserMessage(conversation.id, 'Message 3');

      // Verificar se todas as mensagens foram persistidas
      final messages = await chatService.getMessages(conversation.id);
      expect(messages.length, 3);
      expect(messages[0].text, 'Message 1');
      expect(messages[1].text, 'Message 2');
      expect(messages[2].text, 'Message 3');

      // Verificar contagem
      final messageCount = await chatService.getMessageCount(conversation.id);
      expect(messageCount, 3);
    });

    test('should clear conversation correctly', () async {
      // Criar uma conversa com mensagens
      final conversation = await conversationService.createConversation('Clear Test');
      await chatService.sendUserMessage(conversation.id, 'Test message');

      // Verificar que há mensagens
      var messages = await chatService.getMessages(conversation.id);
      expect(messages.length, 1);

      // Limpar conversa
      await chatService.clearConversation(conversation.id);

      // Verificar que não há mais mensagens
      messages = await chatService.getMessages(conversation.id);
      expect(messages.length, 0);

      // Verificar contagem
      final messageCount = await chatService.getMessageCount(conversation.id);
      expect(messageCount, 0);
    });

    test('should update conversation title correctly', () async {
      // Criar uma conversa
      final conversation = await conversationService.createConversation('Original Title');
      expect(conversation.title, 'Original Title');

      // Atualizar o título
      final updatedConversation = conversation.copyWith(title: 'Updated Title');
      final result = await conversationService.updateConversation(updatedConversation);
      expect(result.title, 'Updated Title');

      // Verificar se a atualização foi persistida
      final retrievedConversation = await conversationService.getConversation(conversation.id);
      expect(retrievedConversation?.title, 'Updated Title');
    });

    test('should sort conversations correctly', () async {
      // Criar conversas com diferentes títulos e datas
      final conversation1 = await conversationService.createConversation('Zebra');
      final conversation2 = await conversationService.createConversation('Alpha');
      final conversation3 = await conversationService.createConversation('Beta');

      // Enviar mensagens para alterar as datas
      await chatService.sendUserMessage(conversation1.id, 'Message 1');
      await Future.delayed(const Duration(milliseconds: 100));
      await chatService.sendUserMessage(conversation2.id, 'Message 2');
      await Future.delayed(const Duration(milliseconds: 100));
      await chatService.sendUserMessage(conversation3.id, 'Message 3');

      // Buscar conversas (já vem ordenadas por mais recentes)
      final conversations = await conversationService.getConversations();
      expect(conversations.length, greaterThanOrEqualTo(3));

      // Verificar se estão ordenadas por data (mais recentes primeiro)
      expect(conversations[0].lastMessageAt.isAfter(conversations[1].lastMessageAt), true);
      expect(conversations[1].lastMessageAt.isAfter(conversations[2].lastMessageAt), true);
    });
  });
} 