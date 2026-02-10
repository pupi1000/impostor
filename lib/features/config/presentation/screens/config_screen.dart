/// Professional game configuration screen with advanced settings.
///
/// This screen provides comprehensive configuration options for
/// the impostor game, supporting multiple game modes and categories
/// with sophisticated validation and UX patterns.
///
/// Features:
/// - Dynamic configuration based on game mode and category
/// - Real-time validation with visual feedback
/// - Smooth animations and transitions
/// - Accessibility support
/// - Performance optimizations
/// - Professional visual design
///
/// Author: Professional Development Team
/// Version: 1.0.0

import 'package:flutter/material.dart';
import '../../../../core/enums/game_enums.dart';
import '../../../../core/models/game_models.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../../../game/domain/game_service.dart';
import '../../../game/data/local_player_repository.dart';
import '../../../game/presentation/screens/game_screen.dart';
import '../../../../shared/widgets/custom_transitions.dart';

/// Game configuration screen with professional UX
class ConfigScreen extends StatefulWidget {
  const ConfigScreen({
    super.key,
    required this.gameMode,
    this.category,
  });

  /// The game mode being configured
  final GameMode gameMode;

  /// The football category (required for classic mode)
  final FootballCategory? category;

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen>
    with TickerProviderStateMixin {
  // Configuration state
  int _totalPlayers = GameConstants.defaultPlayers;
  int _impostorCount = GameConstants.defaultImpostors;
  Difficulty _difficulty = Difficulty.medium;

  // Controllers and animations
  late AnimationController _backgroundController;
  late AnimationController _formController;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;
  late Animation<double> _formAnimation;

  // Services and state
  late GameService _gameService;
  bool _isValidating = false;
  bool _isStarting = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _initializeAnimations();
    _validateInitialConfiguration();
  }

