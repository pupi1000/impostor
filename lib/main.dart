import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ImpostorGame());
}

class ImpostorGame extends StatefulWidget {
  @override
  _ImpostorGameState createState() => _ImpostorGameState();
}

class _ImpostorGameState extends State<ImpostorGame> {
  // Estado para el modo de tema (oscuro por defecto)
  ThemeMode _themeMode = ThemeMode.dark;

  // Método para alternar el tema
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Definición de temas
    final lightTheme = ThemeData(
      colorSchemeSeed: Colors.green,
      brightness: Brightness.light,
      fontFamily: 'Roboto',
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey.shade200,
    );

    final darkTheme = ThemeData(
      colorSchemeSeed: Colors.green,
      brightness: Brightness.dark,
      fontFamily: 'Roboto',
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey.shade900,
    );

    return MaterialApp(
      title: 'Juego del Impostor ⚽',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: IntroScreen(onThemeChanged: _toggleTheme),
    );
  }
}