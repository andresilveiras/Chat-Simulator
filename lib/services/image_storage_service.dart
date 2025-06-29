import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class ImageStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Constantes para validação
  static const int _maxFileSizeBytes = 10 * 1024 * 1024; // 10MB
  static const List<String> _allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> _allowedMimeTypes = [
    'image/jpeg',
    'image/jpg', 
    'image/png',
    'image/webp'
  ];

  /// Valida o arquivo de imagem antes do upload
  void _validateImageFile(File imageFile) {
    if (!imageFile.existsSync()) {
      throw Exception('Arquivo de imagem não encontrado');
    }

    final fileSize = imageFile.lengthSync();
    if (fileSize > _maxFileSizeBytes) {
      throw Exception('Arquivo muito grande. Tamanho máximo: 10MB');
    }

    final extension = path.extension(imageFile.path).toLowerCase().replaceFirst('.', '');
    if (!_allowedExtensions.contains(extension)) {
      throw Exception('Tipo de arquivo não suportado. Use: ${_allowedExtensions.join(', ')}');
    }
  }

  /// Determina a extensão do arquivo dinamicamente
  String _getFileExtension(File imageFile) {
    final extension = path.extension(imageFile.path).toLowerCase();
    return extension.isNotEmpty ? extension : '.jpg';
  }

  /// Método privado para upload de imagem com lógica compartilhada
  Future<String> _uploadImage({
    required String userId,
    required File imageFile,
    required String storagePathPrefix,
    String? conversationId,
  }) async {
    Reference? uploadedRef;
    
    try {
      // Valida o arquivo antes do upload
      _validateImageFile(imageFile);
      
      // Determina a extensão dinamicamente
      final extension = _getFileExtension(imageFile);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      // Gera nome do arquivo baseado no tipo de upload
      final fileName = conversationId != null 
          ? '${conversationId}_$timestamp$extension'
          : '$timestamp$extension';
      
      final ref = _storage
          .ref()
          .child('$storagePathPrefix/$userId/$fileName');
      
      uploadedRef = ref;
      
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      // Limpa arquivo parcial em caso de erro
      if (uploadedRef != null) {
        try {
          await uploadedRef.delete();
        } catch (deleteError) {
          // Ignora erro de limpeza, mas loga para debug
          print('Erro ao limpar arquivo parcial: $deleteError');
        }
      }
      
      switch (e.code) {
        case 'unauthorized':
          throw Exception('Sem permissão para fazer upload. Verifique sua autenticação.');
        case 'storage/object-not-found':
          throw Exception('Arquivo não encontrado no servidor.');
        case 'storage/quota-exceeded':
          throw Exception('Limite de armazenamento excedido.');
        default:
          throw Exception('Erro no upload: ${e.message}');
      }
    } catch (e) {
      // Limpa arquivo parcial em caso de erro
      if (uploadedRef != null) {
        try {
          await uploadedRef.delete();
        } catch (deleteError) {
          print('Erro ao limpar arquivo parcial: $deleteError');
        }
      }
      
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Erro inesperado no upload: $e');
    }
  }

  /// Faz upload da imagem de perfil do usuário e retorna a URL pública
  Future<String> uploadProfileImage(String userId, File imageFile) async {
    return await _uploadImage(
      userId: userId,
      imageFile: imageFile,
      storagePathPrefix: 'profile_images',
    );
  }

  /// Faz upload da imagem de uma conversa e retorna a URL pública
  Future<String> uploadConversationImage(String userId, String conversationId, File imageFile) async {
    return await _uploadImage(
      userId: userId,
      imageFile: imageFile,
      storagePathPrefix: 'conversation_images',
      conversationId: conversationId,
    );
  }

  /// Remove uma imagem do Storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'unauthorized':
          throw Exception('Sem permissão para deletar arquivo.');
        case 'storage/object-not-found':
          // Arquivo já não existe, não é um erro
          return;
        default:
          throw Exception('Erro ao deletar arquivo: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erro inesperado ao deletar arquivo: $e');
    }
  }

  // Você pode adicionar outros métodos para diferentes tipos de upload, se necessário.
} 