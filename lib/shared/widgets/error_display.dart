/// Professional error display widget with retry functionality.
///
/// This widget provides a consistent way to display errors throughout
/// the application with optional retry functionality and proper
/// accessibility support.
///
/// Author: Professional Development Team
/// Version: 1.0.0

import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// A reusable error display widget
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.buttonText,
  });

  /// The error message to display
  final String message;

  /// Optional callback for retry functionality
  final VoidCallback? onRetry;

  /// Optional custom icon
  final IconData? icon;

  /// Optional custom button text
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.largeSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: UIConstants.extraLargeIconSize,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: UIConstants.normalSpacing),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: UIConstants.largeSpacing),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(buttonText ?? 'Reintentar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UIConstants.largeSpacing,
                    vertical: UIConstants.normalSpacing,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
