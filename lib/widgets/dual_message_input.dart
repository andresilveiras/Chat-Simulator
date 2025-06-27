import 'package:flutter/material.dart';
import '../core/themes.dart';
import 'custom_icon.dart';

/// Widget de input com dois botões para simular conversas
/// Segue as convenções de nomenclatura e boas práticas
class DualMessageInput extends StatefulWidget {
  final Function(String, bool) onSendMessage;
  final String? hintText;

  const DualMessageInput({
    super.key,
    required this.onSendMessage,
    this.hintText,
  });

  @override
  State<DualMessageInput> createState() => _DualMessageInputState();
}

class _DualMessageInputState extends State<DualMessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage(bool isFromUser) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text, isFromUser);
      _controller.clear();
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: widget.hintText ?? 'Digite sua mensagem...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(true),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Botão "Outro Lado"
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.orange.shade700 : Colors.orange.shade500,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              onPressed: () => _sendMessage(false),
              icon: const CustomIcon(
                emoji: '⬅',
                size: 22,
              ),
              color: Colors.white,
              tooltip: 'Enviar como outro lado',
            ),
          ),
          const SizedBox(width: 8),
          // Botão "Você"
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.blue.shade600 : Colors.blue.shade500,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              onPressed: () => _sendMessage(true),
              icon: const CustomIcon(
                emoji: '➡',
                size: 22,
              ),
              color: Colors.white,
              tooltip: 'Enviar como você',
            ),
          ),
        ],
      ),
    );
  }
} 