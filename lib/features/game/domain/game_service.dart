/// Game logic service for role assignment and game session management.
///
/// This service encapsulates all the business logic for creating and
/// managing impostor game sessions. It provides deterministic and
/// testable role assignment algorithms with proper error handling.
///
/// Key features:
/// - Deterministic role assignment with seeded randomization
/// - Comprehensive validation of game configurations
/// - Immutable game state management
/// - Detailed error reporting
/// - Performance optimized for large player pools
///
/// Author: Professional Development Team
/// Version: 1.0.0

import 'dart:math';
import '../../../core/enums/game_enums.dart';
import '../../../core/models/game_models.dart';
import '../domain/player_repository.dart';

/// Result type for game service operations
sealed class GameServiceResult<T> {
  const GameServiceResult();
}

/// Successful game service result
final class GameServiceSuccess<T> extends GameServiceResult<T> {
  const GameServiceSuccess(this.data);
  final T data;
}

/// Failed game service result
final class GameServiceError<T> extends GameServiceResult<T> {
  const GameServiceError(this.message, [this.details]);
  final String message;
  final String? details;
}

/// Core game logic service
class GameService {
  /// Creates a new [GameService] instance
  ///
  /// [playerRepository] is required for data access
  /// [randomSeed] can be provided for deterministic testing
  GameService({
    required this.playerRepository,
    int? randomSeed,
  }) : _random = Random(randomSeed);

  final PlayerRepository playerRepository;
  final Random _random;

  /// Creates a new game session based on the provided configuration
  ///
  /// This method:
  /// 1. Validates the game configuration
  /// 2. Retrieves appropriate players from the repository
  /// 3. Selects a random target player
  /// 4. Assigns roles to all participants
  /// 5. Returns a complete [GameSession] or error
  Future<GameServiceResult<GameSession>> createGameSession(
    GameConfig config,
  ) async {
    try {
      // Validate configuration
      final validationResult = _validateGameConfig(config);
      if (validationResult != null) {
        return GameServiceError(validationResult);
      }

      // Get players based on game mode and category
      final playersResult = await _getPlayersForConfig(config);
      switch (playersResult) {
        case RepositoryFailure(:final message, :final exception):
          return GameServiceError(
            'Failed to load players: $message',
            exception?.toString(),
          );
        case RepositorySuccess(:final data):
          final availablePlayers = data;
          if (availablePlayers.isEmpty) {
            return const GameServiceError(
              'No players available for the selected configuration',
            );
          }

          // Select target player randomly
          final targetPlayer = _selectRandomPlayer(availablePlayers);

          // Generate role assignments
          final assignments = _generateRoleAssignments(config, targetPlayer);

          // Create game session
          final session = GameSession(
            config: config,
            assignments: assignments,
            chosenPlayer: targetPlayer,
            startTime: DateTime.now(),
          );

          return GameServiceSuccess(session);
      }
    } catch (e, stackTrace) {
      return GameServiceError(
        'Unexpected error creating game session',
        'Error: $e\nStack: $stackTrace',
      );
    }
  }

  /// Validates if a game configuration is logically consistent
  ///
  /// Returns null if valid, error message if invalid
  String? _validateGameConfig(GameConfig config) {
    // Check player count bounds
    if (config.playersCount < 3) {
      return 'Minimum 3 players required';
    }
    if (config.playersCount > 20) {
      return 'Maximum 20 players allowed';
    }

    // Check impostor count
    if (config.impostorsCount < 1) {
      return 'At least 1 impostor required';
    }
    if (config.impostorsCount >= config.playersCount) {
      return 'Impostors must be less than total players';
    }

    // Check category requirements for classic mode
    if (config.gameMode == GameMode.classic && config.category == null) {
      return 'Category must be selected for classic mode';
    }

    // Check custom players for custom category
    if (config.category == FootballCategory.custom) {
      if (config.customPlayers == null || config.customPlayers!.isEmpty) {
        return 'Custom players list cannot be empty for custom category';
      }
      if (config.customPlayers!.length < 3) {
        return 'Custom category requires at least 3 players';
      }
    }

    return null; // Valid configuration
  }

  /// Retrieves players based on game configuration
  Future<RepositoryResult<List<PlayerData>>> _getPlayersForConfig(
    GameConfig config,
  ) async {
    if (config.gameMode == GameMode.legends) {
      return await playerRepository.getLegendsPlayers(
        difficulty: config.difficulty,
      );
    }

    if (config.category == FootballCategory.custom) {
      return await playerRepository.getCustomPlayers();
    }

    return await playerRepository.getPlayersForCategory(
      category: config.category!,
      difficulty: config.difficulty,
    );
  }

  /// Selects a random player from the available list
  PlayerData _selectRandomPlayer(List<PlayerData> players) {
    final randomIndex = _random.nextInt(players.length);
    return players[randomIndex];
  }

  /// Generates role assignments for all players
  List<RoleAssignment> _generateRoleAssignments(
    GameConfig config,
    PlayerData targetPlayer,
  ) {
    final assignments = <RoleAssignment>[];

    // Generate impostor indices
    final impostorIndices = _generateImpostorIndices(
      config.playersCount,
      config.impostorsCount,
    );

    // Create assignments for each player
    for (int i = 0; i < config.playersCount; i++) {
      final isImpostor = impostorIndices.contains(i);
      final role = isImpostor ? PlayerRole.impostor : PlayerRole.regular;

      assignments.add(RoleAssignment(
        playerIndex: i,
        role: role,
        targetPlayer: isImpostor ? null : targetPlayer,
      ));
    }

    return assignments;
  }

