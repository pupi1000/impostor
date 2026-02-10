/// Football players data organized by categories and difficulties.
///
/// This file contains the comprehensive database of football players
/// organized by different categories (leagues, competitions, etc.) and
/// difficulty levels. The data is structured to support the impostor
/// game mechanics while providing variety and appropriate challenge levels.
///
/// Data organization:
/// - Categories represent different football contexts
/// - Difficulties represent player recognition levels
/// - Each player entry includes rich metadata when available
///
/// Author: Professional Development Team
/// Version: 1.0.0

import '../../../core/enums/game_enums.dart';
import '../../../core/models/game_models.dart';

/// Static data provider for football players
abstract class FootballPlayersData {
  /// International players organized by difficulty
  static const Map<Difficulty, List<PlayerData>> _internationalPlayers = {
    Difficulty.easy: [
      PlayerData(
        name: 'Lionel Messi',
        team: 'Paris Saint-Germain',
        position: 'Delantero',
        nationality: 'Argentina',
        league: 'Ligue 1',
        rating: 95,
      ),
      PlayerData(
        name: 'Cristiano Ronaldo',
        team: 'Al Nassr',
        position: 'Delantero',
        nationality: 'Portugal',
        league: 'Saudi Pro League',
        rating: 94,
      ),
      PlayerData(
        name: 'Neymar Jr.',
        team: 'Al Hilal',
        position: 'Extremo',
        nationality: 'Brasil',
        league: 'Saudi Pro League',
        rating: 89,
      ),
      PlayerData(
        name: 'Kylian Mbappé',
        team: 'Paris Saint-Germain',
        position: 'Delantero',
        nationality: 'Francia',
        league: 'Ligue 1',
        rating: 93,
      ),
      PlayerData(
        name: 'Erling Haaland',
        team: 'Manchester City',
        position: 'Delantero',
        nationality: 'Noruega',
        league: 'Premier League',
        rating: 91,
      ),
      PlayerData(
        name: 'Kevin De Bruyne',
        team: 'Manchester City',
        position: 'Centrocampista',
        nationality: 'Bélgica',
        league: 'Premier League',
        rating: 90,
      ),
      PlayerData(
        name: 'Karim Benzema',
        team: 'Al Ittihad',
        position: 'Delantero',
        nationality: 'Francia',
        league: 'Saudi Pro League',
        rating: 88,
      ),
      PlayerData(
        name: 'Robert Lewandowski',
        team: 'FC Barcelona',
        position: 'Delantero',
        nationality: 'Polonia',
        league: 'La Liga',
        rating: 89,
      ),
      PlayerData(
        name: 'Mohamed Salah',
        team: 'Liverpool',
        position: 'Extremo',
        nationality: 'Egipto',
        league: 'Premier League',
        rating: 87,
      ),
      PlayerData(
        name: 'Sadio Mané',
        team: 'Al Nassr',
        position: 'Extremo',
        nationality: 'Senegal',
        league: 'Saudi Pro League',
        rating: 85,
      ),
    ],
    Difficulty.medium: [
      PlayerData(
        name: 'Luka Modrić',
        team: 'Real Madrid',
        position: 'Centrocampista',
        nationality: 'Croacia',
        league: 'La Liga',
        rating: 86,
      ),
      PlayerData(
        name: 'Virgil van Dijk',
        team: 'Liverpool',
        position: 'Defensa',
        nationality: 'Países Bajos',
        league: 'Premier League',
        rating: 88,
      ),
      PlayerData(
        name: 'Sergio Busquets',
        team: 'Inter Miami',
        position: 'Centrocampista',
        nationality: 'España',
        league: 'MLS',
        rating: 82,
      ),
      PlayerData(
        name: 'Thomas Müller',
        team: 'Bayern Munich',
        position: 'Centrocampista',
        nationality: 'Alemania',
        league: 'Bundesliga',
        rating: 84,
      ),
      PlayerData(
        name: 'Heung-min Son',
        team: 'Tottenham',
        position: 'Extremo',
        nationality: 'Corea del Sur',
        league: 'Premier League',
        rating: 85,
      ),
      PlayerData(
        name: 'Alisson Becker',
        team: 'Liverpool',
        position: 'Portero',
        nationality: 'Brasil',
        league: 'Premier League',
        rating: 87,
      ),
      PlayerData(
        name: 'Thibaut Courtois',
        team: 'Real Madrid',
        position: 'Portero',
        nationality: 'Bélgica',
        league: 'La Liga',
        rating: 86,
      ),
      PlayerData(
        name: 'Jan Oblak',
        team: 'Atlético Madrid',
        position: 'Portero',
        nationality: 'Eslovenia',
        league: 'La Liga',
        rating: 87,
      ),
      PlayerData(
        name: 'Phil Foden',
        team: 'Manchester City',
        position: 'Centrocampista',
        nationality: 'Inglaterra',
        league: 'Premier League',
        rating: 84,
      ),
      PlayerData(
        name: 'NGolo Kanté',
        team: 'Al Ittihad',
        position: 'Centrocampista',
        nationality: 'Francia',
        league: 'Saudi Pro League',
        rating: 83,
      ),
    ],
    Difficulty.hard: [
      PlayerData(
        name: 'Paulo Dybala',
        team: 'AS Roma',
        position: 'Centrocampista',
        nationality: 'Argentina',
        league: 'Serie A',
        rating: 83,
      ),
      PlayerData(
        name: 'Riyad Mahrez',
        team: 'Al Ahli',
        position: 'Extremo',
        nationality: 'Argelia',
        league: 'Saudi Pro League',
        rating: 82,
      ),
      PlayerData(
        name: 'Khvicha Kvaratskhelia',
        team: 'Napoli',
        position: 'Extremo',
        nationality: 'Georgia',
        league: 'Serie A',
        rating: 84,
      ),
      PlayerData(
        name: 'Enzo Fernández',
        team: 'Chelsea',
        position: 'Centrocampista',
        nationality: 'Argentina',
        league: 'Premier League',
        rating: 82,
      ),
      PlayerData(
        name: 'Federico Chiesa',
        team: 'Juventus',
        position: 'Extremo',
        nationality: 'Italia',
        league: 'Serie A',
        rating: 81,
      ),
      PlayerData(
        name: 'Sandro Tonali',
        team: 'Newcastle',
        position: 'Centrocampista',
        nationality: 'Italia',
        league: 'Premier League',
        rating: 80,
      ),
      PlayerData(
        name: 'Nicolò Barella',
        team: 'Inter Milan',
        position: 'Centrocampista',
        nationality: 'Italia',
        league: 'Serie A',
        rating: 83,
      ),
      PlayerData(
        name: 'Raphinha',
        team: 'FC Barcelona',
        position: 'Extremo',
        nationality: 'Brasil',
        league: 'La Liga',
        rating: 81,
      ),
      PlayerData(
        name: 'Gabriel Martinelli',
        team: 'Arsenal',
        position: 'Extremo',
        nationality: 'Brasil',
        league: 'Premier League',
        rating: 79,
      ),
      PlayerData(
        name: 'Dušan Vlahović',
        team: 'Juventus',
        position: 'Delantero',
        nationality: 'Serbia',
        league: 'Serie A',
        rating: 82,
      ),
    ],
  };

