// main.dart - Entry point
import 'package:flutter/material.dart';
import 'app.dart';

/// Entry point do aplicativo Chat Simulator
/// Inicializa e executa o app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Configurar Firebase quando tiver as credenciais
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  runApp(const ChatSimulatorApp());
}