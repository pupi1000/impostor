import 'package:flutter/material.dart';

class RiveThemeButton extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onPressed;

  const RiveThemeButton({
    super.key,
    required this.isDarkMode,
    required this.onPressed,
  });

  @override
  State<RiveThemeButton> createState() => _RiveThemeButtonState();
}

class _RiveThemeButtonState extends State<RiveThemeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePress() async {
    await _controller.forward();
    widget.onPressed();
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: GestureDetector(
              onTap: _handlePress,
              child: Container(
                width: 180,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient( // CORREGIDO: Solo importamos de Flutter
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: widget.isDarkMode
                        ? [
                            Colors.orange.shade700,
                            Colors.orange.shade500,
                            Colors.yellow.shade600,
                          ]
                        : [
                            Colors.indigo.shade700,
                            Colors.blue.shade500,
                            Colors.cyan.shade600,
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isDarkMode
                          ? Colors.orange.withOpacity(0.4)
                          : Colors.blue.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.isDarkMode ? 'Modo Claro' : 'Modo Oscuro',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}