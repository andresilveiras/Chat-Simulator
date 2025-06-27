import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../core/themes.dart';
import 'custom_icon.dart';

/// Widget para exibir um item de conversa na lista
/// Segue as convenções de nomenclatura e boas práticas
class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isDark ? 2 : 1,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CustomAvatar(
          radius: 28,
          backgroundColor: isDark ? Colors.blue.shade800 : Colors.blue.shade100,
          textColor: isDark ? Colors.white : Colors.blue.shade700,
          text: conversation.title.characters.firstOrNull?.toUpperCase(),
          emoji: '💬',
        ),
        title: Text(
          conversation.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          '${conversation.messageCount} mensagens',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        trailing: onDelete != null
            ? IconButton(
                onPressed: onDelete,
                icon: const CustomIcon(
                  emoji: '🗑️',
                  size: 22,
                ),
                color: Colors.red,
              )
            : const CustomIcon(
                emoji: '➡️',
                size: 22,
              ),
        onTap: onTap,
      ),
    );
  }
} 