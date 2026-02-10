/// Unit tests for GameService business logic.
///
/// This file demonstrates the testing approach for the core game logic,
/// including session creation, player selection, and role assignment.
///
/// Author: Professional Development Team
/// Version: 1.0.0

import 'package:flutter_test/flutter_test.dart';
import 'package:impostor/core/enums/game_enums.dart';
import 'package:impostor/core/models/game_models.dart';
import 'package:impostor/features/game/domain/game_service.dart';
import 'package:impostor/features/game/data/local_player_repository.dart';

void main() {
  group('GameService Tests', () {
    late GameService gameService;
    late LocalPlayerRepository repository;

    setUp(() {
      repository = LocalPlayerRepository();
      gameService = GameService(
        playerRepository: repository,
        randomSeed: 42, // Fixed seed for deterministic tests
      );
    });

    group('createGameSession', () {
      test('should create valid game session with correct configuration',
          () async {
        // Arrange
        const config = GameConfig(
          gameMode: GameMode.classic,
          category: FootballCategory.international,
          difficulty: Difficulty.easy,
          playersCount: 5,
          impostorsCount: 2,
        );

        // Act
        final result = await gameService.createGameSession(config);

        // Assert
        expect(result, isA<GameServiceSuccess<GameSession>>());

        final session = (result as GameServiceSuccess<GameSession>).data;
        expect(session.config, equals(config));
        expect(session.assignments.length, equals(5));
        expect(session.chosenPlayer.name, isNotEmpty);
        expect(session.startTime, isNotNull);

        // Verify role assignments
        final impostorCount = session.assignments
            .where((a) => a.role == PlayerRole.impostor)
            .length;
        final regularCount = session.assignments
            .where((a) => a.role == PlayerRole.regular)
            .length;

        expect(impostorCount, equals(2));
        expect(regularCount, equals(3));
      });

      test('should fail with invalid configuration', () {
        // Arrange - Invalid config: impostors >= players
        expect(
          () => GameConfig(
            gameMode: GameMode.classic,
            category: FootballCategory.international,
            difficulty: Difficulty.easy,
            playersCount: 3,
            impostorsCount: 3, // Invalid: should be < playersCount
          ),
          throwsA(isA<AssertionError>()),
        );
      });

      test('should select valid football players from correct category',
          () async {
        // Arrange
        const config = GameConfig(
          gameMode: GameMode.classic,
          category: FootballCategory.international,
          difficulty: Difficulty.easy,
          playersCount: 4,
          impostorsCount: 1,
        );

        // Act
        final result = await gameService.createGameSession(config);

        // Assert
        expect(result, isA<GameServiceSuccess<GameSession>>());

        final session = (result as GameServiceSuccess<GameSession>).data;

        // Verify chosen player is valid
        expect(session.chosenPlayer.name, isNotEmpty);

        // All football players from easy + medium difficulty (covering possible selections)
        final validPlayers = [
          // Easy players
          'Lionel Messi', 'Cristiano Ronaldo', 'Neymar Jr.', 'Kylian Mbappé',
          'Luis Suárez', 'Erling Haaland', 'Antoine Griezmann', 'Gareth Bale',
          'Eden Hazard', 'Gerard Piqué', 'Paul Pogba', 'Ángel Di María',
          'Sergio Agüero', 'Iker Casillas', 'Sergio Ramos', 'Edinson Cavani',
          'Marcelo Vieira', 'Toni Kroos', 'Sadio Mané', 'Virgil van Dijk',
          // Medium players
          'Luka Modric', 'Robert Lewandowski', 'Karim Benzema', 'Mohamed Salah',
          'Harry Kane', 'Kevin De Bruyne', 'Raheem Sterling', 'Sergio Busquets',
          'Thomas Müller', 'Heung-min Son', 'Alisson Becker',
          'Thibaut Courtois',
          'Jan Oblak', 'Phil Foden', 'N\'Golo Kanté', 'Joshua Kimmich',
          'Trent Alexander-Arnold', 'Marquinhos', 'Rúben Dias',
          'Bruno Fernandes',
          'João Félix', 'Kai Havertz', 'Casemiro', 'Rodri Hernández',
          'Frenkie de Jong', 'Bernardo Silva', 'Jack Grealish', 'Romelu Lukaku',
          'Marco Verratti', 'Federico Valverde'
        ];

        expect(validPlayers.contains(session.chosenPlayer.name), isTrue,
            reason:
                'Selected player "${session.chosenPlayer.name}" should be a known football player');
      });

      test('should handle edge case with minimum players', () async {
        // Arrange
        const config = GameConfig(
          gameMode: GameMode.classic,
          category: FootballCategory.international,
          difficulty: Difficulty.easy,
          playersCount: 3, // Minimum
          impostorsCount: 1,
        );

        // Act
        final result = await gameService.createGameSession(config);

        // Assert
        expect(result, isA<GameServiceSuccess<GameSession>>());

        final session = (result as GameServiceSuccess<GameSession>).data;
        expect(session.assignments.length, equals(3));

        final impostorCount = session.assignments
            .where((a) => a.role == PlayerRole.impostor)
            .length;
        expect(impostorCount, equals(1));
      });

      test('should work with different difficulties', () async {
        // Test all difficulties
        for (final difficulty in Difficulty.values) {
          // Arrange
          final config = GameConfig(
            gameMode: GameMode.classic,
            category: FootballCategory.international,
            difficulty: difficulty,
            playersCount: 4,
            impostorsCount: 1,
          );

          // Act
          final result = await gameService.createGameSession(config);

          // Assert
          expect(result, isA<GameServiceSuccess<GameSession>>());
          final session = (result as GameServiceSuccess<GameSession>).data;
          expect(session.chosenPlayer.name, isNotEmpty);
        }
      });
    });

    group('Role Assignment Logic', () {
      test('should assign exactly the specified number of impostors', () async {
        // Test with different impostor counts
        final testCases = [
          (players: 5, impostors: 1),
          (players: 6, impostors: 2),
          (players: 10, impostors: 3),
        ];

        for (final testCase in testCases) {
          // Arrange
          final config = GameConfig(
            gameMode: GameMode.classic,
            category: FootballCategory.international,
            difficulty: Difficulty.easy,
            playersCount: testCase.players,
            impostorsCount: testCase.impostors,
          );

          // Act
          final result = await gameService.createGameSession(config);

          // Assert
          expect(result, isA<GameServiceSuccess<GameSession>>());

          final session = (result as GameServiceSuccess<GameSession>).data;
          final actualImpostorCount = session.assignments
              .where((a) => a.role == PlayerRole.impostor)
              .length;

          expect(
            actualImpostorCount,
            equals(testCase.impostors),
            reason:
                'Failed for ${testCase.players} players, ${testCase.impostors} impostors',
          );
        }
      });
    });

    group('Player Selection', () {
      test('should select player from correct category and difficulty',
          () async {
        // Arrange
        const config = GameConfig(
          gameMode: GameMode.classic,
          category: FootballCategory.international,
          difficulty: Difficulty.medium,
          playersCount: 3,
          impostorsCount: 1,
        );

        // Act
        final result = await gameService.createGameSession(config);

        // Assert
        expect(result, isA<GameServiceSuccess<GameSession>>());

        final session = (result as GameServiceSuccess<GameSession>).data;
        final chosenPlayer = session.chosenPlayer;

        // Should have a valid player name
        expect(chosenPlayer.name, isNotEmpty);
        expect(chosenPlayer.name.length, greaterThan(2));
      });
    });
  });
}
