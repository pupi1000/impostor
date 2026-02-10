/// Abstract repository interface for player data access.
///
/// This interface defines the contract for accessing player data
/// from various sources. It follows the Repository pattern to
/// decouple data access from business logic.
///
/// Implementations can provide data from:
/// - Local assets
/// - Remote APIs
/// - Local databases
/// - User-defined custom lists
///
/// Author: Professional Development Team
/// Version: 1.0.0

import '../../../core/enums/game_enums.dart';
import '../../../core/models/game_models.dart';

/// Result wrapper for repository operations
sealed class RepositoryResult<T> {
  const RepositoryResult();
}

/// Successful result with data
final class RepositorySuccess<T> extends RepositoryResult<T> {
  const RepositorySuccess(this.data);
  final T data;
}

/// Failed result with error information
final class RepositoryFailure<T> extends RepositoryResult<T> {
  const RepositoryFailure(this.message, [this.exception]);
  final String message;
  final Exception? exception;
}

/// Repository interface for player data operations
abstract interface class PlayerRepository {
  /// Retrieves players for the specified category and difficulty
  ///
  /// Returns a [RepositoryResult] containing either:
  /// - [RepositorySuccess] with a list of [PlayerData]
  /// - [RepositoryFailure] with error information
  Future<RepositoryResult<List<PlayerData>>> getPlayersForCategory({
    required FootballCategory category,
    required Difficulty difficulty,
  });

  /// Retrieves all players for the legends mode
  ///
  /// Returns a [RepositoryResult] containing either:
  /// - [RepositorySuccess] with a list of [PlayerData] for legends
  /// - [RepositoryFailure] with error information
  Future<RepositoryResult<List<PlayerData>>> getLegendsPlayers({
    required Difficulty difficulty,
  });

  /// Retrieves custom players defined by the user
  ///
  /// Returns a [RepositoryResult] containing either:
  /// - [RepositorySuccess] with user-defined [PlayerData] list
  /// - [RepositoryFailure] with error information
  Future<RepositoryResult<List<PlayerData>>> getCustomPlayers();

  /// Saves custom players to persistent storage
  ///
  /// Returns a [RepositoryResult] indicating success or failure
  Future<RepositoryResult<void>> saveCustomPlayers(List<PlayerData> players);

  /// Adds a single custom player
  ///
  /// Returns a [RepositoryResult] indicating success or failure
  Future<RepositoryResult<void>> addCustomPlayer(PlayerData player);

  /// Removes a custom player by name
  ///
  /// Returns a [RepositoryResult] indicating success or failure
  Future<RepositoryResult<void>> removeCustomPlayer(String playerName);

  /// Checks if a category has available players
  ///
  /// Returns true if the category contains players for the given difficulty
  Future<bool> hasPLayersForCategory({
    required FootballCategory category,
    required Difficulty difficulty,
  });

  /// Gets the total count of players for a category
  ///
  /// Returns the number of available players or 0 if category is empty
  Future<int> getPlayerCountForCategory({
    required FootballCategory category,
    required Difficulty difficulty,
  });

  /// Validates that a category has enough players for the game
  ///
  /// Returns true if the category has at least [minimumPlayers] available
  Future<bool> hasEnoughPlayers({
    required FootballCategory category,
    required Difficulty difficulty,
    required int minimumPlayers,
  });

  /// Searches for players by name or other criteria
  ///
  /// Returns a [RepositoryResult] with matching players
  Future<RepositoryResult<List<PlayerData>>> searchPlayers({
    required String query,
    FootballCategory? category,
    Difficulty? difficulty,
  });

  /// Gets random players from a category (for preview purposes)
  ///
  /// Returns a [RepositoryResult] with up to [count] random players
  Future<RepositoryResult<List<PlayerData>>> getRandomPlayers({
    required FootballCategory category,
    required Difficulty difficulty,
    int count = 5,
  });
}

/// Extension methods for [RepositoryResult] to improve usability
extension RepositoryResultExtensions<T> on RepositoryResult<T> {
  /// Returns true if this is a successful result
  bool get isSuccess => this is RepositorySuccess<T>;

  /// Returns true if this is a failure result
  bool get isFailure => this is RepositoryFailure<T>;

  /// Returns the data if successful, null otherwise
  T? get dataOrNull {
    return switch (this) {
      RepositorySuccess<T>(data: final data) => data,
      RepositoryFailure<T>() => null,
    };
  }

  /// Returns the error message if failed, null otherwise
  String? get errorOrNull {
    return switch (this) {
      RepositorySuccess<T>() => null,
      RepositoryFailure<T>(message: final message) => message,
    };
  }

  /// Transforms the data if successful, preserves failure otherwise
  RepositoryResult<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      RepositorySuccess<T>(data: final data) =>
        RepositorySuccess(transform(data)),
      RepositoryFailure<T>(
        message: final message,
        exception: final exception
      ) =>
        RepositoryFailure(message, exception),
    };
  }

  /// Executes a callback with the data if successful
  void ifSuccess(void Function(T data) callback) {
    if (this case RepositorySuccess<T>(data: final data)) {
      callback(data);
    }
  }

  /// Executes a callback with the error if failed
  void ifFailure(void Function(String message, Exception? exception) callback) {
    if (this
        case RepositoryFailure<T>(
          message: final message,
          exception: final exception
        )) {
      callback(message, exception);
    }
  }
}
