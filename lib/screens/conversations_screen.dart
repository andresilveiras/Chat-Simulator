import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../services/auth_service.dart';
import '../services/conversation_service.dart';
import 'chat_screen.dart';
import '../widgets/conversation_tile.dart';
import '../widgets/custom_icon.dart';
import '../screens/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'profile_screen.dart';
import '../services/image_storage_service.dart';

/// Enum para tipos de ordenação das conversas
enum SortType {
  recent('Mais Recentes'),
  alphabetical('Ordem Alfabética'),
  oldest('Mais Antigas'),
  mostMessages('Mais Mensagens'),
  leastMessages('Menos Mensagens');

  const SortType(this.label);
  final String label;
}

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
  final ImageStorageService _imageStorageService = ImageStorageService();
  final List<Conversation> _conversations = [];
  final List<Conversation> _allConversations = [];
  bool _isLoading = true;
  SortType _currentSortType = SortType.recent;

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
        _allConversations.clear();
        _allConversations.addAll(conversations);
        _applySorting();
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

  /// Aplica a ordenação atual às conversas
  void _applySorting() {
    final sortedConversations = List<Conversation>.from(_allConversations);
    
    switch (_currentSortType) {
      case SortType.recent:
        sortedConversations.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
        break;
      case SortType.alphabetical:
        sortedConversations.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case SortType.oldest:
        sortedConversations.sort((a, b) => a.lastMessageAt.compareTo(b.lastMessageAt));
        break;
      case SortType.mostMessages:
        sortedConversations.sort((a, b) => b.messageCount.compareTo(a.messageCount));
        break;
      case SortType.leastMessages:
        sortedConversations.sort((a, b) => a.messageCount.compareTo(b.messageCount));
        break;
    }
    
    setState(() {
      _conversations.clear();
      _conversations.addAll(sortedConversations);
    });
  }

  /// Altera o tipo de ordenação
  void _changeSortType(SortType newSortType) {
    setState(() {
      _currentSortType = newSortType;
    });
    _applySorting();
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
          _allConversations.add(conversation);
          _applySorting();
        });
        
        if (mounted) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(conversation: conversation),
            ),
          );
          // Recarrega conversas quando voltar do chat
          _loadConversations();
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
          _allConversations.remove(conversation);
          _applySorting();
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

  /// Edita o título de uma conversa
  Future<void> _editConversationTitle(Conversation conversation) async {
    final TextEditingController titleController = TextEditingController(text: conversation.title);
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Título'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Título da conversa',
            hintText: 'Digite o novo título da conversa',
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
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty && result.trim() != conversation.title) {
      try {
        final updatedConversation = conversation.copyWith(title: result.trim());
        await _conversationService.updateConversation(updatedConversation);
        
        setState(() {
          final index = _allConversations.indexWhere((c) => c.id == conversation.id);
          if (index != -1) {
            _allConversations[index] = updatedConversation;
          }
          _applySorting();
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Título atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao atualizar título: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  /// Edita a imagem da conversa (agora salva no Storage e Firestore)
  Future<void> _editConversationImage(Conversation conversation) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked == null) return;

      // Crop circular
      final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recortar imagem',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Recortar imagem',
            aspectRatioLockEnabled: true,
          ),
        ],
      );
      if (cropped == null) return;

      String? imageUrl;
      if (_authService.isAuthenticated && !_authService.currentUser!.isAnonymous) {
        try{
          // Upload para o Firebase Storage
          imageUrl = await _imageStorageService.uploadConversationImage(
            _authService.currentUserId,
            conversation.id,
            File(cropped.path),
          );
          // Atualiza a conversa no Firestore
          final updated = conversation.copyWith(imageUrl: imageUrl);
          await _conversationService.updateConversation(updated);
          setState(() {
            final idx = _allConversations.indexWhere((c) => c.id == conversation.id);
            if (idx != -1) {
              _allConversations[idx] = updated;
            }
            _applySorting();
          });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Imagem da conversa atualizada com sucesso!'), backgroundColor: Colors.green),
            );
        }catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha no upload da imagem: $e'), backgroundColor: Colors.red),
        );
      }
      } else {
        // Modo local
        final updated = conversation.copyWith(imageUrl: 'file://${cropped.path}');
        await _conversationService.updateConversation(updated);
        setState(() {
          final idx = _allConversations.indexWhere((c) => c.id == conversation.id);
          if (idx != -1) {
            _allConversations[idx] = updated;
          }
          _applySorting();
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Imagem processada!'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao processar imagem: $e'),
            backgroundColor: Colors.red,
          ),
        );
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

  void _showConversationOptions(Conversation conversation) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Text('✏️', style: TextStyle(fontSize: 22)),
              title: const Text('Editar título'),
              onTap: () {
                Navigator.of(context).pop();
                _editConversationTitle(conversation);
              },
            ),
            ListTile(
              leading: const Text('🖼️', style: TextStyle(fontSize: 22)),
              title: const Text('Editar imagem'),
              onTap: () {
                Navigator.of(context).pop();
                _editConversationImage(conversation);
              },
            ),
            ListTile(
              leading: const Text('🗑️', style: TextStyle(fontSize: 22)),
              title: const Text('Excluir'),
              onTap: () {
                Navigator.of(context).pop();
                _deleteConversation(conversation);
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
        title: const Text('Chat Simulator'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              // Atualiza a tela após editar o perfil
              setState(() {});
            },
            icon: const Icon(Icons.person),
            tooltip: 'Perfil',
          ),
          // Botão de ordenação
          PopupMenuButton<SortType>(
            icon: const CustomIcon(
              emoji: '📊',
              size: 24,
            ),
            tooltip: 'Ordenar conversas',
            onSelected: _changeSortType,
            itemBuilder: (context) => SortType.values.map((sortType) {
              final bool isSelected = sortType == _currentSortType;
              return PopupMenuItem<SortType>(
                value: sortType,
                child: Container(
                  width: double.infinity,
                  decoration: isSelected
                      ? BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        )
                      : null,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    sortType.label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
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
              : Column(
                  children: [
                    // Indicador de ordenação
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey.shade800 
                          : Colors.grey.shade100,
                      child: Row(
                        children: [
                          const CustomIcon(
                            emoji: '📊',
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ordenado por: ${_currentSortType.label}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.grey.shade400 
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _conversations.length,
                        itemBuilder: (context, index) {
                          final conversation = _conversations[index];
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(conversation: conversation),
                                ),
                              );
                              // Recarrega conversas quando voltar do chat
                              _loadConversations();
                            },
                            onLongPress: () => _showConversationOptions(conversation),
                            child: ConversationTile(
                              conversation: conversation,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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