  void _initializeServices() {
    _gameService = GameService(playerRepository: LocalPlayerRepository());
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _topAlignmentAnimation = Tween<Alignment>(
      begin: Alignment.topLeft,
      end: Alignment.topRight,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _bottomAlignmentAnimation = Tween<Alignment>(
      begin: Alignment.bottomRight,
      end: Alignment.bottomLeft,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _formAnimation = CurvedAnimation(
      parent: _formController,
      curve: Curves.easeOut,
    );

    _formController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _formController.dispose();
    super.dispose();
  }

  void _validateInitialConfiguration() async {
    await _validateConfiguration();
  }

  Future<void> _validateConfiguration() async {
    if (_isValidating) return;

    setState(() {
      _isValidating = true;
      _validationError = null;
    });

    try {
      // Validate basic rules
      if (_totalPlayers <= _impostorCount) {
        setState(() {
          _validationError =
              'El número de impostores debe ser menor al total de jugadores';
        });
        return;
      }

      if (_totalPlayers < GameConstants.minPlayers) {
        setState(() {
          _validationError =
              'Se requieren al menos ${GameConstants.minPlayers} jugadores';
        });
        return;
      }

      if (_totalPlayers > GameConstants.maxPlayers) {
        setState(() {
          _validationError =
              'Máximo ${GameConstants.maxPlayers} jugadores permitidos';
        });
        return;
      }

      // Validate category availability for classic mode
      if (widget.gameMode == GameMode.classic && widget.category != null) {
        // This would normally check available players in the category
        // For now, we'll assume all categories are valid
      }

      setState(() {
        _validationError = null;
      });
    } catch (e) {
      setState(() {
        _validationError = 'Error validando la configuración: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isValidating = false;
      });
    }
  }

  void _startGame() async {
    if (_validationError != null || _isStarting) return;

    setState(() {
      _isStarting = true;
    });

    try {
      final config = GameConfig(
        gameMode: widget.gameMode,
        category: widget.category,
        difficulty: _difficulty,
        playersCount: _totalPlayers,
        impostorsCount: _impostorCount,
      );

      final result = await _gameService.createGameSession(config);

      switch (result) {
        case GameServiceSuccess(:final data):
          if (mounted) {
            // Convert to old GameScreen format
            final session = data;

            // Extract player data for old format
            final Map<String, List<String>> playersData = {};

            // Get realistic player names from the football data
            final List<String> playerNames = [];

            // Add the chosen player first
            playerNames.add(session.chosenPlayer.name);

            // Add more realistic player names for the remaining slots
            final sampleNames = [
              'Lionel Messi',
              'Cristiano Ronaldo',
              'Neymar Jr',
              'Kylian Mbappé',
              'Erling Haaland',
              'Karim Benzema',
              'Mohamed Salah',
              'Sadio Mané',
              'Kevin De Bruyne',
              'Luka Modrić',
              'Virgil van Dijk',
              'Robert Lewandowski',
              'Pedri',
              'Gavi',
              'Jude Bellingham',
              'Vinícius Jr',
              'Federico Chiesa',
              'Mason Mount',
              'Phil Foden',
              'Bukayo Saka'
            ];

            // Fill remaining slots
            for (int i = 1;
                i < session.config.playersCount && i - 1 < sampleNames.length;
                i++) {
              playerNames.add(sampleNames[i - 1]);
            }

            // Use difficulty as key since GameScreen expects it
            playersData[session.config.difficulty.displayName] = playerNames;

            Navigator.pushReplacement(
              context,
              createSlideTransitionRoute(
                GameScreen(
                  players: session.config.playersCount,
                  impostors: session.config.impostorsCount,
                  difficulty: session.config.difficulty.displayName,
                  playersData: playersData,
                ),
              ),
            );
          }
          break;
        case GameServiceError(:final message):
          if (mounted) {
            _showError('Error iniciando el juego', message);
          }
          break;
      }
    } catch (e) {
      if (mounted) {
        _showError('Error inesperado', e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isStarting = false;
        });
      }
    }
  }

  void _showError(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(theme, isDarkMode),
      extendBodyBehindAppBar: true,
      body: LoadingOverlay(
        isVisible: _isStarting,
        message: 'Iniciando juego...',
        child: _buildBody(theme, isDarkMode),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, bool isDarkMode) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        _getScreenTitle(),
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.red.shade900,
          fontWeight: FontWeight.bold,
          fontSize: UIConstants.titleFontSize,
        ),
      ),
      leading: IconButton(
        tooltip: "Volver",
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        style: IconButton.styleFrom(
          foregroundColor: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  String _getScreenTitle() {
    final modeText = widget.gameMode.displayName;
    final categoryText = widget.category?.displayName ?? '';

    if (categoryText.isNotEmpty) {
      return '$modeText - $categoryText';
    }
    return modeText;
  }

  Widget _buildBody(ThemeData theme, bool isDarkMode) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? ColorConstants.darkGradient
                  : ColorConstants.redGradient,
              begin: _topAlignmentAnimation.value,
              end: _bottomAlignmentAnimation.value,
            ),
          ),
          child: child,
        );
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(UIConstants.largeSpacing),
          child: AnimatedBuilder(
            animation: _formAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _formAnimation.value,
                child: Opacity(
                  opacity: _formAnimation.value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: UIConstants.extraLargeSpacing),
                _buildConfigurationForm(),
                const SizedBox(height: UIConstants.extraLargeSpacing),
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Configuración del Juego',
          style: TextStyle(
            fontSize: UIConstants.headerFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black54,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: UIConstants.smallSpacing),
        Text(
          _getSubtitle(),
          style: TextStyle(
            fontSize: UIConstants.normalFontSize,
            color: Colors.white.withOpacity(UIConstants.veryHighOpacity),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getSubtitle() {
    switch (widget.gameMode) {
      case GameMode.classic:
        return 'Configura tu partida de fútbol clásico';
      case GameMode.legends:
        return 'Configura tu partida con leyendas del fútbol';
    }
  }

  Widget _buildConfigurationForm() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.normalRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.largeSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlayerCountSection(),
            const SizedBox(height: UIConstants.largeSpacing),
            _buildImpostorCountSection(),
            const SizedBox(height: UIConstants.largeSpacing),
            _buildDifficultySection(),
            if (_validationError != null) ...[
              const SizedBox(height: UIConstants.normalSpacing),
              _buildValidationError(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Número total de jugadores',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: UIConstants.smallSpacing),
        Row(
          children: [
            IconButton(
              onPressed: _totalPlayers > GameConstants.minPlayers
                  ? () => _updatePlayerCount(_totalPlayers - 1)
                  : null,
              icon: const Icon(Icons.remove_circle),
            ),
            Expanded(
              child: Text(
                '$_totalPlayers jugadores',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            IconButton(
              onPressed: _totalPlayers < GameConstants.maxPlayers
                  ? () => _updatePlayerCount(_totalPlayers + 1)
                  : null,
              icon: const Icon(Icons.add_circle),
            ),
          ],
        ),
        Text(
          'Rango: ${GameConstants.minPlayers} - ${GameConstants.maxPlayers}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }

  Widget _buildImpostorCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Número de impostores',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: UIConstants.smallSpacing),
        Row(
          children: [
            IconButton(
              onPressed: _impostorCount > GameConstants.minImpostors
                  ? () => _updateImpostorCount(_impostorCount - 1)
                  : null,
              icon: const Icon(Icons.remove_circle),
            ),
            Expanded(
              child: Text(
                '$_impostorCount impostores',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            IconButton(
              onPressed: _impostorCount < _totalPlayers - 1
                  ? () => _updateImpostorCount(_impostorCount + 1)
                  : null,
              icon: const Icon(Icons.add_circle),
            ),
          ],
        ),
        Text(
          'Máximo: ${_totalPlayers - 1}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }

  Widget _buildDifficultySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dificultad',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: UIConstants.smallSpacing),
        SegmentedButton<Difficulty>(
          segments: Difficulty.values.map((difficulty) {
            return ButtonSegment<Difficulty>(
              value: difficulty,
              label: Text(difficulty.displayName),
            );
          }).toList(),
          selected: {_difficulty},
          onSelectionChanged: (Set<Difficulty> selected) {
            setState(() {
              _difficulty = selected.first;
            });
            _validateConfiguration();
          },
        ),
        const SizedBox(height: UIConstants.smallSpacing),
        Text(
          _difficulty.description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }

  Widget _buildValidationError() {
    return Container(
      padding: const EdgeInsets.all(UIConstants.normalSpacing),
      decoration: BoxDecoration(
        color: ColorConstants.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(UIConstants.smallRadius),
        border: Border.all(
          color: ColorConstants.errorColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: ColorConstants.errorColor,
            size: UIConstants.normalIconSize,
          ),
          const SizedBox(width: UIConstants.smallSpacing),
          Expanded(
            child: Text(
              _validationError!,
              style: TextStyle(
                color: ColorConstants.errorColor,
                fontSize: UIConstants.smallFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    final isValid = _validationError == null && !_isValidating;

    return Column(
      children: [
        ElevatedButton(
          onPressed: isValid ? _startGame : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstants.successColor,
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.extraLargeSpacing,
              vertical: UIConstants.normalSpacing,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_arrow, color: Colors.white),
              const SizedBox(width: UIConstants.smallSpacing),
              const Text(
                'Iniciar Juego',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: UIConstants.normalFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (_isValidating) ...[
          const SizedBox(height: UIConstants.normalSpacing),
          const CircularProgressIndicator(),
        ],
      ],
    );
  }

  void _updatePlayerCount(int newCount) {
    setState(() {
      _totalPlayers = newCount;
      if (_impostorCount >= newCount) {
        _impostorCount = newCount - 1;
      }
    });
    _validateConfiguration();
  }

  void _updateImpostorCount(int newCount) {
    setState(() {
      _impostorCount = newCount;
    });
    _validateConfiguration();
  }
}
