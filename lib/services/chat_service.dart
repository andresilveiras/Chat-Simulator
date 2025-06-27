import '../models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

/// Serviço responsável pelas operações de chat com persistência na nuvem
/// Segue as convenções de nomenclatura e boas práticas
class ChatService {
  final Map<String, List<Message>> _mockMessages = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  /// Verifica se o usuário está autenticado e não é anônimo
  bool get _isAuthenticatedUser => 
      _authService.isAuthenticated && !_authService.currentUser!.isAnonymous;

  /// Obtém todas as mensagens de uma conversa específica
  Future<List<Message>> getMessages(String conversationId) async {
    try {
      if (_isAuthenticatedUser) {
        // Busca mensagens na nuvem
        final userId = _authService.currentUserId;
        final querySnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .get();

        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          return Message(
            id: doc.id,
            conversationId: conversationId,
            text: data['text'] ?? '',
            userId: data['userId'] ?? '',
            userName: data['userName'] ?? '',
            timestamp: (data['timestamp'] as Timestamp).toDate(),
            isFromUser: data['isFromUser'] ?? false,
          );
        }).toList();
      } else {
        // Busca mensagens locais
        await Future.delayed(const Duration(milliseconds: 500));
        return List.from(_mockMessages[conversationId] ?? []);
      }
    } catch (e) {
      print('Erro ao buscar mensagens: $e');
      return [];
    }
  }

  /// Envia uma nova mensagem do lado direito (usuário)
  Future<Message> sendUserMessage(String conversationId, String text) async {
    try {
      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: conversationId,
        text: text.trim(),
        userId: _authService.currentUserId.isNotEmpty 
            ? _authService.currentUserId 
            : 'user_123',
        userName: 'Você',
        timestamp: DateTime.now(),
        isFromUser: true,
      );

      if (_isAuthenticatedUser) {
        // Salva na nuvem
        final userId = _authService.currentUserId;
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .doc(message.id)
            .set({
          'text': message.text,
          'userId': message.userId,
          'userName': message.userName,
          'timestamp': Timestamp.fromDate(message.timestamp),
          'isFromUser': message.isFromUser,
        });
      } else {
        // Salva localmente
        await Future.delayed(const Duration(milliseconds: 300));
        _addMessageToConversation(conversationId, message);
      }

      return message;
    } catch (e) {
      print('Erro ao enviar mensagem do usuário: $e');
      rethrow;
    }
  }

  /// Envia uma nova mensagem do lado esquerdo (outro lado)
  Future<Message> sendOtherSideMessage(String conversationId, String text) async {
    try {
      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: conversationId,
        text: text.trim(),
        userId: 'other_side',
        userName: 'Outro Lado',
        timestamp: DateTime.now(),
        isFromUser: false,
      );

      if (_isAuthenticatedUser) {
        // Salva na nuvem
        final userId = _authService.currentUserId;
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .doc(message.id)
            .set({
          'text': message.text,
          'userId': message.userId,
          'userName': message.userName,
          'timestamp': Timestamp.fromDate(message.timestamp),
          'isFromUser': message.isFromUser,
        });
      } else {
        // Salva localmente
        await Future.delayed(const Duration(milliseconds: 300));
        _addMessageToConversation(conversationId, message);
      }

      return message;
    } catch (e) {
      print('Erro ao enviar mensagem do outro lado: $e');
      rethrow;
    }
  }

  /// Adiciona uma mensagem à conversa (apenas para dados locais)
  void _addMessageToConversation(String conversationId, Message message) {
    if (!_mockMessages.containsKey(conversationId)) {
      _mockMessages[conversationId] = [];
    }
    _mockMessages[conversationId]!.add(message);
  }

  /// Deleta uma mensagem específica
  Future<void> deleteMessage(String conversationId, String messageId) async {
    try {
      if (_isAuthenticatedUser) {
        // Deleta da nuvem
        final userId = _authService.currentUserId;
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .doc(messageId)
            .delete();
      } else {
        // Deleta localmente
        final messages = _mockMessages[conversationId];
        if (messages != null) {
          messages.removeWhere((message) => message.id == messageId);
        }
      }
    } catch (e) {
      print('Erro ao deletar mensagem: $e');
      rethrow;
    }
  }

  /// Limpa todas as mensagens de uma conversa
  Future<void> clearConversation(String conversationId) async {
    try {
      if (_isAuthenticatedUser) {
        // Limpa na nuvem
        final userId = _authService.currentUserId;
        final messagesSnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .get();

        final batch = _firestore.batch();
        for (final doc in messagesSnapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      } else {
        // Limpa localmente
        _mockMessages[conversationId]?.clear();
      }
    } catch (e) {
      print('Erro ao limpar conversa: $e');
      rethrow;
    }
  }

  /// Obtém o número de mensagens de uma conversa
  Future<int> getMessageCount(String conversationId) async {
    try {
      if (_isAuthenticatedUser) {
        // Conta na nuvem
        final userId = _authService.currentUserId;
        final querySnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .count()
            .get();
        return querySnapshot.count ?? 0;
      } else {
        // Conta localmente
        return _mockMessages[conversationId]?.length ?? 0;
      }
    } catch (e) {
      print('Erro ao contar mensagens: $e');
      return 0;
    }
  }
}