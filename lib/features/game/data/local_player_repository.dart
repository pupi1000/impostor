/// Concrete implementation of PlayerRepository using local data.
///
/// This implementation provides player data from predefined lists
/// organized by categories and difficulties. It serves as the
/// primary data source for the football impostor game.
///
/// Features:
/// - Category-based player organization
/// - Difficulty-based filtering
/// - Custom player list management
/// - Efficient data access patterns
/// - Error handling and validation
///
/// Author: Professional Development Team
/// Version: 1.0.0

import 'dart:math';
import '../../../core/enums/game_enums.dart';
import '../../../core/models/game_models.dart';
import '../domain/player_repository.dart';
import 'football_players_data.dart';

/// Local implementation of [PlayerRepository]
class LocalPlayerRepository implements PlayerRepository {
  /// Creates a new instance of [LocalPlayerRepository]
  LocalPlayerRepository({
    Random? randomGenerator,
  }) : _random = randomGenerator ?? Random();

  final Random _random;
  final List<PlayerData> _customPlayers = [];

  @override
  Future<RepositoryResult<List<PlayerData>>> getPlayersForCategory({
    required FootballCategory category,
    required Difficulty difficulty,
  }) async {
    try {
      // Simulate async operation
      await Future.delayed(const Duration(milliseconds: 50));

      if (category == FootballCategory.custom) {
        return RepositorySuccess(_customPlayers);
      }

      final players = FootballPlayersData.getPlayersForCategory(
        category,
        difficulty,
      );

      if (players.isEmpty) {
        return const RepositoryFailure(
          'No players found for the specified category and difficulty',
        );
      }

      return RepositorySuccess(players);
    } catch (e, stackTrace) {
      return RepositoryFailure(
        'Failed to load players for category: ${category.displayName}',
        Exception('Error: $e\nStack: $stackTrace'),
      );
    }
  }

  @override
  Future<RepositoryResult<List<PlayerData>>> getLegendsPlayers({
    required Difficulty difficulty,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));

      final players = FootballPlayersData.getLegendsPlayers(difficulty);

      if (players.isEmpty) {
        return const RepositoryFailure(
          'No legends players found for the specified difficulty',
        );
      }

