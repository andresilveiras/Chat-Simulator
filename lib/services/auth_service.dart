/// Serviço responsável pela autenticação (versão mock para desenvolvimento)
/// Segue as convenções de nomenclatura e boas práticas
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class AuthService {
  bool _isAuthenticated = false;
  String _userId = '';

  /// Retorna o usuário atual (mock)
  bool get isAuthenticated => _isAuthenticated;
  String get currentUserId => _userId;

  /// Stream de mudanças no estado de autenticação (mock)
  Stream<bool> get authStateChanges => Stream.value(_isAuthenticated);

  /// Realiza login anônimo para desenvolvimento
  /// Retorna true se o login foi bem-sucedido
  Future<bool> signInAnonymously() async {
    try {
      // Simula delay de rede
      await Future.delayed(const Duration(seconds: 1));
      
      _isAuthenticated = true;
      _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      
      return true;
    } catch (e) {
      print('Erro no login anônimo: $e');
      return false;
    }
  }

  /// Realiza logout do usuário
  Future<void> signOut() async {
    try {
      // Simula delay de rede
      await Future.delayed(const Duration(milliseconds: 500));
      
      _isAuthenticated = false;
      _userId = '';
    } catch (e) {
      print('Erro no logout: $e');
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null; // Usuário cancelou

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}