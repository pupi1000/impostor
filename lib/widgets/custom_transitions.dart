import 'package:flutter/material.dart';

/// ============================================================================
///                          TRANSICIÓN ENTRE PANTALLAS
/// ============================================================================
Route createSlideTransitionRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeOut;
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

/// Crea una transición de escala para una animación de zoom.
Route createScaleTransitionRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.9;
      const end = 1.0;
      const curve = Curves.easeInOut;
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return ScaleTransition(
        scale: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 600), // Animación más lenta
  );
}