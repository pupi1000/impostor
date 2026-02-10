/// Professional category card widget for football categories.
///
/// This widget displays football category information with player counts,
/// preview functionality, and smooth animations. It follows Material 3
/// design principles and provides excellent accessibility support.
///
/// Author: Professional Development Team
/// Version: 1.0.0

import 'package:flutter/material.dart';
import '../../../../core/enums/game_enums.dart';
import '../../../../core/constants/app_constants.dart';

/// A card widget for displaying football category information
class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.playerCount,
    required this.onTap,
    this.onPreview,
    this.isLoading = false,
  });

  /// The football category to display
  final FootballCategory category;

  /// Number of players in this category
  final int playerCount;

  /// Callback when card is tapped
  final VoidCallback onTap;

  /// Optional callback for preview functionality
  final VoidCallback? onPreview;

  /// Whether the card is in loading state
  final bool isLoading;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: UIConstants.fastAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: UIConstants.normalElevation,
      end: UIConstants.highElevation,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface;

    return Semantics(
      button: true,
      label: '${widget.category.displayName}. ${widget.category.description}. '
          '${widget.playerCount} jugadores disponibles.',
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              color: cardColor,
              elevation: _elevationAnimation.value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UIConstants.normalRadius),
                side: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                  width: 1.0,
                ),
              ),
              child: child,
            ),
          );
        },
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(UIConstants.largeSpacing),
            child: Row(
              children: [
                _buildCategoryIcon(theme),
                const SizedBox(width: UIConstants.normalSpacing),
                Expanded(child: _buildCategoryInfo(textColor)),
                _buildActions(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(ThemeData theme) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(UIConstants.normalRadius),
      ),
      child: Center(
        child: Text(
          widget.category.icon,
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }

  Widget _buildCategoryInfo(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.category.displayName,
          style: TextStyle(
            fontSize: UIConstants.largeFontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: UIConstants.tinySpacing),
        Text(
          widget.category.subtitle,
          style: TextStyle(
            fontSize: UIConstants.normalFontSize,
            color: textColor.withOpacity(UIConstants.highOpacity),
          ),
        ),
        const SizedBox(height: UIConstants.smallSpacing),
        _buildPlayerCount(textColor),
        const SizedBox(height: UIConstants.tinySpacing),
        if (_shouldShowAvailabilityInfo()) _buildAvailabilityInfo(textColor),
      ],
    );
  }

  Widget _buildPlayerCount(Color textColor) {
    if (widget.isLoading) {
      return Row(
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: textColor.withOpacity(UIConstants.mediumOpacity),
            ),
          ),
          const SizedBox(width: UIConstants.smallSpacing),
          Text(
            'Cargando...',
            style: TextStyle(
              fontSize: UIConstants.smallFontSize,
              color: textColor.withOpacity(UIConstants.mediumOpacity),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Icon(
          Icons.people,
          size: UIConstants.smallIconSize,
          color: textColor.withOpacity(UIConstants.mediumOpacity),
        ),
        const SizedBox(width: UIConstants.tinySpacing),
        Text(
          '${widget.playerCount} jugadores',
          style: TextStyle(
            fontSize: UIConstants.smallFontSize,
            color: textColor.withOpacity(UIConstants.mediumOpacity),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityInfo(Color textColor) {
    final isAvailable = widget.playerCount >= GameConstants.minCustomPlayers;
    final color =
        isAvailable ? ColorConstants.successColor : ColorConstants.warningColor;
    final text = isAvailable ? 'Disponible' : 'Limitado';

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: UIConstants.tinySpacing),
        Text(
          text,
          style: TextStyle(
            fontSize: UIConstants.smallFontSize,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(ThemeData theme) {
    return Column(
      children: [
        if (widget.onPreview != null)
          IconButton(
            tooltip: 'Vista previa',
            icon: const Icon(Icons.visibility),
            onPressed: widget.onPreview,
            style: IconButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
        Icon(
          Icons.arrow_forward_ios,
          color: theme.colorScheme.onSurface
              .withOpacity(UIConstants.mediumOpacity),
          size: UIConstants.normalIconSize,
        ),
      ],
    );
  }

  bool _shouldShowAvailabilityInfo() {
    return widget.category != FootballCategory.custom && !widget.isLoading;
  }
}
