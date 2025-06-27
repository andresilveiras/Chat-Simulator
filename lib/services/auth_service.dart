/// Serviço responsável pela autenticação usando Firebase Auth
/// Segue as convenções de nomenclatura e boas práticas
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Retorna o usuário atual
  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => _auth.currentUser != null;
  String get currentUserId => _auth.currentUser?.uid ?? '';

  /// Stream de mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Realiza login anônimo
  Future<UserCredential?> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e) {
      print('Erro no login anônimo: $e');
      rethrow;
    }
  }

  /// Realiza login com email e senha
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Erro no login com email: $e');
      rethrow;
    }
  }

  /// Cria conta com email e senha
  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Erro na criação de conta: $e');
      rethrow;
    }
  }

  /// Envia email de recuperação de senha
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Erro no envio de email de recuperação: $e');
      rethrow;
    }
  }

  /// Realiza login com Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // Usuário cancelou

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Erro no login com Google: $e');
      rethrow;
    }
  }

  /// Realiza logout do usuário
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Erro no logout: $e');
      rethrow;
    }
  }

  /// Retorna mensagem de erro amigável
  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Usuário não encontrado. Verifique seu email.';
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'email-already-in-use':
        return 'Este email já está sendo usado.';
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente em alguns minutos.';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet.';
      case 'invalid-credential':
        return 'Credenciais inválidas. Verifique email e senha.';
      case 'operation-not-allowed':
        return 'Este tipo de login não está habilitado.';
      case 'user-disabled':
        return 'Esta conta foi desabilitada.';
      case 'requires-recent-login':
        return 'Faça login novamente para continuar.';
      case 'invalid-verification-code':
        return 'Código de verificação inválido.';
      case 'invalid-verification-id':
        return 'ID de verificação inválido.';
      case 'quota-exceeded':
        return 'Limite de tentativas excedido. Tente mais tarde.';
      default:
        return 'Ocorreu um erro. Tente novamente.';
    }
  }
}