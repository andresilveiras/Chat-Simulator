/// Modelo de dados para mensagens
/// Segue as convenções de nomenclatura UpperCamelCase
class Message {
  final String id;
  final String conversationId;
  final String text;
  final String userId;
  final String userName;
  final DateTime timestamp;
  final bool isFromUser;

  /// Construtor da classe Message
  const Message({
    required this.id,
    required this.conversationId,
    required this.text,
    required this.userId,
    required this.userName,
    required this.timestamp,
    required this.isFromUser,
  });

  /// Cria uma cópia da mensagem com campos modificados
  Message copyWith({
    String? id,
    String? conversationId,
    String? text,
    String? userId,
    String? userName,
    DateTime? timestamp,
    bool? isFromUser,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      text: text ?? this.text,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      timestamp: timestamp ?? this.timestamp,
      isFromUser: isFromUser ?? this.isFromUser,
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, conversationId: $conversationId, text: $text, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}