  /// League-specific players
  static const Map<Difficulty, List<PlayerData>> _leaguePlayers = {
    Difficulty.easy: [
      // Premier League stars
      PlayerData(
        name: 'Harry Kane',
        team: 'Bayern Munich',
        position: 'Delantero',
        nationality: 'Inglaterra',
        league: 'Bundesliga',
        rating: 89,
      ),
      PlayerData(
        name: 'Erling Haaland',
        team: 'Manchester City',
        position: 'Delantero',
        nationality: 'Noruega',
        league: 'Premier League',
        rating: 91,
      ),
      // La Liga
      PlayerData(
        name: 'Vinícius Jr.',
        team: 'Real Madrid',
        position: 'Extremo',
        nationality: 'Brasil',
        league: 'La Liga',
        rating: 86,
      ),
      PlayerData(
        name: 'Pedri',
        team: 'FC Barcelona',
        position: 'Centrocampista',
        nationality: 'España',
        league: 'La Liga',
        rating: 83,
      ),
    ],
    Difficulty.medium: [
      PlayerData(
        name: 'Bruno Fernandes',
        team: 'Manchester United',
        position: 'Centrocampista',
        nationality: 'Portugal',
        league: 'Premier League',
        rating: 85,
      ),
      PlayerData(
        name: 'João Félix',
        team: 'Atlético Madrid',
        position: 'Delantero',
        nationality: 'Portugal',
        league: 'La Liga',
        rating: 82,
      ),
    ],
    Difficulty.hard: [
      PlayerData(
        name: 'Kai Havertz',
        team: 'Arsenal',
        position: 'Centrocampista',
        nationality: 'Alemania',
        league: 'Premier League',
        rating: 81,
      ),
      PlayerData(
        name: 'Casemiro',
        team: 'Manchester United',
        position: 'Centrocampista',
        nationality: 'Brasil',
        league: 'Premier League',
        rating: 84,
      ),
    ],
  };

