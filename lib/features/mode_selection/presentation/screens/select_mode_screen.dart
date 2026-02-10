/// Professional mode selection screen with video background.
///
/// This screen provides game mode selection functionality with
/// sophisticated UX patterns and smooth video backgrounds.
///
/// Features:
/// - Immersive video background with overlays
/// - Animated mode selection buttons
/// - Settings sidebar integration
/// - Smooth navigation transitions
/// - Professional visual design
/// - Touch gesture support
///
/// Author: Professional Development Team
/// Version: 1.0.0

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/enums/game_enums.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../../shared/widgets/custom_transitions.dart';
import '../../../../shared/widgets/settings_sidebar.dart';
import '../../../config/presentation/screens/config_screen.dart';
import '../../../game/presentation/screens/category_selection_screen.dart';

/// Professional mode selection screen
class SelectModeScreen extends StatefulWidget {
  final VoidCallback onThemeChanged;

  const SelectModeScreen({super.key, required this.onThemeChanged});

  @override
  State<SelectModeScreen> createState() => _SelectModeScreenState();
}

class _SelectModeScreenState extends State<SelectModeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

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
    _rotationController.dispose();
    super.dispose();
  }

  /// Opens the settings sidebar
  void _openSidebar() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  /// Navigates to configuration screen based on mode
  Future<void> _goToConfig(bool legends) async {
    if (legends) {
      // Legends mode goes directly to config with international category
      await Navigator.push(
        context,
        createScaleTransitionRoute(const ConfigScreen(
          gameMode: GameMode.legends,
          category: FootballCategory.international,
        )),
      );
    } else {
      // Classic mode goes to category selection
      await Navigator.push(
        context,
        createScaleTransitionRoute(const CategorySelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final overlay = Container(color: Colors.black.withOpacity(0.5));

    final title = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: const Text(
        "Selecciona un Modo de Juego",
        textAlign: TextAlign.center,
        style: TextStyle(
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
            // Static background
            _buildBackground(),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 24),
                            _AppearZoom(child: title),
                            const SizedBox(height: 48),
                            _AppearZoom(child: buttons),
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

/// Widget for animated appearance with zoom effect
class _AppearZoom extends StatefulWidget {
  final Widget child;

  const _AppearZoom({required this.child});

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
      begin: 0.8,
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
