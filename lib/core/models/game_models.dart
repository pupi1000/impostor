/// Core data models for the Impostor Game application.
///
/// This file contains immutable data classes that represent
/// the fundamental entities in the game domain.
///
/// All models follow the principles of:
/// - Immutability
/// - Null safety
/// - Value equality
/// - Clear documentation
///
/// Author: Professional Development Team
/// Version: 1.0.0

import 'package:flutter/foundation.dart';
import '../enums/game_enums.dart';

/// Represents a football player in the game.
///
/// This is the core entity that holds information about a player
/// that can be used in the guessing game.
@immutable
class PlayerData {
  /// Creates a new [PlayerData] instance.
  ///
  /// [name] is required and cannot be empty.
  /// All other fields are optional and provide additional context.
  const PlayerData({
    required this.name,
    this.team,
    this.position,
    this.nationality,
    this.league,
    this.rating,
    this.era,
    this.isActive = true,
  }) : assert(name != '', 'Player name cannot be empty');

  /// The player's full name (required)
  final String name;

  /// The player's current or last team
  final String? team;

  /// The player's position on the field
  final String? position;

  /// The player's nationality
  final String? nationality;

  /// The league the player plays/played in
  final String? league;

  /// A numerical rating of the player (1-100)
  final int? rating;

  /// The era when the player was/is active
  final String? era;

  /// Whether the player is currently active
  final bool isActive;

  /// Creates a copy of this player with updated fields
  PlayerData copyWith({
    String? name,
    String? team,
    String? position,
    String? nationality,
    String? league,
    int? rating,
    String? era,
    bool? isActive,
  }) {
    return PlayerData(
      name: name ?? this.name,
      team: team ?? this.team,
      position: position ?? this.position,
      nationality: nationality ?? this.nationality,
      league: league ?? this.league,
      rating: rating ?? this.rating,
      era: era ?? this.era,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Returns a display-friendly representation of the player
  String get displayName => name;

  /// Returns additional info for UI display
  String? get additionalInfo {
    final List<String> info = [];
    if (team != null) info.add(team!);
    if (position != null) info.add(position!);
    if (nationality != null) info.add(nationality!);

    return info.isEmpty ? null : info.join(' • ');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayerData &&
        other.name == name &&
        other.team == team &&
        other.position == position &&
        other.nationality == nationality &&
        other.league == league &&
        other.rating == rating &&
        other.era == era &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      team,
      position,
      nationality,
      league,
      rating,
      era,
      isActive,
    );
  }

  @override
  String toString() {
    return 'PlayerData(name: $name, team: $team, position: $position, '
        'nationality: $nationality, league: $league, rating: $rating, '
        'era: $era, isActive: $isActive)';
  }
}

/// Represents a complete game configuration.
///
/// This class encapsulates all the settings needed to start a game,
/// including player count, impostor count, difficulty, and data source.
@immutable
class GameConfig {
  /// Creates a new [GameConfig] instance.
  ///
  /// Validates that the configuration is logically consistent.
  const GameConfig({
    required this.gameMode,
    required this.playersCount,
    required this.impostorsCount,
    required this.difficulty,
    this.category,
    this.customPlayers,
  })  : assert(playersCount >= 3, 'Minimum 3 players required'),
        assert(playersCount <= 20, 'Maximum 20 players allowed'),
        assert(impostorsCount >= 1, 'Minimum 1 impostor required'),
        assert(impostorsCount < playersCount,
            'Impostors must be less than total players');

  /// The selected game mode
  final GameMode gameMode;

  /// Total number of players in the game
  final int playersCount;

  /// Number of impostors in the game
  final int impostorsCount;

  /// The difficulty level
  final Difficulty difficulty;

  /// The selected category (for classic mode)
  final FootballCategory? category;

  /// Custom player list (for custom category)
  final List<PlayerData>? customPlayers;

  /// Number of regular (non-impostor) players
  int get regularPlayersCount => playersCount - impostorsCount;

  /// Whether this configuration uses custom players
  bool get hasCustomPlayers =>
      customPlayers != null && customPlayers!.isNotEmpty;

