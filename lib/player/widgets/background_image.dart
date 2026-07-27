import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/player/player_models.dart';
import 'package:graph_vn/player/player.dart';

class BackgroundImageWidget extends StatefulWidget {
  const BackgroundImageWidget({super.key});

  @override
  State<BackgroundImageWidget> createState() => _BackgroundImageWidgetState();
}

class _BackgroundImageWidgetState extends State<BackgroundImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  PlayerBackgroundImage? _currentBackgroundImage;
  MemoryImage? _memoryImage;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _animation = const AlwaysStoppedAnimation(0.0);
    Player.backgroundImageNotifier.addListener(_onBackgroundImageChanged);
    _onBackgroundImageChanged();
  }

  void _onBackgroundImageChanged() {
    final background = Player.backgroundImageNotifier.value;
    if (_currentBackgroundImage?.imageHash != background.imageHash) {
      _currentBackgroundImage = background;
      if (background.imageBytes != null) {
        _memoryImage = MemoryImage(background.imageBytes!);
      } else {
        _memoryImage = null;
      }
      if (background.animationDuration > 0) {
        _startAnimations(background);
      } else {
        _animation = const AlwaysStoppedAnimation(0.0);
        _controller.stop();
      }
      setState(() {});
    }
  }

  void _startAnimations(PlayerBackgroundImage info) {
    _controller.stop();
    _controller.reset();
    _controller.duration = Duration(milliseconds: info.animationDuration);
    _animation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    Player.backgroundImageNotifier.removeListener(_onBackgroundImageChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = _currentBackgroundImage ?? PlayerBackgroundImage();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offsetX = _random.nextDouble() * 2 - 1;
        final offsetY = _random.nextDouble() * 2 - 1;
        final offset = Offset(
          offsetX * (_animation.value * info.shakeIntensity),
          offsetY * (_animation.value * info.shakeIntensity),
        );
        final scale = lerpDouble(1.0, info.scale, _animation.value);
        return Transform.scale(
          scale: scale,
          child: Transform.translate(
            offset: offset,
            child: (_memoryImage == null)
                ? Container(
                    color: Color.fromARGB(255, info.red, info.green, info.blue),
                  )
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _memoryImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
