/// Game-related enumerations for the Impostor Game application.
///
/// This file contains all enums used throughout the application for
/// type-safe game configuration and categorization.
///
/// Author: Professional Development Team
/// Version: 1.0.0

/// Represents the available game modes in the application.
///
/// Each mode has different gameplay mechanics and player pools.
enum GameMode {
  /// Classic football mode with various categories
  classic('⚽ Modo Clásico', 'Fútbol con diferentes categorías'),

  /// Legends mode featuring historical football players
  legends('🏆 Modo Leyendas', 'Grandes leyendas del fútbol');

  const GameMode(this.displayName, this.description);

  /// The display name shown in the UI
  final String displayName;

  /// A brief description of the game mode
  final String description;

  /// Returns true if this is the classic mode
  bool get isClassic => this == GameMode.classic;

  /// Returns true if this is the legends mode
  bool get isLegends => this == GameMode.legends;
}

/// Represents the available categories within football mode.
///
/// Each category contains a specific subset of players organized
/// by different criteria (leagues, competitions, etc.).
enum FootballCategory {
  /// International players from around the world
  international(
    '🌍 Internacional',
    'Jugadores de todo el mundo',
    'Mezcla de las mejores estrellas globales',
  ),

  /// Players from major European leagues
  leagues(
    '🏆 Ligas',
    'Grandes ligas europeas',
    'Premier League, La Liga, Serie A, Bundesliga',
  ),

  /// Players known for international competitions
  cups(
    '🏅 Copas',
    'Competiciones internacionales',
    'Champions League, Copa del Mundo, Eurocopa',
  ),

  /// National team representatives
  nationalTeams(
    '🇪🇸 Selecciones',
    'Equipos nacionales',
    'Jugadores por sus selecciones nacionales',
  ),

  /// Players organized by specific seasons or eras
  seasons(
    '📅 Temporadas',
    'Jugadores por época',
    'Estrellas de diferentes generaciones',
  ),

  /// User-defined custom player lists
  custom(
    '⚙️ Personalizado',
    'Crea tu propia lista',
    'Añade tus propios jugadores favoritos',
  );

  const FootballCategory(this.displayName, this.subtitle, this.description);

  /// The main display name for the category
  final String displayName;

  /// A short subtitle for the category
  final String subtitle;

  /// A detailed description of the category
  final String description;

  /// Returns the icon for this category
  String get icon {
    switch (this) {
      case FootballCategory.international:
        return '🌍';
      case FootballCategory.leagues:
        return '🏆';
      case FootballCategory.cups:
        return '🏅';
      case FootballCategory.nationalTeams:
        return '🇪🇸';
      case FootballCategory.seasons:
        return '📅';
      case FootballCategory.custom:
        return '⚙️';
    }
  }

  /// Returns true if this category supports custom player addition
  bool get isCustomizable => this == FootballCategory.custom;

  /// Returns true if this category contains predefined players
  bool get hasPredefinedPlayers => !isCustomizable;
}

/// Represents the difficulty levels available in the game.
///
/// Difficulty affects the obscurity of players shown in the game.
enum Difficulty {
  /// Easy difficulty with well-known players
  easy('Fácil', 'Jugadores muy conocidos'),

  /// Medium difficulty with moderately known players
  medium('Medio', 'Jugadores conocidos'),

  /// Hard difficulty with less known players
  hard('Difícil', 'Jugadores menos conocidos');

  const Difficulty(this.displayName, this.description);

  /// The display name for the difficulty level
  final String displayName;

  /// A description of the difficulty level
  final String description;

  /// Returns the next difficulty level, or null if this is the highest
  Difficulty? get next {
    switch (this) {
      case Difficulty.easy:
        return Difficulty.medium;
      case Difficulty.medium:
        return Difficulty.hard;
      case Difficulty.hard:
        return null;
    }
  }

  /// Returns the previous difficulty level, or null if this is the lowest
  Difficulty? get previous {
    switch (this) {
      case Difficulty.easy:
        return null;
      case Difficulty.medium:
        return Difficulty.easy;
      case Difficulty.hard:
        return Difficulty.medium;
    }
  }
}

/// Represents the possible roles a player can have in the game.
enum PlayerRole {
  /// A regular player who knows the chosen footballer
  regular('Futbolista'),

  /// The impostor who doesn't know the chosen footballer
  impostor('Impostor');

  const PlayerRole(this.displayName);

  /// The display name for the role
  final String displayName;

  /// Returns true if this is the impostor role
  bool get isImpostor => this == PlayerRole.impostor;

  /// Returns true if this is a regular player role
  bool get isRegular => this == PlayerRole.regular;
}
