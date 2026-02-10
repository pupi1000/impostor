/// Loading overlay widget for async operations.
///
/// This widget provides a consistent loading overlay that can be
/// used throughout the application for async operations.
///
/// Author: Professional Development Team
/// Version: 1.0.0

import 'package:flutter/material.dart';

/// A reusable loading overlay widget
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    this.message,
    this.isVisible = true,
    this.child,
  });

  /// Optional loading message
  final String? message;

  /// Whether the overlay is visible
  final bool isVisible;

  /// Optional child widget to overlay
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (child != null) child!,
        if (isVisible)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      if (message != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          message!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