  /// Whether this configuration is valid for starting a game
  bool get isValid {
    if (gameMode == GameMode.classic && category == null) return false;
    if (category == FootballCategory.custom && !hasCustomPlayers) return false;
    return playersCount > impostorsCount && impostorsCount > 0;
  }

  /// Creates a copy with updated values
  GameConfig copyWith({
    GameMode? gameMode,
    int? playersCount,
    int? impostorsCount,
    Difficulty? difficulty,
    FootballCategory? category,
    List<PlayerData>? customPlayers,
  }) {
    return GameConfig(
      gameMode: gameMode ?? this.gameMode,
      playersCount: playersCount ?? this.playersCount,
      impostorsCount: impostorsCount ?? this.impostorsCount,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      customPlayers: customPlayers ?? this.customPlayers,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameConfig &&
        other.gameMode == gameMode &&
        other.playersCount == playersCount &&
        other.impostorsCount == impostorsCount &&
        other.difficulty == difficulty &&
        other.category == category &&
        listEquals(other.customPlayers, customPlayers);
  }

  @override
  int get hashCode {
    return Object.hash(
      gameMode,
      playersCount,
      impostorsCount,
      difficulty,
      category,
      customPlayers,
    );
  }

  @override
  String toString() {
    return 'GameConfig(gameMode: $gameMode, playersCount: $playersCount, '
        'impostorsCount: $impostorsCount, difficulty: $difficulty, '
        'category: $category, customPlayers: ${customPlayers?.length})';
  }
}

/// Represents the result of role assignment for a single player.
///
/// Contains the player's assigned role and the target footballer
/// they should know about (or null for impostors).
@immutable
class RoleAssignment {
  /// Creates a new [RoleAssignment].
  const RoleAssignment({
    required this.playerIndex,
    required this.role,
    this.targetPlayer,
  });

  /// The index of the player (0-based)
  final int playerIndex;

  /// The assigned role for this player
  final PlayerRole role;

  /// The footballer this player should know about (null for impostors)
  final PlayerData? targetPlayer;

  /// Display text to show to the player
  String get displayText {
    if (role.isImpostor) {
      return '🚨 Eres el IMPOSTOR 🚨';
    }
    return '⚽ Futbolista: ${targetPlayer?.displayName ?? 'Unknown'}';
  }

  /// Whether this assignment has a target player
  bool get hasTargetPlayer => targetPlayer != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RoleAssignment &&
        other.playerIndex == playerIndex &&
        other.role == role &&
        other.targetPlayer == targetPlayer;
  }

  @override
  int get hashCode {
    return Object.hash(playerIndex, role, targetPlayer);
  }

  @override
  String toString() {
    return 'RoleAssignment(playerIndex: $playerIndex, role: $role, '
        'targetPlayer: ${targetPlayer?.name})';
  }
}

/// Represents the complete result of a role assignment operation.
///
/// Contains all player assignments and metadata about the game setup.
@immutable
class GameSession {
  /// Creates a new [GameSession].
  const GameSession({
    required this.config,
    required this.assignments,
    required this.chosenPlayer,
    required this.startTime,
  });

  /// The configuration used for this session
  final GameConfig config;

  /// Role assignments for all players
  final List<RoleAssignment> assignments;

  /// The footballer chosen for this round
  final PlayerData chosenPlayer;

  /// When this session was created
  final DateTime startTime;

  /// All impostor assignments
  List<RoleAssignment> get impostorAssignments =>
      assignments.where((a) => a.role.isImpostor).toList();

  /// All regular player assignments
  List<RoleAssignment> get regularAssignments =>
      assignments.where((a) => a.role.isRegular).toList();

  /// Total duration of the session (if ended)
  Duration? sessionDuration(DateTime? endTime) {
    return endTime?.difference(startTime);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameSession &&
        other.config == config &&
        listEquals(other.assignments, assignments) &&
        other.chosenPlayer == chosenPlayer &&
        other.startTime == startTime;
  }

  @override
  int get hashCode {
    return Object.hash(config, assignments, chosenPlayer, startTime);
  }

  @override
  String toString() {
    return 'GameSession(config: $config, assignments: ${assignments.length}, '
        'chosenPlayer: ${chosenPlayer.name}, startTime: $startTime)';
  }
}