  /// Generates unique random indices for impostors
  Set<int> _generateImpostorIndices(int totalPlayers, int impostorCount) {
    final indices = <int>{};

    while (indices.length < impostorCount) {
      final randomIndex = _random.nextInt(totalPlayers);
      indices.add(randomIndex);
    }

    return indices;
  }

  /// Previews available players for a configuration without creating a session
  Future<GameServiceResult<List<PlayerData>>> previewPlayers(
    GameConfig config, {
    int maxCount = 10,
  }) async {
    try {
      final playersResult = await _getPlayersForConfig(config);

      switch (playersResult) {
        case RepositoryFailure(:final message):
          return GameServiceError('Failed to preview players: $message');
        case RepositorySuccess(:final data):
          var players = data;

          // Limit the preview count
          if (players.length > maxCount) {
            players = players.take(maxCount).toList();
          }

          return GameServiceSuccess(players);
      }
    } catch (e) {
      return GameServiceError(
        'Error previewing players',
        e.toString(),
      );
    }
  }

  /// Validates if a configuration has enough players to start a game
  Future<GameServiceResult<bool>> validateConfigurationAsync(
    GameConfig config,
  ) async {
    try {
      // Basic validation
      final validationError = _validateGameConfig(config);
      if (validationError != null) {
        return GameServiceError(validationError);
      }

      // Check if enough players are available
      final playersResult = await _getPlayersForConfig(config);
      switch (playersResult) {
        case RepositoryFailure(:final message):
          return GameServiceError('Cannot validate configuration: $message');
        case RepositorySuccess(:final data):
          final availablePlayers = data;
          if (availablePlayers.isEmpty) {
            return const GameServiceError(
              'No players available for this configuration',
            );
          }

          // Ensure we have enough variety (at least 3 different players minimum)
          if (availablePlayers.length < 3) {
            return const GameServiceError(
              'Not enough player variety for a good game experience',
            );
          }

          return const GameServiceSuccess(true);
      }
    } catch (e) {
      return GameServiceError(
        'Error validating configuration',
        e.toString(),
      );
    }
  }

  /// Gets statistics about available players for different configurations
  Future<Map<FootballCategory, int>> getCategoryStatistics(
    Difficulty difficulty,
  ) async {
    final stats = <FootballCategory, int>{};

    for (final category in FootballCategory.values) {
      if (category == FootballCategory.custom) {
        final customResult = await playerRepository.getCustomPlayers();
        stats[category] = customResult.dataOrNull?.length ?? 0;
      } else {
        final result = await playerRepository.getPlayersForCategory(
          category: category,
          difficulty: difficulty,
        );
        stats[category] = result.dataOrNull?.length ?? 0;
      }
    }

    return stats;
  }

  /// Gets statistics about legends players
  Future<int> getLegendsStatistics(Difficulty difficulty) async {
    final result = await playerRepository.getLegendsPlayers(
      difficulty: difficulty,
    );
    return result.dataOrNull?.length ?? 0;
  }

  /// Creates a copy of the service with a specific random seed
  ///
  /// Useful for testing with deterministic behavior
  GameService withSeed(int seed) {
    return GameService(
      playerRepository: playerRepository,
      randomSeed: seed,
    );
  }

  /// Generates multiple game sessions for comparison (useful for testing)
  Future<List<GameSession>> generateMultipleSessions(
    GameConfig config,
    int count,
  ) async {
    final sessions = <GameSession>[];

    for (int i = 0; i < count; i++) {
      final result = await createGameSession(config);
      if (result is GameServiceSuccess<GameSession>) {
        sessions.add(result.data);
      }
    }

    return sessions;
  }
}

/// Extension methods for [GameServiceResult] to improve usability
extension GameServiceResultExtensions<T> on GameServiceResult<T> {
  /// Returns true if this is a successful result
  bool get isSuccess => this is GameServiceSuccess<T>;

  /// Returns true if this is an error result
  bool get isError => this is GameServiceError<T>;

  /// Returns the data if successful, null otherwise
  T? get dataOrNull {
    return switch (this) {
      GameServiceSuccess<T>(data: final data) => data,
      GameServiceError<T>() => null,
    };
  }

  /// Returns the error message if failed, null otherwise
  String? get errorOrNull {
    return switch (this) {
      GameServiceSuccess<T>() => null,
      GameServiceError<T>(message: final message) => message,
    };
  }

  /// Transforms the data if successful, preserves error otherwise
  GameServiceResult<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      GameServiceSuccess<T>(data: final data) =>
        GameServiceSuccess(transform(data)),
      GameServiceError<T>(message: final message, details: final details) =>
        GameServiceError(message, details),
    };
  }

  /// Executes a callback with the data if successful
  void ifSuccess(void Function(T data) callback) {
    if (this case GameServiceSuccess<T>(data: final data)) {
      callback(data);
    }
  }

  /// Executes a callback with the error if failed
  void ifError(void Function(String message, String? details) callback) {
    if (this
        case GameServiceError<T>(
          message: final message,
          details: final details
        )) {
      callback(message, details);
    }
  }
}
