/// Professional game screen with role assignment and gameplay flow.
///
/// This screen handles the core gameplay experience including
/// role assignment, reveal mechanics, and debate initiation.
///
/// Features:
/// - Secure role assignment with impostor mechanics
/// - Progressive player revelation system
/// - Smooth animations and transitions
/// - Professional visual design
/// - Video background integration
/// - Debate screen coordination
///
/// Author: Professional Development Team
/// Version: 1.0.0

import 'dart:math';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../../shared/widgets/custom_transitions.dart';
import '../../../../shared/widgets/video_background.dart';

/// Professional game screen for role assignment and gameplay
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
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> roles;
  int currentPlayer = 1;
  bool showRole = false;

  @override
  void initState() {
    super.initState();
    _assignRoles();
  }

  bool _shouldUseVideoBackground() {
    // Use video background only on mobile platforms for now
    return !kIsWeb &&
        (Platform.isAndroid || Platform.isIOS) &&
        !Platform.isWindows &&
        !Platform.isLinux &&
        !Platform.isMacOS;
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Assigns roles to players with secure randomization
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

  /// Advances to next player or initiates debate
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

  /// Navigates to debate screen
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

  /// Builds the main role revelation card
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
              _AppearZoom(
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
          _buildBackground(),
          overlay,
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _AppearZoom(child: _buildRoleCard()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    if (_shouldUseVideoBackground()) {
      // TODO: Implement video background for mobile platforms
      return _buildStaticBackground();
    } else {
      return _buildStaticBackground();
    }
  }

  Widget _buildStaticBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1a1a1a),
            Color(0xFF000000),
            Color(0xFF2d1a1a),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Colors.red.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

/// Professional debate screen for game completion
class DebateScreen extends StatefulWidget {
  final int players;
  final int impostors;

  const DebateScreen({
    super.key,
    required this.players,
    required this.impostors,
  });

  @override
  State<DebateScreen> createState() => _DebateScreenState();
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

  /// Returns to home screen
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
                child: _AppearZoom(
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

/// Widget for animated appearance with zoom effect
class _AppearZoom extends StatefulWidget {
  final Widget child;
  final double beginScale;

  const _AppearZoom({
    required this.child,
    this.beginScale = 0.8,
  });

  @override
  State<_AppearZoom> createState() => _AppearZoomState();
}

class _AppearZoomState extends State<_AppearZoom>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.beginScale,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}
