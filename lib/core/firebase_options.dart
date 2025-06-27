import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Configurações do Firebase para o projeto Chat Simulator
/// 
/// ⚠️ IMPORTANTE: Para produção, gere as configurações reais usando:
/// flutterfire configure
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Configurações para Web
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBsCWZa-j9o921FAXK-1CotHctDcY9Zr10',
    appId: '1:435765898359:web:22e48cf5901c3e114aea72',
    messagingSenderId: '435765898359',
    projectId: 'chat-simulator-app',
    authDomain: 'chat-simulator-app.firebaseapp.com',
    storageBucket: 'chat-simulator-app.firebasestorage.app',
  );

  // Configurações para Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBsCWZa-j9o921FAXK-1CotHctDcY9Zr10',
    appId: '1:435765898359:android:22e48cf5901c3e114aea72',
    messagingSenderId: '435765898359',
    projectId: 'chat-simulator-app',
    storageBucket: 'chat-simulator-app.firebasestorage.app',
  );

  // Configurações para iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBsCWZa-j9o921FAXK-1CotHctDcY9Zr10',
    appId: '1:435765898359:ios:22e48cf5901c3e114aea72',
    messagingSenderId: '435765898359',
    projectId: 'chat-simulator-app',
    storageBucket: 'chat-simulator-app.firebasestorage.app',
    iosClientId: '435765898359-44kv88kh3is0nqi8gohmhgmh42t9fi7p.apps.googleusercontent.com',
    iosBundleId: 'com.andresilveiras.chatsimulator',
  );

  // Configurações para macOS
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBsCWZa-j9o921FAXK-1CotHctDcY9Zr10',
    appId: '1:435765898359:ios:22e48cf5901c3e114aea72',
    messagingSenderId: '435765898359',
    projectId: 'chat-simulator-app',
    storageBucket: 'chat-simulator-app.firebasestorage.app',
    iosClientId: '435765898359-44kv88kh3is0nqi8gohmhgmh42t9fi7p.apps.googleusercontent.com',
    iosBundleId: 'com.andresilveiras.chatsimulator',
  );

  // Configurações para Windows
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBsCWZa-j9o921FAXK-1CotHctDcY9Zr10',
    appId: '1:435765898359:web:22e48cf5901c3e114aea72',
    messagingSenderId: '435765898359',
    projectId: 'chat-simulator-app',
    authDomain: 'chat-simulator-app.firebaseapp.com',
    storageBucket: 'chat-simulator-app.firebasestorage.app',
  );
}