  /// Cup competition specialists
  static const Map<Difficulty, List<PlayerData>> _cupPlayers = {
    Difficulty.easy: [
      PlayerData(
        name: 'Lionel Messi',
        team: 'Paris Saint-Germain',
        position: 'Delantero',
        nationality: 'Argentina',
        league: 'Ligue 1',
        rating: 95,
        era: 'Champions League Legend',
      ),
      PlayerData(
        name: 'Cristiano Ronaldo',
        team: 'Al Nassr',
        position: 'Delantero',
        nationality: 'Portugal',
        league: 'Saudi Pro League',
        rating: 94,
        era: 'Champions League Record Holder',
      ),
    ],
    Difficulty.medium: [
      PlayerData(
        name: 'Luka Modrić',
        team: 'Real Madrid',
        position: 'Centrocampista',
        nationality: 'Croacia',
        league: 'La Liga',
        rating: 86,
        era: 'Champions League Winner',
      ),
    ],
    Difficulty.hard: [
      PlayerData(
        name: 'Federico Valverde',
        team: 'Real Madrid',
        position: 'Centrocampista',
        nationality: 'Uruguay',
        league: 'La Liga',
        rating: 83,
      ),
    ],
  };

  /// National team representatives
  static const Map<Difficulty, List<PlayerData>> _nationalTeamPlayers = {
    Difficulty.easy: [
      // Argentina
      PlayerData(
        name: 'Lionel Messi',
        team: 'Paris Saint-Germain',
        position: 'Delantero',
        nationality: 'Argentina',
        league: 'Ligue 1',
        rating: 95,
      ),
      PlayerData(
        name: 'Ángel Di María',
        team: 'Benfica',
        position: 'Extremo',
        nationality: 'Argentina',
        league: 'Primeira Liga',
        rating: 83,
      ),
      // Brasil
      PlayerData(
        name: 'Neymar Jr.',
        team: 'Al Hilal',
        position: 'Extremo',
        nationality: 'Brasil',
        league: 'Saudi Pro League',
        rating: 89,
      ),
      PlayerData(
        name: 'Casemiro',
        team: 'Manchester United',
        position: 'Centrocampista',
        nationality: 'Brasil',
        league: 'Premier League',
        rating: 84,
      ),
    ],
    Difficulty.medium: [
      PlayerData(
        name: 'Rodrigo De Paul',
        team: 'Atlético Madrid',
        position: 'Centrocampista',
        nationality: 'Argentina',
        league: 'La Liga',
        rating: 81,
      ),
      PlayerData(
        name: 'Vinícius Jr.',
        team: 'Real Madrid',
        position: 'Extremo',
        nationality: 'Brasil',
        league: 'La Liga',
        rating: 86,
      ),
    ],
    Difficulty.hard: [
      PlayerData(
        name: 'Julián Álvarez',
        team: 'Manchester City',
        position: 'Delantero',
        nationality: 'Argentina',
        league: 'Premier League',
        rating: 80,
      ),
      PlayerData(
        name: 'Alexis Mac Allister',
        team: 'Liverpool',
        position: 'Centrocampista',
        nationality: 'Argentina',
        league: 'Premier League',
        rating: 79,
      ),
    ],
  };

  /// Players by different eras/seasons
  static const Map<Difficulty, List<PlayerData>> _seasonPlayers = {
    Difficulty.easy: [
      PlayerData(
        name: 'Jude Bellingham',
        team: 'Real Madrid',
        position: 'Centrocampista',
        nationality: 'Inglaterra',
        league: 'La Liga',
        rating: 86,
        era: '2023-2024 Breakthrough',
      ),
      PlayerData(
        name: 'Erling Haaland',
        team: 'Manchester City',
        position: 'Delantero',
        nationality: 'Noruega',
        league: 'Premier League',
        rating: 91,
        era: '2022-2023 Record Breaker',
      ),
    ],
    Difficulty.medium: [
      PlayerData(
        name: 'Jamal Musiala',
        team: 'Bayern Munich',
        position: 'Centrocampista',
        nationality: 'Alemania',
        league: 'Bundesliga',
        rating: 82,
        era: 'New Generation',
      ),
      PlayerData(
        name: 'Pedri',
        team: 'FC Barcelona',
        position: 'Centrocampista',
        nationality: 'España',
        league: 'La Liga',
        rating: 83,
        era: 'Barcelona Golden Boy',
      ),
    ],
    Difficulty.hard: [
      PlayerData(
        name: 'Florian Wirtz',
        team: 'Bayer Leverkusen',
        position: 'Centrocampista',
        nationality: 'Alemania',
        league: 'Bundesliga',
        rating: 79,
        era: 'Rising Star',
      ),
      PlayerData(
        name: 'Ansu Fati',
        team: 'FC Barcelona',
        position: 'Extremo',
        nationality: 'España',
        league: 'La Liga',
        rating: 77,
        era: 'Barcelona Wonderkid',
      ),
    ],
  };

