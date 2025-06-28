import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Faz upload da imagem de perfil do usuário e retorna a URL pública
  Future<String> uploadProfileImage(String userId, File imageFile) async {
    final ref = _storage
        .ref()
        .child('profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  /// Faz upload da imagem de uma conversa e retorna a URL pública
  Future<String> uploadConversationImage(String userId, String conversationId, File imageFile) async {
    final ref = _storage
        .ref()
        .child('conversation_images/$userId/${conversationId}_${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  // Você pode adicionar outros métodos para diferentes tipos de upload, se necessário.
} 