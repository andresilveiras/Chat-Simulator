import '../models/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

/// Serviço responsável pelas operações de conversas com persistência na nuvem
/// Segue as convenções de nomenclatura e boas práticas
class ConversationService {
  final List<Conversation> _mockConversations = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  /// Verifica se o usuário está autenticado e não é anônimo
  bool get _isAuthenticatedUser => 
      _authService.isAuthenticated && !_authService.currentUser!.isAnonymous;

  /// Obtém todas as conversas do usuário
  Future<List<Conversation>> getConversations() async {
    try {
      if (_isAuthenticatedUser) {
        // Busca conversas na nuvem
        final userId = _authService.currentUserId;
        final querySnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .orderBy('lastMessageAt', descending: true)
            .get();

        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          return Conversation(
            id: doc.id,
            title: data['title'] ?? '',
            imageUrl: data['imageUrl'],
            otherSideName: data['otherSideName'],
            createdAt: (data['createdAt'] as Timestamp).toDate(),
            lastMessageAt: (data['lastMessageAt'] as Timestamp).toDate(),
            messageCount: data['messageCount'] ?? 0,
          );
        }).toList();
      } else {
        // Busca conversas locais
        await Future.delayed(const Duration(milliseconds: 500));
        return List.from(_mockConversations);
      }
    } catch (e) {
      print('Erro ao buscar conversas: $e');
      return [];
    }
  }

  /// Cria uma nova conversa
  Future<Conversation> createConversation(String title, {String? imageUrl}) async {
    try {
      final conversation = Conversation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        lastMessageAt: DateTime.now(),
        messageCount: 0,
      );

      if (_isAuthenticatedUser) {
        // Salva na nuvem
        final userId = _authService.currentUserId;
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .doc(conversation.id)
            .set({
          'title': conversation.title,
          'imageUrl': conversation.imageUrl,
          'otherSideName': conversation.otherSideName,
          'createdAt': Timestamp.fromDate(conversation.createdAt),
          'lastMessageAt': Timestamp.fromDate(conversation.lastMessageAt),
          'messageCount': conversation.messageCount,
        });
      } else {
        // Salva localmente
        await Future.delayed(const Duration(milliseconds: 300));
        _mockConversations.add(conversation);
      }

      return conversation;
    } catch (e) {
      print('Erro ao criar conversa: $e');
      rethrow;
    }
  }

  /// Atualiza uma conversa existente
  Future<Conversation> updateConversation(Conversation conversation) async {
    try {
      if (_isAuthenticatedUser) {
        // Atualiza na nuvem
        final userId = _authService.currentUserId;
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .doc(conversation.id)
            .update({
          'title': conversation.title,
          'imageUrl': conversation.imageUrl,
          'otherSideName': conversation.otherSideName,
          'lastMessageAt': Timestamp.fromDate(conversation.lastMessageAt),
          'messageCount': conversation.messageCount,
        });
      } else {
        // Atualiza localmente
        await Future.delayed(const Duration(milliseconds: 200));
        final index = _mockConversations.indexWhere((c) => c.id == conversation.id);
        if (index != -1) {
          _mockConversations[index] = conversation;
        }
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
      if (_isAuthenticatedUser) {
        // Deleta da nuvem
        final userId = _authService.currentUserId;
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .doc(conversationId)
            .delete();
      } else {
        // Deleta localmente
        _mockConversations.removeWhere((c) => c.id == conversationId);
      }
    } catch (e) {
      print('Erro ao deletar conversa: $e');
      rethrow;
    }
  }

  /// Atualiza a última mensagem de uma conversa
  Future<void> updateLastMessage(String conversationId, DateTime timestamp) async {
    try {
      if (_isAuthenticatedUser) {
        // Atualiza na nuvem
        final userId = _authService.currentUserId;
        final conversationDoc = await _firestore
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .doc(conversationId)
            .get();

        if (conversationDoc.exists) {
          final currentCount = conversationDoc.data()?['messageCount'] ?? 0;
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('conversations')
              .doc(conversationId)
              .update({
            'lastMessageAt': Timestamp.fromDate(timestamp),
            'messageCount': currentCount + 1,
          });
        }
      } else {
        // Atualiza localmente
        final index = _mockConversations.indexWhere((c) => c.id == conversationId);
        if (index != -1) {
          final conversation = _mockConversations[index];
          _mockConversations[index] = conversation.copyWith(
            lastMessageAt: timestamp,
            messageCount: conversation.messageCount + 1,
          );
        }
      }
    } catch (e) {
      print('Erro ao atualizar última mensagem: $e');
    }
  }

  /// Atualiza o nome do outro lado de uma conversa
  Future<void> updateOtherSideName(String conversationId, String newName) async {
    try {
      if (_isAuthenticatedUser) {
        // Atualiza na nuvem
        final userId = _authService.currentUserId;
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .doc(conversationId)
            .update({
          'otherSideName': newName,
        });
      } else {
        // Atualiza localmente
        final index = _mockConversations.indexWhere((c) => c.id == conversationId);
        if (index != -1) {
          final conversation = _mockConversations[index];
          _mockConversations[index] = conversation.copyWith(otherSideName: newName);
        }
      }
    } catch (e) {
      print('Erro ao atualizar nome do outro lado: $e');
    }
  }

  /// Obtém uma conversa específica
  Future<Conversation?> getConversation(String conversationId) async {
    try {
      if (_isAuthenticatedUser) {
        // Busca na nuvem
        final userId = _authService.currentUserId;
        final doc = await _firestore
            .collection('users')
            .doc(userId)
            .collection('conversations')
            .doc(conversationId)
            .get();

        if (doc.exists) {
          final data = doc.data()!;
          return Conversation(
            id: doc.id,
            title: data['title'] ?? '',
            imageUrl: data['imageUrl'],
            otherSideName: data['otherSideName'],
            createdAt: (data['createdAt'] as Timestamp).toDate(),
            lastMessageAt: (data['lastMessageAt'] as Timestamp).toDate(),
            messageCount: data['messageCount'] ?? 0,
          );
        }
        return null;
      } else {
        // Busca localmente
        return _mockConversations.firstWhere(
          (c) => c.id == conversationId,
          orElse: () => throw Exception('Conversa não encontrada'),
        );
      }
    } catch (e) {
      print('Erro ao buscar conversa: $e');
      return null;
    }
  }
} 