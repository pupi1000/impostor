import 'package:flutter/material.dart';
import 'video_background.dart';

/// Botón con animación de zoom al presionar y con latido en idle.
class AnimatedGameButton extends StatefulWidget {
  final String text;
  final String? videoPath;
  final Color? color;
  final LinearGradient? gradient;
  final Future<void> Function()? onAsyncPressed;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double minWidth;
  final double height;
  final bool expanded;

  const AnimatedGameButton({
    super.key,
    required this.text,
    this.videoPath,
    this.color,
    this.gradient,
    this.onAsyncPressed,
    this.onPressed,
    this.icon,
    this.minWidth = 300,
    this.height = 70,
    this.expanded = false,
  }) : assert(
    videoPath != null || color != null || gradient != null,
    'Either videoPath, color, or gradient must be provided.',
  );

  @override
  State<AnimatedGameButton> createState() => _AnimatedGameButtonState();
}

class _AnimatedGameButtonState extends State<AnimatedGameButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _pressScale = Tween<double>(begin: 1.0, end: 1.07).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.bounceOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    _pressController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _pressController.reverse();
    if (widget.onAsyncPressed != null) {
      await widget.onAsyncPressed!();
    } else {
      widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) Icon(widget.icon, color: Colors.white),
        if (widget.icon != null) const SizedBox(width: 8),
        Text(
          widget.text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );

    final button = Container(
      width: widget.minWidth,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.color,
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.videoPath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: StaticVideoBackground(videoPath: widget.videoPath!),
            ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleTap,
              borderRadius: BorderRadius.circular(20),
              child: Center(child: buttonContent),
            ),
          ),
        ],
      ),
    );

    final animated = AnimatedBuilder(
      animation: _pressController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pressScale.value,
          child: child,
        );
      },
      child: button,
    );

    if (widget.expanded) {
      return SizedBox(width: double.infinity, child: animated);
    }
    return animated;
  }
}

/// Wrapper para aplicar un zoom sutil de aparición (al montar el widget).
class AppearZoom extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double beginScale;

  const AppearZoom({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600), // Duración aumentada para un efecto más lento
    this.beginScale = 0.94,
  });

  @override
  State<AppearZoom> createState() => _AppearZoomState();
}

class _AppearZoomState extends State<AppearZoom> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween<double>(begin: widget.beginScale, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}