      return RepositorySuccess(players);
    } catch (e, stackTrace) {
      return RepositoryFailure(
        'Failed to load legends players',
        Exception('Error: $e\nStack: $stackTrace'),
      );
    }
  }

  @override
  Future<RepositoryResult<List<PlayerData>>> getCustomPlayers() async {
    try {
      await Future.delayed(const Duration(milliseconds: 30));
      return RepositorySuccess(List.unmodifiable(_customPlayers));
    } catch (e, stackTrace) {
      return RepositoryFailure(
        'Failed to load custom players',
        Exception('Error: $e\nStack: $stackTrace'),
      );
    }
  }

  @override
  Future<RepositoryResult<void>> saveCustomPlayers(
      List<PlayerData> players) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      _customPlayers.clear();
      _customPlayers.addAll(players);

      return const RepositorySuccess(null);
    } catch (e, stackTrace) {
      return RepositoryFailure(
        'Failed to save custom players',
        Exception('Error: $e\nStack: $stackTrace'),
      );
    }
  }

  @override
  Future<RepositoryResult<void>> addCustomPlayer(PlayerData player) async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));

      // Check if player already exists
      if (_customPlayers
          .any((p) => p.name.toLowerCase() == player.name.toLowerCase())) {
        return const RepositoryFailure('Player with this name already exists');
      }

      _customPlayers.add(player);
      return const RepositorySuccess(null);
    } catch (e, stackTrace) {
      return RepositoryFailure(
        'Failed to add custom player: ${player.name}',
        Exception('Error: $e\nStack: $stackTrace'),
      );
    }
  }

  @override
  Future<RepositoryResult<void>> removeCustomPlayer(String playerName) async {
    try {
      await Future.delayed(const Duration(milliseconds: 50));

      final removedCount = _customPlayers.length;
      _customPlayers.removeWhere(
        (player) => player.name.toLowerCase() == playerName.toLowerCase(),
      );

      if (_customPlayers.length == removedCount) {
        return const RepositoryFailure('Player not found in custom list');
      }

      return const RepositorySuccess(null);
    } catch (e, stackTrace) {
      return RepositoryFailure(
        'Failed to remove custom player: $playerName',
        Exception('Error: $e\nStack: $stackTrace'),
      );
    }
  }

  @override
  Future<bool> hasPLayersForCategory({
    required FootballCategory category,
    required Difficulty difficulty,
  }) async {
    final result = await getPlayersForCategory(
      category: category,
      difficulty: difficulty,
    );
    return result.isSuccess && (result.dataOrNull?.isNotEmpty ?? false);
  }

  @override
  Future<int> getPlayerCountForCategory({
    required FootballCategory category,
    required Difficulty difficulty,
  }) async {
    final result = await getPlayersForCategory(
      category: category,
      difficulty: difficulty,
    );
    return result.dataOrNull?.length ?? 0;
  }

  @override
  Future<bool> hasEnoughPlayers({
    required FootballCategory category,
    required Difficulty difficulty,
    required int minimumPlayers,
  }) async {
    final count = await getPlayerCountForCategory(
      category: category,
      difficulty: difficulty,
    );
    return count >= minimumPlayers;
  }

  @override
  Future<RepositoryResult<List<PlayerData>>> searchPlayers({
    required String query,
    FootballCategory? category,
    Difficulty? difficulty,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      if (query.trim().isEmpty) {
        return const RepositorySuccess([]);
      }

      final lowercaseQuery = query.toLowerCase();
      List<PlayerData> allPlayers = [];

      if (category != null && difficulty != null) {
        final result = await getPlayersForCategory(
          category: category,
          difficulty: difficulty,
        );
        if (result.isSuccess) {
          allPlayers = result.dataOrNull ?? [];
        }
      } else {
        // Search across all categories and difficulties
        for (final cat in FootballCategory.values) {
          if (cat == FootballCategory.custom) {
            allPlayers.addAll(_customPlayers);
            continue;
          }

          for (final diff in Difficulty.values) {
            final result = await getPlayersForCategory(
              category: cat,
              difficulty: diff,
            );
            if (result.isSuccess) {
              allPlayers.addAll(result.dataOrNull ?? []);
            }
          }
        }
      }

      final matchingPlayers = allPlayers.where((player) {
        return player.name.toLowerCase().contains(lowercaseQuery) ||
            (player.team?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (player.nationality?.toLowerCase().contains(lowercaseQuery) ??
                false);
      }).toList();

      // Remove duplicates based on name
      final uniquePlayers = <String, PlayerData>{};
      for (final player in matchingPlayers) {
        uniquePlayers[player.name.toLowerCase()] = player;
      }

      return RepositorySuccess(uniquePlayers.values.toList());
    } catch (e, stackTrace) {
      return RepositoryFailure(
        'Failed to search players with query: $query',
        Exception('Error: $e\nStack: $stackTrace'),
      );
    }
  }

  @override
  Future<RepositoryResult<List<PlayerData>>> getRandomPlayers({
    required FootballCategory category,
    required Difficulty difficulty,
    int count = 5,
  }) async {
    try {
      final result = await getPlayersForCategory(
        category: category,
        difficulty: difficulty,
      );

      if (result.isFailure) {
        return result;
      }

      final allPlayers = result.dataOrNull ?? [];
      if (allPlayers.isEmpty) {
        return const RepositorySuccess([]);
      }

      final shuffledPlayers = List<PlayerData>.from(allPlayers)
        ..shuffle(_random);
      final selectedCount = count.clamp(0, shuffledPlayers.length);

      return RepositorySuccess(shuffledPlayers.take(selectedCount).toList());
    } catch (e, stackTrace) {
      return RepositoryFailure(
        'Failed to get random players',
        Exception('Error: $e\nStack: $stackTrace'),
      );
    }
  }

  /// Utility method to get all available categories with player counts
  Future<Map<FootballCategory, int>> getCategorySummary(
      Difficulty difficulty) async {
    final summary = <FootballCategory, int>{};

    for (final category in FootballCategory.values) {
      final count = await getPlayerCountForCategory(
        category: category,
        difficulty: difficulty,
      );
      summary[category] = count;
    }

    return summary;
  }

  /// Utility method to preload commonly used data
  Future<void> warmUpCache() async {
    // Preload most common categories
    final commonCategories = [
      FootballCategory.international,
      FootballCategory.leagues,
      FootballCategory.nationalTeams,
    ];

    for (final category in commonCategories) {
      for (final difficulty in Difficulty.values) {
        await getPlayersForCategory(
          category: category,
          difficulty: difficulty,
        );
      }
    }

    // Preload legends
    for (final difficulty in Difficulty.values) {
      await getLegendsPlayers(difficulty: difficulty);
    }
  }
}
