import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import '../services/profile_service.dart';
import '../services/auth_service.dart';
import '../services/image_storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();
  final ImageStorageService _imageStorageService = ImageStorageService();
  final TextEditingController _nameController = TextEditingController();
  String? _imagePath;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _profileService.getProfile();
    setState(() {
      _nameController.text = profile?['displayName'] ?? 'Você';
      _imagePath = profile?['imageUrl'];
      _loading = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recortar imagem',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Recortar imagem',
          aspectRatioLockEnabled: true,
        ),
      ],
    );
    if (cropped == null) return;

    final userId = _authService.currentUserId;
    String? imageUrl;
    if (userId.isNotEmpty) {
      try{
        // Usuário autenticado: faz upload para o Storage
        imageUrl = await _imageStorageService.uploadProfileImage(userId, File(cropped.path));
        // Salva a URL no Firestore junto com o nome (ou só a imagem se nome não mudou)
        await _profileService.saveProfile(displayName: _nameController.text.trim(), imageUrl: imageUrl);
        setState(() {
          _imagePath = imageUrl;
        });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Imagem de perfil atualizada com sucesso!'), backgroundColor: Colors.green),
          );
      }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha no upload da imagem: $e'), backgroundColor: Colors.red),
      );
    }
    } else {
      // Usuário anônimo: salva localmente
      await _profileService.setProfileImagePath(cropped.path);
      setState(() {
        _imagePath = cropped.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final userId = _authService.currentUserId;
    if (userId.isNotEmpty) {
      await _profileService.saveProfile(displayName: name, imageUrl: _imagePath);
    } else {
      await _profileService.setDisplayName(name);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil salvo com sucesso!'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.blue.shade100,
                      backgroundImage: _imagePath != null
                          ? (_imagePath!.startsWith('http')
                              ? NetworkImage(_imagePath!)
                              : FileImage(File(_imagePath!)) as ImageProvider)
                          : null,
                      child: _imagePath == null
                          ? const Text('👤', style: TextStyle(fontSize: 48, color: Colors.blue))
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Toque no avatar para escolher uma imagem 📷', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome de exibição',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
} 