import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../widgets/animated_button.dart';
import '../widgets/custom_transitions.dart';
import '../widgets/video_background.dart';

/// ============================================================================
///                                PANTALLA: JUEGO
/// ============================================================================
class GameScreen extends StatefulWidget {
  final int players;
  final int impostors;
  final String difficulty;
  final Map<String, List<String>> playersData;

  const GameScreen({
    super.key,
    required this.players,
    required this.impostors,
    required this.difficulty,
    required this.playersData,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> roles;
  int currentPlayer = 1;
  bool showRole = false;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _assignRoles();

    _controller = VideoPlayerController.asset("assets/videos/intro3.mp4")
      ..initialize().then((_) {
        if (!mounted) return;
        _controller
          ..setLooping(true)
          ..setVolume(0.0)
          ..play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _assignRoles() {
    final rand = Random();

    final List<String> playerList =
        List<String>.from(widget.playersData[widget.difficulty]!);
    playerList.shuffle(rand);
    final chosenPlayer = playerList.first;

    final impostorIndices = <int>{};
    while (impostorIndices.length < widget.impostors) {
      impostorIndices.add(rand.nextInt(widget.players));
    }

    roles = List.generate(
        widget.players,
        (i) => impostorIndices.contains(i)
            ? '🚨 Eres el IMPOSTOR 🚨'
            : '⚽ Futbolista: $chosenPlayer');
  }

  void _nextPlayer() {
    if (currentPlayer < widget.players) {
      setState(() {
        currentPlayer++;
        showRole = false;
      });
    } else {
      _showDebateScreen();
    }
  }

  void _showDebateScreen() {
    Navigator.push(
      context,
      createSlideTransitionRoute(
        DebateScreen(
          players: widget.players,
          impostors: widget.impostors,
        ),
      ),
    );
  }

  Widget _buildRoleCard() {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 14,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Container(
        padding: const EdgeInsets.all(28),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Jugador $currentPlayer / ${widget.players}",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 28),
            if (!showRole)
              AnimatedGameButton(
                expanded: true,
                text: "Ver mi rol",
                color: Theme.of(context).colorScheme.primary,
                icon: Icons.visibility,
                onPressed: () => setState(() => showRole = true),
                height: 56,
              )
            else ...[
              AppearZoom(
                beginScale: 0.95,
                child: Text(
                  roles[currentPlayer - 1],
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 28),
              AnimatedGameButton(
                expanded: true,
                text: currentPlayer < widget.players
                    ? "Siguiente jugador"
                    : "Comenzar debate",
                color: Colors.green,
                icon: Icons.arrow_forward,
                onPressed: _nextPlayer,
                height: 56,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final overlay = Container(color: Colors.black.withOpacity(0.60));

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_controller.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          overlay,
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AppearZoom(child: _buildRoleCard()),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
///                             PANTALLA: DEBATE
/// ============================================================================
class DebateScreen extends StatefulWidget {
  final int players;
  final int impostors;

  const DebateScreen({
    super.key,
    required this.players,
    required this.impostors,
  });

  @override
  _DebateScreenState createState() => _DebateScreenState();
}

class _DebateScreenState extends State<DebateScreen> {
  late int startingPlayer;
  late String direction;

  @override
  void initState() {
    super.initState();
    final rand = Random();
    startingPlayer = rand.nextInt(widget.players) + 1;
    direction = rand.nextBool() ? "Derecha" : "Izquierda";
  }

  void _returnToHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          StaticVideoBackground(videoPath: "assets/videos/final.mp4"),
          Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.7)
                  : Colors.black.withOpacity(0.3)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: AppearZoom(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 2.0),
                    ),
                    elevation: 14,
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "¡COMIENCE EL JUEGO! 🎮",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Comienza el turno:",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Jugador $startingPlayer",
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Dirección:",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            direction,
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          ),
                          const SizedBox(height: 32),
                          AnimatedGameButton(
                            expanded: true,
                            text: "Volver a Inicio",
                            color: Colors.red.shade700,
                            icon: Icons.home,
                            onPressed: _returnToHome,
                            height: 56,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
