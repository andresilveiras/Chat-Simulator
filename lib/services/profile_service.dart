import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const _keyDisplayName = 'profile_display_name';
  static const _keyProfileImage = 'profile_image_path';

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