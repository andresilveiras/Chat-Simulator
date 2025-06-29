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

  /// Helper method para mostrar mensagem de sucesso
  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
  }

  /// Helper method para mostrar mensagem de erro
  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getProfile();
      if (mounted) {
        setState(() {
          _nameController.text = profile?['displayName'] ?? 'Você';
          _imagePath = profile?['imageUrl'];
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
        _showErrorMessage('Erro ao carregar perfil: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked == null) return;

      // Crop circular
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
        try {
          // Usuário autenticado: faz upload para o Storage
          imageUrl = await _imageStorageService.uploadProfileImage(userId, File(cropped.path));
          // Salva a URL no Firestore junto com o nome
          await _profileService.saveProfile(displayName: _nameController.text.trim(), imageUrl: imageUrl);
          
          if (mounted) {
            setState(() {
              _imagePath = imageUrl;
            });
            _showSuccessMessage('Imagem de perfil atualizada com sucesso!');
          }
        } catch (e) {
          _showErrorMessage('Falha no upload da imagem: $e');
        }
      } else {
        // Usuário anônimo: salva localmente
        try {
          await _profileService.setProfileImagePath(cropped.path);
          if (mounted) {
            setState(() {
              _imagePath = cropped.path;
            });
            _showSuccessMessage('Imagem de perfil atualizada com sucesso!');
          }
        } catch (e) {
          _showErrorMessage('Erro ao salvar imagem localmente: $e');
        }
      }
    } catch (e) {
      _showErrorMessage('Erro ao processar imagem: $e');
    }
  }

  Future<void> _saveProfile() async {
    try {
      final name = _nameController.text.trim();
      if (name.isEmpty) {
        _showErrorMessage('Nome não pode estar vazio');
        return;
      }
      
      final userId = _authService.currentUserId;
      if (userId.isNotEmpty) {
        await _profileService.saveProfile(displayName: name, imageUrl: _imagePath);
      } else {
        await _profileService.setDisplayName(name);
      }
      
      if (mounted) {
        _showSuccessMessage('Perfil salvo com sucesso!');
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      _showErrorMessage('Erro ao salvar perfil: $e');
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