import 'package:flutter/material.dart';
import '../models/message.dart';
import '../core/themes.dart';
import 'custom_icon.dart';
import 'dart:io';

/// Widget para exibir uma bolha de mensagem
/// Segue as convenções de nomenclatura e boas práticas
class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isFromCurrentUser;
  final String? otherSideName;
  final VoidCallback? onLongPress;
  final String? imageUrl;
  final String? displayName;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isFromCurrentUser,
    this.otherSideName,
    this.onLongPress,
    this.imageUrl,
    this.displayName,
  });

  /// Helper method para criar ImageProvider baseado no tipo de URL
  ImageProvider? _getImageProvider(String url) {
    try {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        // URL de rede (Firebase Storage, etc.)
        return NetworkImage(url);
      } else if (url.startsWith('file://')) {
        // URL de arquivo local com protocolo
        final filePath = Uri.parse(url).toFilePath();
        final file = File(filePath);
        if (file.existsSync()) {
          return FileImage(file);
        }
      } else {
        // Caminho de arquivo local direto
        final file = File(url);
        if (file.existsSync()) {
          return FileImage(file);
        }
      }
    } catch (e) {
      // Log do erro para debug, mas não quebra o app
      print('Erro ao carregar imagem: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final avatar = (imageUrl != null && imageUrl!.isNotEmpty)
        ? CircleAvatar(
            radius: 18,
            backgroundImage: _getImageProvider(imageUrl!),
            onBackgroundImageError: (exception, stackTrace) {
              print('Erro ao carregar imagem de perfil: $exception');
            },
            child: _getImageProvider(imageUrl!) == null
                ? CustomIcon(
                    emoji: isFromCurrentUser ? '🧑‍💻' : '🧑‍💻',
                    size: 24,
                    color: isFromCurrentUser
                        ? Colors.white
                        : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                  )
                : null,
          )
        : CircleAvatar(
            radius: 18,
            backgroundColor: isFromCurrentUser ? Colors.blue.shade200 : Colors.grey.shade400,
            child: CustomIcon(
              emoji: isFromCurrentUser ? '🧑‍💻' : '🧑‍💻',
              size: 24,
              color: isFromCurrentUser
                  ? Colors.white
                  : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
            ),
          );

    final display = isFromCurrentUser ? (displayName ?? 'Você') : (otherSideName ?? 'Outro Lado');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isFromCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromCurrentUser) ...[
            avatar,
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isFromCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    display,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isFromCurrentUser
                          ? Colors.blue.shade400
                          : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    ),
                  ),
                ),
                GestureDetector(
                  onLongPress: onLongPress,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: isFromCurrentUser
                          ? (isDark ? Colors.blue.shade600 : Colors.blue.shade500)
                          : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
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
                        Text(
                          message.text,
                          style: TextStyle(
                            fontSize: 16,
                            color: isFromCurrentUser
                                ? Colors.white
                                : (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            fontSize: 11,
                            color: isFromCurrentUser
                                ? Colors.white.withOpacity(0.7)
                                : (isDark ? Colors.grey.shade500 : Colors.grey.shade500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isFromCurrentUser) ...[
            const SizedBox(width: 8),
            avatar,
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
