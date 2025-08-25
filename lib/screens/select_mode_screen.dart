import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../widgets/animated_button.dart';
import '../widgets/custom_transitions.dart';
import '../widgets/settings_sidebar.dart';
import 'config_screen.dart';

/// ============================================================================
///                             PANTALLA: SELECCIÓN DE MODO
/// ============================================================================
class SelectModeScreen extends StatefulWidget {
  final VoidCallback onThemeChanged;
  const SelectModeScreen({super.key, required this.onThemeChanged});

  @override
  _SelectModeScreenState createState() => _SelectModeScreenState();
}

class _SelectModeScreenState extends State<SelectModeScreen> with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoFuture; // Nuevo Future para controlar la carga del video
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/intro2.mp4");
    _initializeVideoFuture = _controller.initialize().then((_) {
      if (!mounted) return;
      _controller
        ..setLooping(true)
        ..setVolume(0.0)
        ..play();
    });

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  // Abre el sidebar usando la clave del Scaffold
  void _openSidebar() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  Future<void> _goToConfig(bool legends) async {
    _controller.pause();
    await Navigator.push(context, createScaleTransitionRoute(ConfigScreen(isLegendsMode: legends)));
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    final overlay = Container(color: Colors.black.withOpacity(0.5));

    final title = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        "Selecciona un Modo de Juego",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
    );

    final buttons = Column(
      children: [
        AnimatedGameButton(
          text: "⚽ Modo Clásico",
          videoPath: "assets/videos/boton1.mp4",
          icon: Icons.sports_soccer,
          onAsyncPressed: () => _goToConfig(false),
        ),
        const SizedBox(height: 28),
        AnimatedGameButton(
          text: "🏆 Modo Leyendas",
          videoPath: "assets/videos/boton2.mp4",
          icon: Icons.military_tech,
          onAsyncPressed: () => _goToConfig(true),
        ),
        const SizedBox(height: 36),
        AnimatedGameButton(
          text: "Salir",
          color: Colors.red.shade700,
          icon: Icons.exit_to_app,
          onPressed: () => exit(0),
        ),
      ],
    );

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx < -10) {
          _openSidebar();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Usa FutureBuilder para esperar a que el video se inicialice
            FutureBuilder(
              future: _initializeVideoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  );
                } else {
                  // Muestra un contenedor negro o un loader mientras carga
                  return Container(
                    color: Colors.black,
                  );
                }
              },
            ),
            overlay,
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RotationTransition(
                      turns: _rotationAnimation,
                      child: IconButton(
                        tooltip: "Configuración y Reglas",
                        icon: const Icon(Icons.settings),
                        color: Colors.white,
                        iconSize: 30,
                        onPressed: _openSidebar,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 24),
                            AppearZoom(child: title),
                            const SizedBox(height: 48),
                            AppearZoom(child: buttons),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        endDrawer: SettingsSidebar(
          onThemeChanged: widget.onThemeChanged,
          isDarkMode: Theme.of(context).brightness == Brightness.dark,
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}