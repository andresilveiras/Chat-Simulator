import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/conversation_service.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/dual_message_input.dart';

/// Tela de conversa com dois lados controlados manualmente
/// Segue as convenções de nomenclatura e boas práticas
class ChatScreen extends StatefulWidget {
  final Conversation conversation;

  const ChatScreen({
    super.key,
    required this.conversation,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();
  final ConversationService _conversationService = ConversationService();
  final List<Message> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  /// Carrega mensagens da conversa
  Future<void> _loadMessages() async {
    try {
      final messages = await _chatService.getMessages(widget.conversation.id);
      setState(() {
        _messages.clear();
        _messages.addAll(messages);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar mensagens: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Envia mensagem do lado direito (usuário)
  Future<void> _sendUserMessage(String text) async {
    if (text.trim().isEmpty) return;

    try {
      final message = await _chatService.sendUserMessage(widget.conversation.id, text);
      setState(() {
        _messages.add(message);
      });
      
      // Atualiza a conversa com a nova mensagem
      await _conversationService.updateLastMessage(widget.conversation.id, message.timestamp);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar mensagem: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Envia mensagem do lado esquerdo (outro lado)
  Future<void> _sendOtherSideMessage(String text) async {
    if (text.trim().isEmpty) return;

    try {
      final message = await _chatService.sendOtherSideMessage(widget.conversation.id, text);
      setState(() {
        _messages.add(message);
      });
      
      // Atualiza a conversa com a nova mensagem
      await _conversationService.updateLastMessage(widget.conversation.id, message.timestamp);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar mensagem: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Limpa todas as mensagens da conversa
  Future<void> _clearConversation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Conversa'),
        content: const Text('Tem certeza que deseja limpar todas as mensagens?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _chatService.clearConversation(widget.conversation.id);
        setState(() {
          _messages.clear();
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao limpar conversa: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.title),
        actions: [
          IconButton(
            onPressed: _clearConversation,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Limpar conversa',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Nenhuma mensagem ainda',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Use os botões abaixo para simular\nos dois lados da conversa',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[_messages.length - 1 - index];
                          return MessageBubble(message: message);
                        },
                      ),
          ),
          DualMessageInput(
            onSendUserMessage: _sendUserMessage,
            onSendOtherSideMessage: _sendOtherSideMessage,
          ),
        ],
      ),
    );
  }
}