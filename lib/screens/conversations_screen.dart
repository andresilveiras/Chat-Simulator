import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../services/auth_service.dart';
import '../services/conversation_service.dart';
import 'chat_screen.dart';
import '../widgets/conversation_tile.dart';
import '../widgets/custom_icon.dart';
import '../screens/login_screen.dart';

/// Tela principal com lista de conversas
/// Segue as convenções de nomenclatura e boas práticas
class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  final AuthService _authService = AuthService();
  final ConversationService _conversationService = ConversationService();
  final List<Conversation> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  /// Carrega as conversas do usuário
  Future<void> _loadConversations() async {
    try {
      final conversations = await _conversationService.getConversations();
      setState(() {
        _conversations.clear();
        _conversations.addAll(conversations);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar conversas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Cria uma nova conversa
  Future<void> _createNewConversation() async {
    final TextEditingController titleController = TextEditingController();
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Conversa'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Título da conversa',
            hintText: 'Este será o nome visível na lista de conversas.',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(titleController.text),
            child: const Text('Criar'),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      try {
        final conversation = await _conversationService.createConversation(result);
        setState(() {
          _conversations.add(conversation);
        });
        
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(conversation: conversation),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao criar conversa: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  /// Deleta uma conversa
  Future<void> _deleteConversation(Conversation conversation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Conversa'),
        content: Text('Tem certeza que deseja deletar "${conversation.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _conversationService.deleteConversation(conversation.id);
        setState(() {
          _conversations.remove(conversation);
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao deletar conversa: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  /// Realiza logout
  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro no logout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Simulator'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const CustomIcon(
              emoji: '🚪',
              size: 24,
            ),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _conversations.isEmpty
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
                        'Nenhuma conversa ainda',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Toque no botão + para criar sua primeira conversa',
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
                  padding: const EdgeInsets.all(8),
                  itemCount: _conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = _conversations[index];
                    return ConversationTile(
                      conversation: conversation,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(conversation: conversation),
                          ),
                        );
                      },
                      onDelete: () => _deleteConversation(conversation),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewConversation,
        child: const CustomIcon(
          emoji: '➕',
          size: 28,
        ),
      ),
    );
  }
} 