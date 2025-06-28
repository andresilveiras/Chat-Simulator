import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final TextEditingController _nameController = TextEditingController();
  String? _imagePath;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final name = await _profileService.getDisplayName();
    final imagePath = await _profileService.getProfileImagePath();
    setState(() {
      _nameController.text = name;
      _imagePath = imagePath;
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
    await _profileService.setProfileImagePath(cropped.path);
    setState(() {
      _imagePath = cropped.path;
    });
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    await _profileService.setDisplayName(name);
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
                      backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
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