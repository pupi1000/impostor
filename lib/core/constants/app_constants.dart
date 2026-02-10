/// Application-wide constants for the Impostor Game.
///
/// This file centralizes all constants used throughout the application
/// to ensure consistency and ease of maintenance.
///
/// Constants are organized by category and follow naming conventions:
/// - UPPER_CASE for compile-time constants
/// - camelCase for runtime constants
/// - Descriptive names with context
///
/// Author: Professional Development Team
/// Version: 1.0.0

import 'package:flutter/material.dart';

/// Game configuration constants
abstract class GameConstants {
  /// Minimum number of players allowed in a game
  static const int minPlayers = 3;

  /// Maximum number of players allowed in a game
  static const int maxPlayers = 20;

  /// Minimum number of impostors required
  static const int minImpostors = 1;

  /// Default number of players
  static const int defaultPlayers = 5;

  /// Default number of impostors
  static const int defaultImpostors = 1;

  /// Maximum number of impostors (should be less than total players)
  static int maxImpostors(int totalPlayers) => totalPlayers - 1;

  /// Default game session timeout in minutes
  static const int sessionTimeoutMinutes = 30;

  /// Maximum custom players allowed
  static const int maxCustomPlayers = 100;

  /// Minimum custom players required
  static const int minCustomPlayers = 10;
}

/// UI-related constants
abstract class UIConstants {
  /// Animation durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 350);
  static const Duration slowAnimation = Duration(milliseconds: 600);
  static const Duration backgroundAnimation = Duration(seconds: 4);
  static const Duration fadeTransition = Duration(milliseconds: 800);
  static const Duration slideTransition = Duration(milliseconds: 400);

  /// Border radius values
  static const double smallRadius = 8.0;
  static const double normalRadius = 16.0;
  static const double largeRadius = 22.0;
  static const double extraLargeRadius = 30.0;

  /// Card elevations
  static const double lowElevation = 4.0;
  static const double normalElevation = 8.0;
  static const double highElevation = 14.0;

  /// Spacing values
  static const double tinySpacing = 4.0;
  static const double smallSpacing = 8.0;
  static const double normalSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  /// Font sizes
  static const double smallFontSize = 12.0;
  static const double normalFontSize = 16.0;
  static const double largeFontSize = 20.0;
  static const double titleFontSize = 24.0;
  static const double headerFontSize = 28.0;
  static const double heroFontSize = 32.0;

  /// Button dimensions
  static const double buttonHeight = 56.0;
  static const double smallButtonHeight = 40.0;
  static const double largeButtonHeight = 70.0;
  static const double buttonMinWidth = 120.0;

  /// Icon sizes
  static const double smallIconSize = 16.0;
  static const double normalIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;

  /// Opacity values
  static const double lowOpacity = 0.3;
  static const double mediumOpacity = 0.5;
  static const double highOpacity = 0.7;
  static const double veryHighOpacity = 0.9;
}

/// Asset paths and resource constants
abstract class AssetConstants {
  /// Base paths
  static const String assetsPath = 'assets/';
  static const String videosPath = '${assetsPath}videos/';
  static const String rivePath = '${assetsPath}rive/';
  static const String iconsPath = '${assetsPath}icons/';

  /// Video assets
  static const String introVideo = '${videosPath}intro.mp4';
  static const String intro2Video = '${videosPath}intro2.mp4';
  static const String intro3Video = '${videosPath}intro3.mp4';
  static const String video2 = '${videosPath}video2.mp4';
  static const String button1Video = '${videosPath}boton1.mp4';
  static const String button2Video = '${videosPath}boton2.mp4';

  /// Rive animations
  static const String lightModeRive = '${rivePath}light_mode.riv';
  static const String playButtonRive = '${rivePath}play_button.riv';
  static const String pressButtonRive = '${rivePath}press_button.riv';
  static const String fireRive = '${rivePath}rive_fire.riv';

