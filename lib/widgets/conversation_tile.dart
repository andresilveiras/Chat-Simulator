import 'package:flutter/material.dart';
import '../models/conversation.dart';

/// Widget para exibir uma conversa na lista
/// Segue as convenções de nomenclatura e boas práticas
class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: conversation.imageUrl != null
              ? ClipOval(
                  child: Image.network(
                    conversation.imageUrl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        conversation.title.isNotEmpty 
                            ? conversation.title[0].toUpperCase()
                            : 'C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                )
              : Text(
                  conversation.title.isNotEmpty 
                      ? conversation.title[0].toUpperCase()
                      : 'C',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        title: Text(
          conversation.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${conversation.messageCount} mensagens',
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Deletar', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
} 