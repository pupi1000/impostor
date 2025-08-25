import 'package:flutter/material.dart';
import '../widgets/animated_button.dart';
import '../widgets/custom_transitions.dart';
import '../data/players.dart';
import 'game_screen.dart';

/// ============================================================================
///                             PANTALLA: CONFIGURACIÓN
/// ============================================================================
class ConfigScreen extends StatefulWidget {
  final bool isLegendsMode;

  const ConfigScreen({super.key, required this.isLegendsMode});

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> with SingleTickerProviderStateMixin {
  int _players = 5;
  int _impostors = 1;
  String _difficulty = "Fácil";

  late AnimationController _bgController;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..repeat(reverse: true);
    _topAlignmentAnimation = Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight)
        .animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));
    _bottomAlignmentAnimation = Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft)
        .animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  void _startGame() {
    if (_players <= _impostors) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error de Configuración"),
            content: const Text("El número de impostores debe ser menor que el número total de jugadores."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    Navigator.push(
      context,
      createSlideTransitionRoute(
        GameScreen(
          players: _players,
          impostors: _impostors,
          difficulty: _difficulty,
          playersData: widget.isLegendsMode ? legendPlayers : classicPlayers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLegends = widget.isLegendsMode;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Se ajustan los colores del degradado para el modo Leyendas
    final List<Color> gradientColors = isLegends
        ? [Colors.yellow.shade800, Colors.red.shade900] // Degradado dorado-rojo para Leyendas
        : (isDarkMode ? [Colors.grey.shade900, Colors.black] : [Colors.red.shade900, Colors.black]);

    // Se ajusta el título según el modo
    final String title = isLegends ? "🏆 Modo Leyendas 🏆" : "⚽ Modo Clásico ⚽";
    final Color titleColor = isLegends
        ? Colors.yellow.shade800 // Título dorado para Leyendas
        : (isDarkMode ? Colors.blue.shade400 : Colors.red.shade900);

    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    final card = Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: Colors.black, width: 2.0),
      ),
      elevation: 14,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: titleColor), textAlign: TextAlign.center),
            const SizedBox(height: 26),
            Text("Número de jugadores:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 6),
            AppearZoom(
              beginScale: 0.98,
              duration: const Duration(milliseconds: 350),
              child: DropdownButton<int>(
                value: _players,
                dropdownColor: cardColor,
                style: TextStyle(color: textColor, fontSize: 20),
                items: List.generate(10, (i) => DropdownMenuItem(value: i + 3, child: Text("${i + 3} jugadores", style: TextStyle(fontSize: 20, color: textColor)))),
                onChanged: (val) {
                  setState(() {
                    _players = val!;
                    if (_impostors >= _players) {
                      _impostors = _players - 1;
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 22),
            Text("Número de impostores:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 6),
            AppearZoom(
              beginScale: 0.98,
              duration: const Duration(milliseconds: 350),
              child: DropdownButton<int>(
                value: _impostors,
                dropdownColor: cardColor,
                style: TextStyle(color: textColor, fontSize: 20),
                items: List.generate(_players - 1, (i) => DropdownMenuItem(value: i + 1, child: Text("${i + 1} impostor${i > 0 ? 'es' : ''}", style: TextStyle(fontSize: 20, color: textColor)))),
                onChanged: (val) => setState(() => _impostors = val!),
              ),
            ),
            const SizedBox(height: 22),
            Text("Dificultad:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 6),
            AppearZoom(
              beginScale: 0.98,
              duration: const Duration(milliseconds: 350),
              child: DropdownButton<String>(
                value: _difficulty,
                dropdownColor: cardColor,
                style: TextStyle(color: textColor, fontSize: 20),
                items: ["Fácil", "Medio", "Difícil"]
                    .map((dif) => DropdownMenuItem<String>(value: dif, child: Text(dif, style: TextStyle(fontSize: 20, color: textColor))))
                    .toList(),
                onChanged: (val) => setState(() => _difficulty = val!),
              ),
            ),
            const SizedBox(height: 32),
            AnimatedGameButton(
              text: "Iniciar Juego",
              color: Colors.green,
              icon: Icons.play_circle_fill,
              onPressed: _startGame,
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: "Volver",
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(
            foregroundColor: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: isLegends ? _topAlignmentAnimation.value : Alignment.topLeft,
                end: isLegends ? _bottomAlignmentAnimation.value : Alignment.bottomRight,
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppearZoom(child: card),
          ),
        ),
      ),
    );
  }
}