  /// App icon
  static const String appIcon = '${assetsPath}icon.png';
}

/// Color constants for themes
abstract class ColorConstants {
  /// Primary colors
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color primaryGreen = Color(0xFF388E3C);
  static const Color primaryOrange = Color(0xFFF57C00);
  static const Color primaryPurple = Color(0xFF7B1FA2);
  static const Color primaryGold = Color(0xFFFFB300);

  /// Semantic colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);

  /// Neutral colors
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF424242);

  /// Gradient colors
  static const List<Color> redGradient = [
    Color(0xFFD32F2F),
    Color(0xFF000000),
  ];

  static const List<Color> blueGradient = [
    Color(0xFF1976D2),
    Color(0xFF0D47A1),
  ];

  static const List<Color> goldGradient = [
    Color(0xFFFFB300),
    Color(0xFFFF8F00),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF424242),
    Color(0xFF000000),
  ];
}

/// Text and content constants
abstract class TextConstants {
  /// App metadata
  static const String appName = 'Impostor Game';
  static const String appVersion = '1.0.0';
  static const String developerName = 'Professional Development Team';

  /// Common UI text
  static const String loading = 'Cargando...';
  static const String error = 'Error';
  static const String retry = 'Reintentar';
  static const String cancel = 'Cancelar';
  static const String accept = 'Aceptar';
  static const String close = 'Cerrar';
  static const String back = 'Volver';
  static const String next = 'Siguiente';
  static const String previous = 'Anterior';
  static const String finish = 'Finalizar';

  /// Game-specific text
  static const String startGame = 'Iniciar Juego';
  static const String newGame = 'Nuevo Juego';
  static const String exitGame = 'Salir del Juego';
  static const String gameRules = '¿Cómo Jugar?';
  static const String settings = 'Configuración';

  /// Error messages
  static const String errorInvalidConfiguration =
      'Configuración inválida. Verifica los parámetros del juego.';
  static const String errorTooManyImpostors =
      'El número de impostores debe ser menor que el número total de jugadores.';
  static const String errorNotEnoughPlayers =
      'Se requieren al menos ${GameConstants.minPlayers} jugadores.';
  static const String errorTooManyPlayers =
      'Máximo ${GameConstants.maxPlayers} jugadores permitidos.';
  static const String errorNoPlayersData =
      'No hay datos de jugadores disponibles para esta categoría.';
  static const String errorLoadingData =
      'Error al cargar los datos. Intenta nuevamente.';

  /// Success messages
  static const String gameConfigurationSaved =
      'Configuración guardada correctamente.';
  static const String gameStartedSuccessfully = 'Juego iniciado correctamente.';
}

/// Route names for navigation
abstract class RouteConstants {
  static const String splash = '/';
  static const String intro = '/intro';
  static const String home = '/home';
  static const String selectMode = '/select-mode';
  static const String categorySelection = '/category-selection';
  static const String gameConfig = '/game-config';
  static const String game = '/game';
  static const String debate = '/debate';
  static const String rules = '/rules';
  static const String settings = '/settings';
  static const String customPlayers = '/custom-players';
}

/// Storage keys for persistence
abstract class StorageConstants {
  static const String themeMode = 'theme_mode';
  static const String lastGameConfig = 'last_game_config';
  static const String customPlayersList = 'custom_players_list';
  static const String gameStatistics = 'game_statistics';
  static const String userPreferences = 'user_preferences';
  static const String appVersion = 'app_version';
}

/// Network and API constants (for future features)
abstract class NetworkConstants {
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds
  static const String baseUrl = 'https://api.impostorgame.com'; // placeholder
  static const String apiVersion = 'v1';
}

/// Debug and development constants
abstract class DebugConstants {
  static const bool enableDetailedLogging = true;
  static const bool enablePerformanceMonitoring = true;
  static const bool enableDebugAnimations = false;
  static const bool enableDebugBanner = false;
}
