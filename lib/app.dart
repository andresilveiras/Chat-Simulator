// app.dart - MaterialApp and routing setup
import 'package:flutter/material.dart';
import 'core/themes.dart';
import 'screens/login_screen.dart';

/// Widget principal do aplicativo Chat Simulator
/// Configura o MaterialApp com tema e rotas
class ChatSimulatorApp extends StatelessWidget {
  const ChatSimulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Simulator',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}