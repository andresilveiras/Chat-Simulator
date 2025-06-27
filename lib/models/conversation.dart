/// Modelo de dados para conversas/tópicos
/// Segue as convenções de nomenclatura UpperCamelCase
class Conversation {
  final String id;
  final String title;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final int messageCount;

  /// Construtor da classe Conversation
  const Conversation({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.createdAt,
    required this.lastMessageAt,
    required this.messageCount,
  });

  /// Cria uma cópia da conversa com campos modificados
  Conversation copyWith({
    String? id,
    String? title,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    int? messageCount,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      messageCount: messageCount ?? this.messageCount,
    );
  }

  @override
  String toString() {
    return 'Conversation(id: $id, title: $title, messageCount: $messageCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Conversation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 