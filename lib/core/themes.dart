// themes.dart - Define theme data
import 'package:flutter/material.dart';

/// Classe responsável pelos temas do aplicativo
/// Segue as convenções de nomenclatura UpperCamelCase
class AppThemes {
  /// Tema claro do aplicativo
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontWeight: FontWeight.w300),
      bodyMedium: TextStyle(fontWeight: FontWeight.w300),
      bodySmall: TextStyle(fontWeight: FontWeight.w300),
      titleLarge: TextStyle(fontWeight: FontWeight.w300),
      titleMedium: TextStyle(fontWeight: FontWeight.w300),
      titleSmall: TextStyle(fontWeight: FontWeight.w300),
      labelLarge: TextStyle(fontWeight: FontWeight.w300),
      labelMedium: TextStyle(fontWeight: FontWeight.w300),
      labelSmall: TextStyle(fontWeight: FontWeight.w300),
      displayLarge: TextStyle(fontWeight: FontWeight.w300),
      displayMedium: TextStyle(fontWeight: FontWeight.w300),
      displaySmall: TextStyle(fontWeight: FontWeight.w300),
      headlineLarge: TextStyle(fontWeight: FontWeight.w300),
      headlineMedium: TextStyle(fontWeight: FontWeight.w300),
      headlineSmall: TextStyle(fontWeight: FontWeight.w300),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );

  /// Tema escuro do aplicativo
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontWeight: FontWeight.w300),
      bodyMedium: TextStyle(fontWeight: FontWeight.w300),
      bodySmall: TextStyle(fontWeight: FontWeight.w300),
      titleLarge: TextStyle(fontWeight: FontWeight.w300),
      titleMedium: TextStyle(fontWeight: FontWeight.w300),
      titleSmall: TextStyle(fontWeight: FontWeight.w300),
      labelLarge: TextStyle(fontWeight: FontWeight.w300),
      labelMedium: TextStyle(fontWeight: FontWeight.w300),
      labelSmall: TextStyle(fontWeight: FontWeight.w300),
      displayLarge: TextStyle(fontWeight: FontWeight.w300),
      displayMedium: TextStyle(fontWeight: FontWeight.w300),
      displaySmall: TextStyle(fontWeight: FontWeight.w300),
      headlineLarge: TextStyle(fontWeight: FontWeight.w300),
      headlineMedium: TextStyle(fontWeight: FontWeight.w300),
      headlineSmall: TextStyle(fontWeight: FontWeight.w300),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );
}