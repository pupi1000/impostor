/// Professional video background widgets for immersive experiences.
///
/// This file provides video background components with different
/// playback modes for various app screens and use cases.
///
/// Features:
/// - Animated looping video backgrounds
/// - Static video frame backgrounds
/// - Optimized video initialization
/// - Memory-efficient disposal
/// - Responsive video scaling
/// - Professional loading states
///
/// Author: Professional Development Team
/// Version: 1.0.0

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Animated video background that plays in loop
class AnimatedVideoBackground extends StatefulWidget {
  final String videoPath;

  const AnimatedVideoBackground({super.key, required this.videoPath});

  @override
  State<AnimatedVideoBackground> createState() =>
      _AnimatedVideoBackgroundState();
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

/// Static video background (paused frame)
class StaticVideoBackground extends StatefulWidget {
  final String videoPath;

  const StaticVideoBackground({super.key, required this.videoPath});

  @override
  State<StaticVideoBackground> createState() => _StaticVideoBackgroundState();
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
