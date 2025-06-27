import 'package:flutter/material.dart';

/// Widget para entrada de mensagens no chat
/// Segue as convenções de nomenclatura e boas práticas
class MessageInput extends StatefulWidget {
  final Function(String) onSendMessage;

  const MessageInput({
    super.key,
    required this.onSendMessage,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Envia a mensagem atual
  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    widget.onSendMessage(text);
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  /// Atualiza o estado de composição
  void _handleChanged(String text) {
    setState(() {
      _isComposing = text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: _handleChanged,
                onSubmitted: _isComposing ? _handleSubmitted : null,
                decoration: InputDecoration(
                  hintText: 'Digite sua mensagem...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  suffixIcon: _isComposing
                      ? IconButton(
                          onPressed: () => _handleSubmitted(_controller.text),
                          icon: const Icon(Icons.send),
                          color: theme.colorScheme.primary,
                        )
                      : null,
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ],
        ),
      ),
    );
  }
}