/// Preview dialog for football categories showing sample players.
///
/// This dialog provides a preview of players available in a specific
/// category, allowing users to see what types of players they'll
/// encounter before making their selection.
///
/// Author: Professional Development Team
/// Version: 1.0.0

import 'package:flutter/material.dart';
import '../../../../core/enums/game_enums.dart';
import '../../../../core/models/game_models.dart';
import '../../../../core/constants/app_constants.dart';

/// Dialog for previewing category players
class CategoryPreviewDialog extends StatelessWidget {
  const CategoryPreviewDialog({
    super.key,
    required this.category,
    required this.players,
    this.onSelectCategory,
  });

  /// The category being previewed
  final FootballCategory category;

  /// List of sample players to display
  final List<PlayerData> players;

  /// Callback when user selects this category
  final VoidCallback? onSelectCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.normalRadius),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(theme),
            _buildPlayerList(theme),
            _buildActions(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.largeSpacing),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(UIConstants.normalRadius),
          topRight: Radius.circular(UIConstants.normalRadius),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                category.icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: UIConstants.normalSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.displayName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      category.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer
                            .withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerList(ThemeData theme) {
    if (players.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(UIConstants.largeSpacing),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              size: UIConstants.extraLargeIconSize,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: UIConstants.normalSpacing),
            Text(
              'No hay jugadores disponibles para mostrar en esta categoría.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.largeSpacing,
          vertical: UIConstants.normalSpacing,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jugadores de ejemplo:',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: UIConstants.normalSpacing),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: players.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: UIConstants.smallSpacing),
                itemBuilder: (context, index) {
                  final player = players[index];
                  return _buildPlayerItem(player, theme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerItem(PlayerData player, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.normalSpacing),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(UIConstants.smallRadius),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              player.name.substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: UIConstants.normalSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (player.additionalInfo != null) ...[
                  const SizedBox(height: UIConstants.tinySpacing),
                  Text(
                    player.additionalInfo!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (player.rating != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.smallSpacing,
                vertical: UIConstants.tinySpacing,
              ),
              decoration: BoxDecoration(
                color: _getRatingColor(player.rating!, theme),
                borderRadius: BorderRadius.circular(UIConstants.smallRadius),
              ),
              child: Text(
                '${player.rating}',
                style: TextStyle(
                  fontSize: UIConstants.smallFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getRatingColor(int rating, ThemeData theme) {
    if (rating >= 90) return ColorConstants.successColor;
    if (rating >= 80) return ColorConstants.primaryBlue;
    if (rating >= 70) return ColorConstants.warningColor;
    return theme.colorScheme.outline;
  }

  Widget _buildActions(ThemeData theme) {
    return Builder(
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(UIConstants.largeSpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: UIConstants.normalSpacing),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onSelectCategory?.call();
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Seleccionar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UIConstants.largeSpacing,
                    vertical: UIConstants.normalSpacing,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