  /// Legends players organized by difficulty
  static const Map<Difficulty, List<PlayerData>> _legendsPlayers = {
    Difficulty.easy: [
      PlayerData(
        name: 'Pelé',
        team: 'Santos/Brasil',
        position: 'Delantero',
        nationality: 'Brasil',
        rating: 99,
        era: '1960-1970s',
        isActive: false,
      ),
      PlayerData(
        name: 'Diego Maradona',
        team: 'Argentina',
        position: 'Centrocampista',
        nationality: 'Argentina',
        rating: 98,
        era: '1980s',
        isActive: false,
      ),
      PlayerData(
        name: 'Johan Cruyff',
        team: 'Ajax/Barcelona',
        position: 'Delantero',
        nationality: 'Países Bajos',
        rating: 96,
        era: '1970s',
        isActive: false,
      ),
      PlayerData(
        name: 'Franz Beckenbauer',
        team: 'Bayern Munich',
        position: 'Defensa',
        nationality: 'Alemania',
        rating: 95,
        era: '1970s',
        isActive: false,
      ),
    ],
    Difficulty.medium: [
      PlayerData(
        name: 'Roberto Baggio',
        team: 'Juventus/Italia',
        position: 'Centrocampista',
        nationality: 'Italia',
        rating: 94,
        era: '1990s',
        isActive: false,
      ),
      PlayerData(
        name: 'Zinedine Zidane',
        team: 'Real Madrid',
        position: 'Centrocampista',
        nationality: 'Francia',
        rating: 95,
        era: '1990s-2000s',
        isActive: false,
      ),
      PlayerData(
        name: 'Ronaldo Nazário',
        team: 'Brasil',
        position: 'Delantero',
        nationality: 'Brasil',
        rating: 96,
        era: '1990s-2000s',
        isActive: false,
      ),
    ],
    Difficulty.hard: [
      PlayerData(
        name: 'Francesco Totti',
        team: 'AS Roma',
        position: 'Centrocampista',
        nationality: 'Italia',
        rating: 91,
        era: '1990s-2010s',
        isActive: false,
      ),
      PlayerData(
        name: 'Pavel Nedvěd',
        team: 'Juventus',
        position: 'Centrocampista',
        nationality: 'República Checa',
        rating: 90,
        era: '1990s-2000s',
        isActive: false,
      ),
    ],
  };

  /// Gets players for a specific category and difficulty
  static List<PlayerData> getPlayersForCategory(
    FootballCategory category,
    Difficulty difficulty,
  ) {
    switch (category) {
      case FootballCategory.international:
        return _internationalPlayers[difficulty] ?? [];
      case FootballCategory.leagues:
        return _leaguePlayers[difficulty] ?? [];
      case FootballCategory.cups:
        return _cupPlayers[difficulty] ?? [];
      case FootballCategory.nationalTeams:
        return _nationalTeamPlayers[difficulty] ?? [];
      case FootballCategory.seasons:
        return _seasonPlayers[difficulty] ?? [];
      case FootballCategory.custom:
        return []; // Custom players are handled by repository
    }
  }

  /// Gets legends players for a specific difficulty
  static List<PlayerData> getLegendsPlayers(Difficulty difficulty) {
    return _legendsPlayers[difficulty] ?? [];
  }

  /// Gets all players for a category across all difficulties
  static List<PlayerData> getAllPlayersForCategory(FootballCategory category) {
    final allPlayers = <PlayerData>[];
    for (final difficulty in Difficulty.values) {
      allPlayers.addAll(getPlayersForCategory(category, difficulty));
    }
    return allPlayers;
  }

  /// Gets all legends players across all difficulties
  static List<PlayerData> getAllLegendsPlayers() {
    final allPlayers = <PlayerData>[];
    for (final difficulty in Difficulty.values) {
      allPlayers.addAll(getLegendsPlayers(difficulty));
    }
    return allPlayers;
  }

  /// Gets a summary of available players per category and difficulty
  static Map<FootballCategory, Map<Difficulty, int>> getPlayerCounts() {
    final counts = <FootballCategory, Map<Difficulty, int>>{};

    for (final category in FootballCategory.values) {
      if (category == FootballCategory.custom) continue;

      counts[category] = {};
      for (final difficulty in Difficulty.values) {
        counts[category]![difficulty] =
            getPlayersForCategory(category, difficulty).length;
      }
    }

    return counts;
  }

  /// Gets legends player counts by difficulty
  static Map<Difficulty, int> getLegendsPlayerCounts() {
    final counts = <Difficulty, int>{};
    for (final difficulty in Difficulty.values) {
      counts[difficulty] = getLegendsPlayers(difficulty).length;
    }
    return counts;
  }
}
