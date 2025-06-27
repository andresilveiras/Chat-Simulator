import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../services/chat_service.dart';
import '../services/conversation_service.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/dual_message_input.dart';
import '../widgets/custom_icon.dart';

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
  final ChatService _chatService = ChatService();
  final ConversationService _conversationService = ConversationService();
  final List<Message> _messages = [];
  bool _isLoading = true;
  String? _otherSideName;

  @override
  void initState() {
    super.initState();
    _otherSideName = widget.conversation.otherSideName ?? 'Outro Lado';
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

  /// Envia mensagem (unificado para ambos os lados)
  Future<void> _sendMessage(String text, bool isFromUser) async {
    if (text.trim().isEmpty) return;

    try {
      final message = isFromUser
          ? await _chatService.sendUserMessage(widget.conversation.id, text)
          : await _chatService.sendOtherSideMessage(widget.conversation.id, text);
      
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

  /// Envia mensagem do lado direito (usuário)
  Future<void> _sendUserMessage(String text) async {
    await _sendMessage(text, true);
  }

  /// Envia mensagem do lado esquerdo (outro lado)
  Future<void> _sendOtherSideMessage(String text) async {
    await _sendMessage(text, false);
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

  Future<void> _editOtherSideName() async {
    final controller = TextEditingController(text: _otherSideName);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar nome do outro lado'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nome do outro lado'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    if (newName != null && newName.isNotEmpty && newName != _otherSideName) {
      setState(() {
        _otherSideName = newName;
      });
      await _conversationService.updateOtherSideName(widget.conversation.id, newName);
    }
  }

  /// Edita uma mensagem específica
  Future<void> _editMessage(Message message) async {
    final controller = TextEditingController(text: message.text);
    final newText = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar mensagem'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Digite o novo texto'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    if (newText != null && newText.isNotEmpty && newText != message.text) {
      try {
        // Atualizar mensagem (apenas texto)
        await _chatService.updateMessage(widget.conversation.id, message.id, newText);
        setState(() {
          final idx = _messages.indexWhere((m) => m.id == message.id);
          if (idx != -1) {
            _messages[idx] = Message(
              id: message.id,
              conversationId: message.conversationId,
              text: newText,
              userId: message.userId,
              userName: message.userName,
              timestamp: message.timestamp,
              isFromUser: message.isFromUser,
            );
          }
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao editar mensagem: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  /// Exclui uma mensagem específica
  Future<void> _deleteMessage(Message message) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir mensagem'),
        content: const Text('Tem certeza que deseja excluir esta mensagem?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await _chatService.deleteMessage(widget.conversation.id, message.id);
        setState(() {
          _messages.removeWhere((m) => m.id == message.id);
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir mensagem: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  /// Mostra opções ao pressionar mensagem
  void _showMessageOptions(Message message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Text('✏️', style: TextStyle(fontSize: 22)),
              title: const Text('Editar'),
              onTap: () {
                Navigator.of(context).pop();
                _editMessage(message);
              },
            ),
            ListTile(
              leading: const Text('🗑️', style: TextStyle(fontSize: 22)),
              title: const Text('Excluir'),
              onTap: () {
                Navigator.of(context).pop();
                _deleteMessage(message);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const CustomIcon(emoji: '↩', size: 24),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Voltar',
        ),
        title: Text(widget.conversation.title),
        actions: [
          IconButton(
            onPressed: _editOtherSideName,
            icon: const CustomIcon(
              emoji: '📝',
              size: 22,
            ),
            tooltip: 'Editar nome do outro lado',
          ),
          IconButton(
            onPressed: _clearConversation,
            icon: const CustomIcon(
              emoji: '🧹',
              size: 24,
            ),
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
                            const CustomIcon(
                              emoji: '💬',
                              size: 80,
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
                          return MessageBubble(
                            message: message,
                            isFromCurrentUser: message.isFromUser,
                            otherSideName: _otherSideName,
                            onLongPress: () => _showMessageOptions(message),
                          );
                        },
                      ),
          ),
          DualMessageInput(
            onSendMessage: _sendMessage,
            hintText: 'Digite sua mensagem...',
          ),
        ],
      ),
    );
  }
}