import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'select_mode_screen.dart';

/// ============================================================================
///                             PANTALLA: INTRO
/// ============================================================================
class IntroScreen extends StatefulWidget {
  final VoidCallback onThemeChanged;

  const IntroScreen({super.key, required this.onThemeChanged});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late VideoPlayerController _controller1;
  late VideoPlayerController _controller2;
  bool _isFirstVideoPlaying = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller1 = VideoPlayerController.asset("assets/videos/intro.mp4");
    _controller2 = VideoPlayerController.asset("assets/videos/video2.mp4");

    Future.wait([
      _controller1.initialize(),
      _controller2.initialize(),
    ]).then((_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _controller1.play();
    });

    _controller1.addListener(() {
      if (_controller1.value.position >= _controller1.value.duration &&
          _isFirstVideoPlaying) {
        setState(() {
          _isFirstVideoPlaying = false;
        });
        _controller2.play();
        _controller1.dispose();
      }
    });

    _controller2.addListener(() {
      if (_controller2.value.position >= _controller2.value.duration) {
        Navigator.pushReplacement(
          context,
          createFadeTransitionRoute(SelectModeScreen(
            onThemeChanged: widget.onThemeChanged,
          )),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Video 1 (Horizontal)
                if (_isFirstVideoPlaying)
                  Center(
                    child: AspectRatio(
                      aspectRatio: _controller1.value.aspectRatio,
                      child: VideoPlayer(_controller1),
                    ),
                  ),

                // Video 2 (Vertical - ocupa toda la pantalla)
                if (!_isFirstVideoPlaying)
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller2.value.size.width,
                        height: _controller2.value.size.height,
                        child: VideoPlayer(_controller2),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

/// ============================================================================
/// FUNCIÓN DE TRANSICIÓN: FADE
/// ============================================================================
Route createFadeTransitionRoute(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Usa un FadeTransition para un desvanecimiento suave
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 3000), // Duración de 1 segundo
  );
}