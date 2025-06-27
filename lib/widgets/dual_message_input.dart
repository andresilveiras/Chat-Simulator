import 'package:flutter/material.dart';

/// Widget para entrada de mensagens com dois botões de envio
/// Segue as convenções de nomenclatura e boas práticas
class DualMessageInput extends StatefulWidget {
  final Function(String) onSendUserMessage;
  final Function(String) onSendOtherSideMessage;

  const DualMessageInput({
    super.key,
    required this.onSendUserMessage,
    required this.onSendOtherSideMessage,
  });

  @override
  State<DualMessageInput> createState() => _DualMessageInputState();
}

class _DualMessageInputState extends State<DualMessageInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Envia mensagem do lado direito (usuário)
  void _handleSendUserMessage() {
    if (_controller.text.trim().isEmpty) return;

    widget.onSendUserMessage(_controller.text);
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  /// Envia mensagem do lado esquerdo (outro lado)
  void _handleSendOtherSideMessage() {
    if (_controller.text.trim().isEmpty) return;

    widget.onSendOtherSideMessage(_controller.text);
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Campo de texto
            TextField(
              controller: _controller,
              onChanged: _handleChanged,
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
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            // Botões de envio
            Row(
              children: [
                // Botão do lado esquerdo (outro lado)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isComposing ? _handleSendOtherSideMessage : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Outro Lado'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: theme.colorScheme.onSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Botão do lado direito (usuário)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isComposing ? _handleSendUserMessage : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Você'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 