import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  static const _keyDisplayName = 'profile_display_name';
  static const _keyProfileImage = 'profile_image_path';
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Salva nome e imagem no Firestore para usuários autenticados
  Future<void> saveProfile({required String displayName, required String? imageUrl}) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      await _firestore.collection('users').doc(user.uid).collection('profile').doc('main').set({
        'displayName': displayName,
        'imageUrl': imageUrl,
      });
    } on FirebaseException catch (e) {
      // Log do erro para debug
      print('Erro ao salvar perfil no Firestore: ${e.code} - ${e.message}');
      
      // Re-throw com mensagem mais amigável
      switch (e.code) {
        case 'permission-denied':
          throw Exception('Sem permissão para salvar perfil. Verifique sua autenticação.');
        case 'unavailable':
          throw Exception('Serviço temporariamente indisponível. Tente novamente.');
        case 'resource-exhausted':
          throw Exception('Limite de recursos excedido. Tente novamente mais tarde.');
        default:
          throw Exception('Erro ao salvar perfil: ${e.message}');
      }
    } catch (e) {
      // Log de erro inesperado
      print('Erro inesperado ao salvar perfil: $e');
      throw Exception('Erro inesperado ao salvar perfil. Tente novamente.');
    }
  }

  // Busca perfil do Firestore para usuários autenticados
  Future<Map<String, dynamic>?> getProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    
    try {
      final doc = await _firestore.collection('users').doc(user.uid).collection('profile').doc('main').get();
      return doc.exists ? doc.data() : null;
    } on FirebaseException catch (e) {
      // Log do erro para debug
      print('Erro ao buscar perfil do Firestore: ${e.code} - ${e.message}');
      
      // Para erros de permissão ou indisponibilidade, retorna null (fallback para local)
      switch (e.code) {
        case 'permission-denied':
          print('Permissão negada para buscar perfil. Usando dados locais.');
          return null;
        case 'unavailable':
          print('Serviço indisponível. Usando dados locais.');
          return null;
        case 'not-found':
          // Documento não existe, não é um erro
          return null;
        default:
          // Para outros erros, loga mas não quebra o app
          print('Erro ao buscar perfil: ${e.message}');
          return null;
      }
    } catch (e) {
      // Log de erro inesperado
      print('Erro inesperado ao buscar perfil: $e');
      return null;
    }
  }

  // Métodos locais para fallback (anônimo)
  Future<void> setDisplayName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyDisplayName, name);
    } catch (e) {
      print('Erro ao salvar nome localmente: $e');
      throw Exception('Erro ao salvar nome localmente.');
    }
  }

  Future<String> getDisplayName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyDisplayName) ?? 'Você';
    } catch (e) {
      print('Erro ao buscar nome localmente: $e');
      return 'Você'; // Fallback seguro
    }
  }

  Future<void> setProfileImagePath(String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filePath = path.startsWith('file://') ? path : 'file://$path';
      await prefs.setString(_keyProfileImage, filePath);
    } catch (e) {
      print('Erro ao salvar caminho da imagem localmente: $e');
      throw Exception('Erro ao salvar imagem localmente.');
    }
  }

  Future<String?> getProfileImagePath() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyProfileImage);
    } catch (e) {
      print('Erro ao buscar caminho da imagem localmente: $e');
      return null; // Fallback seguro
    }
  }

  Future<void> clearProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyDisplayName);
      await prefs.remove(_keyProfileImage);
    } catch (e) {
      print('Erro ao limpar perfil localmente: $e');
      throw Exception('Erro ao limpar perfil localmente.');
    }
  }
} 