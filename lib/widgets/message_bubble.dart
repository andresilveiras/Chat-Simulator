import 'package:flutter/material.dart';
import '../models/message.dart';

/// Widget para exibir uma mensagem individual no chat
/// Segue as convenções de nomenclatura e boas práticas
class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isFromUser = message.isFromUser;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isFromUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                message.userName.isNotEmpty 
                    ? message.userName[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isFromUser
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isFromUser) ...[
                    Text(
                      message.userName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: isFromUser
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFromUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.secondary,
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}