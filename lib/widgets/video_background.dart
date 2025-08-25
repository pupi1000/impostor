import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Un widget que muestra un video de fondo que se reproduce en bucle.
class AnimatedVideoBackground extends StatefulWidget {
  final String videoPath;
  const AnimatedVideoBackground({Key? key, required this.videoPath}) : super(key: key);

  @override
  _AnimatedVideoBackgroundState createState() => _AnimatedVideoBackgroundState();
}

class _AnimatedVideoBackgroundState extends State<AnimatedVideoBackground> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        if (!mounted) return;
        _controller
          ..setLooping(true)
          ..setVolume(0.0)
          ..play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      );
    } else {
      return Container(color: Colors.black);
    }
  }
}

/// Un widget que muestra un video como fondo estático (sin reproducir).
class StaticVideoBackground extends StatefulWidget {
  final String videoPath;
  const StaticVideoBackground({Key? key, required this.videoPath}) : super(key: key);

  @override
  _StaticVideoBackgroundState createState() => _StaticVideoBackgroundState();
}

class _StaticVideoBackgroundState extends State<StaticVideoBackground> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        if (!mounted) return;
        _controller.setVolume(0.0);
        _controller.pause();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      );
    } else {
      return Container(color: Colors.black);
    }
  }
}