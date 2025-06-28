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
    await _firestore.collection('users').doc(user.uid).collection('profile').doc('main').set({
      'displayName': displayName,
      'imageUrl': imageUrl,
    });
  }

  // Busca perfil do Firestore para usuários autenticados
  Future<Map<String, dynamic>?> getProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).collection('profile').doc('main').get();
    return doc.exists ? doc.data() : null;
  }

  // Métodos locais para fallback (anônimo)
  Future<void> setDisplayName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDisplayName, name);
  }

  Future<String> getDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDisplayName) ?? 'Você';
  }

  Future<void> setProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final filePath = path.startsWith('file://') ? path : 'file://$path';
    await prefs.setString(_keyProfileImage, filePath);
  }

  Future<String?> getProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyProfileImage);
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDisplayName);
    await prefs.remove(_keyProfileImage);
  }
} 