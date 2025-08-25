import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'rive_theme_button.dart';
import 'animated_button.dart';

// Es importante que la clase RulesScreen esté disponible
// para poder navegar a ella. Si está en un archivo separado,
// no olvides importarla.
class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  _RulesScreenState createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 28,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "¿Cómo Jugar?",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        "🎮 REGLAS DEL JUEGO\n\n"
                        "📱 1. JUGADORES:\n"
                        "Cada jugador verá una carta con un rol. Todos los jugadores, excepto uno, verán el nombre de un futbolista. El impostor verá 'Impostor'.\n\n"
                        "💬 2. DEBATE:\n"
                        "Todos los jugadores, incluido el impostor, deben hablar sobre el futbolista para demostrar que saben de quién se trata, pero solo con UNA PALABRA por turno.\n\n"
                        "🎯 3. OBJETIVO:\n"
                        "• Los futbolistas deben identificar al impostor\n"
                        "• El impostor debe pasar desapercibido hasta que no quede nadie más\n\n"
                        "🗳️ 4. VOTACIÓN:\n"
                        "Después de un tiempo de debate, los jugadores votan para eliminar al que creen que es el impostor.\n\n"
                        "🏆 5. VICTORIA:\n"
                        "• Si eliminan al impostor → Los futbolistas GANAN\n"
                        "• Si eliminan a un futbolista → El impostor puede ganar si logra no ser descubierto\n\n"
                        "💡 CONSEJOS:\n"
                        "• Escucha atentamente las pistas de otros jugadores\n"
                        "• Si eres el impostor, trata de imitar las respuestas sin ser obvio\n"
                        "• Usa tu conocimiento de fútbol para dar pistas creíbles\n\n"
                        "¡Que comience la diversión! ⚽🔥",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          height: 1.6,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedGameButton(
                  expanded: true,
                  text: "¡Entendido!",
                  color: Colors.green.shade600,
                  icon: Icons.check_circle,
                  onPressed: () => Navigator.pop(context),
                  height: 56,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsSidebar extends StatefulWidget {
  final VoidCallback onThemeChanged;
  final bool isDarkMode;
  final VoidCallback onClose;

  const SettingsSidebar({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
    required this.onClose,
  });

  @override
  State<SettingsSidebar> createState() => _SettingsSidebarState();
}

class _SettingsSidebarState extends State<SettingsSidebar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rotationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _closeSidebar() {
    _animationController.reverse().then((_) {
      widget.onClose();
    });
  }

  void _showRulesScreen() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const RulesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
                CurveTween(curve: Curves.easeInOut),
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }

  void _launchInstagram() async {
    const url = 'https://www.instagram.com/epfree_pupi';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir Instagram')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    final backgroundColor = isDark
        ? const Color(0xFF1A1A2E)
        : const Color(0xFFF8F9FA);

    final surfaceColor = isDark
        ? const Color(0xFF16213E)
        : Colors.white;

    final accentColor = isDark
        ? const Color(0xFF0F3460)
        : const Color(0xFF4A90E2);

    final textColor = isDark
        ? Colors.white
        : const Color(0xFF2C3E50);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            // Backdrop
            GestureDetector(
              onTap: _closeSidebar,
              child: Container(
                color: Colors.black.withOpacity(0.5 * _fadeAnimation.value),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            // Sidebar - Posicionado desde la derecha
            Positioned(
              right: _slideAnimation.value * MediaQuery.of(context).size.width * 0.8,
              top: 0,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: isDark
                        ? [
                            const Color(0xFF1A1A2E),
                            const Color(0xFF16213E),
                            const Color(0xFF0F3460),
                          ]
                        : [
                            const Color(0xFFF8F9FA),
                            const Color(0xFFE3F2FD),
                            const Color(0xFFBBDEFB),
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(-5, 0),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Header con ícono giratorio - TODO CENTRADO
                      Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: surfaceColor.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: _closeSidebar,
                                  icon: Icon(
                                    Icons.close,
                                    color: textColor,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            RotationTransition(
                              turns: _rotationAnimation,
                              child: Icon(
                                Icons.settings,
                                color: textColor,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Configuración",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Theme Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Cambiar Tema",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  decoration: TextDecoration.none,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: RiveThemeButton(
                                  isDarkMode: isDark,
                                  onPressed: widget.onThemeChanged,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Rules Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Center(
                          child: AnimatedGameButton(
                            expanded: true,
                            text: "📖 ¿Cómo Jugar?",
                            color: Colors.blue.shade600,
                            icon: Icons.help_outline,
                            onPressed: _showRulesScreen,
                            height: 60,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Botón de Instagram
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Center(
                          child: AnimatedGameButton(
                            expanded: true,
                            text: "Conocer al Creador",
                            color: Colors.purple.shade700,
                            icon: Icons.person_outline,
                            onPressed: _launchInstagram,
                            height: 60,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Footer de versión
                      Text(
                        "Impostor Fútbol v1.0",
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}