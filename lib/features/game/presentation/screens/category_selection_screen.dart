/// Professional category selection screen with advanced UX patterns.
///
/// This screen provides an intuitive interface for selecting football
/// categories within the classic game mode. It features:
///
/// - Smooth animations and transitions
/// - Loading states and error handling
/// - Preview functionality for categories
/// - Accessibility support
/// - Performance optimizations
/// - Professional visual design
///
/// The screen follows Material 3 design patterns and implements
/// modern Flutter best practices for state management and UI composition.
///
/// Author: Professional Development Team
/// Version: 1.0.0

import 'package:flutter/material.dart';
import '../../../../core/enums/game_enums.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/game_models.dart';
import '../../../../shared/widgets/custom_transitions.dart';
import '../../../../shared/widgets/error_display.dart';
import '../../../game/domain/game_service.dart';
import '../../../game/data/local_player_repository.dart';
import '../widgets/category_card.dart';
import '../widgets/category_preview_dialog.dart';
import '../../../../features/config/presentation/screens/config_screen.dart';

/// State management for category selection
class CategorySelectionController {
  CategorySelectionController() {
    _gameService = GameService(playerRepository: LocalPlayerRepository());
    _loadCategoryStats();
  }

  late final GameService _gameService;
  final Map<FootballCategory, int> _categoryStats = {};
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  Map<FootballCategory, int> get categoryStats =>
      Map.unmodifiable(_categoryStats);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // State change callbacks
  VoidCallback? onStateChanged;

  /// Loads statistics for all categories
  Future<void> _loadCategoryStats() async {
    _setLoading(true);
    _setError(null);

    try {
      // Load stats for each difficulty (using medium as default)
      final stats = await _gameService.getCategoryStatistics(Difficulty.medium);
      _categoryStats.clear();
      _categoryStats.addAll(stats);

      // Load legends stats separately
      final legendsStats =
          await _gameService.getLegendsStatistics(Difficulty.medium);
      debugPrint('Loaded category stats: $stats, legends: $legendsStats');
    } catch (e) {
      _setError('Error loading category data: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Previews players for a specific category
  Future<List<PlayerData>> previewCategory(
    FootballCategory category,
    Difficulty difficulty,
  ) async {
    final config = GameConfig(
      gameMode: GameMode.classic,
      playersCount: 5,
      impostorsCount: 1,
      difficulty: difficulty,
      category: category,
    );

    final result = await _gameService.previewPlayers(config, maxCount: 5);
    return result.dataOrNull ?? [];
  }

  /// Validates if a category has enough players
  Future<bool> validateCategory(
    FootballCategory category,
    Difficulty difficulty,
  ) async {
    final config = GameConfig(
      gameMode: GameMode.classic,
      playersCount: 5,
      impostorsCount: 1,
      difficulty: difficulty,
      category: category,
    );

    final result = await _gameService.validateConfigurationAsync(config);
    return result.isSuccess;
  }

  /// Refreshes category data
  Future<void> refresh() async {
    await _loadCategoryStats();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    onStateChanged?.call();
  }

  void _setError(String? error) {
    _errorMessage = error;
    onStateChanged?.call();
  }

  void dispose() {
    onStateChanged = null;
  }
}

/// Main category selection screen
class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen>
    with TickerProviderStateMixin {
  late final CategorySelectionController _controller;
  late final AnimationController _backgroundController;
  late final AnimationController _listController;
  late final Animation<Alignment> _topAlignmentAnimation;
  late final Animation<Alignment> _bottomAlignmentAnimation;
  late final Animation<double> _listAnimation;

  @override
  void initState() {
    super.initState();

    _controller = CategorySelectionController();
    _controller.onStateChanged = () {
      if (mounted) setState(() {});
    };

    _initializeAnimations();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      vsync: this,
      duration: UIConstants.backgroundAnimation,
    )..repeat(reverse: true);

    _listController = AnimationController(
      vsync: this,
      duration: UIConstants.slowAnimation,
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

    _listAnimation = CurvedAnimation(
      parent: _listController,
      curve: Curves.easeOutCubic,
    );

    // Start list animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _listController.forward();
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _listController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _navigateToConfig(FootballCategory category) async {
    // Validate category before navigation
    final isValid =
        await _controller.validateCategory(category, Difficulty.medium);

    if (!isValid && mounted) {
      _showCategoryError(category);
      return;
    }

    if (mounted) {
      Navigator.push(
        context,
        createSlideTransitionRoute(
          ConfigScreen(
            gameMode: GameMode.classic,
            category: category,
          ),
        ),
      );
    }
  }

  void _showCategoryError(FootballCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Categoría no disponible'),
        content: Text(
          'La categoría "${category.displayName}" no tiene suficientes '
          'jugadores disponibles. Intenta con otra categoría.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showCategoryPreview(FootballCategory category) async {
    final players =
        await _controller.previewCategory(category, Difficulty.medium);

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => CategoryPreviewDialog(
          category: category,
          players: players,
          onSelectCategory: () {
            Navigator.pop(context);
            _navigateToConfig(category);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(theme, isDarkMode),
      extendBodyBehindAppBar: true,
      body: _buildBody(theme, isDarkMode),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, bool isDarkMode) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        '⚽ Modo Clásico - Fútbol',
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
      actions: [
        if (_controller.isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else
          IconButton(
            tooltip: "Actualizar",
            icon: const Icon(Icons.refresh),
            onPressed: _controller.refresh,
            style: IconButton.styleFrom(
              foregroundColor: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
      ],
    );
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
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.largeSpacing),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: UIConstants.extraLargeSpacing),
              Expanded(child: _buildCategoryList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Semantics(
      header: true,
      label: 'Selecciona una categoría de fútbol',
      child: Column(
        children: [
          const Text(
            'Selecciona una Categoría',
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
            'Cada categoría ofrece diferentes tipos de jugadores',
            style: TextStyle(
              fontSize: UIConstants.normalFontSize,
              color: Colors.white.withOpacity(UIConstants.veryHighOpacity),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    if (_controller.errorMessage != null) {
      return ErrorDisplay(
        message: _controller.errorMessage!,
        onRetry: _controller.refresh,
      );
    }

    return AnimatedBuilder(
      animation: _listAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _listAnimation.value)),
          child: Opacity(
            opacity: _listAnimation.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: ListView.separated(
        itemCount: FootballCategory.values.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: UIConstants.normalSpacing),
        itemBuilder: (context, index) {
          final category = FootballCategory.values[index];
          final playerCount = _controller.categoryStats[category] ?? 0;

          return CategoryCard(
            category: category,
            playerCount: playerCount,
            isLoading: _controller.isLoading,
            onTap: () => _navigateToConfig(category),
            onPreview: () => _showCategoryPreview(category),
          );
        },
      ),
    );
  }
}
