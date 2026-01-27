import 'package:flutter/foundation.dart';

class GameStill {
  final PlayerImageInfo Function() imageInfo;
  final String Function() text;
  final VoidCallback? onEnter;
  final VoidCallback? onLeave;
  final List<ChoiseButton> buttons;

  GameStill({
    required this.imageInfo,
    required this.text,
    this.onEnter,
    this.onLeave,
    required this.buttons,
  });
}

class ChoiseButton {
  final String text;
  final String transitionId;

  ChoiseButton({
    required this.text,
    required this.transitionId,
  });
}

class PlayerImageInfo {
  final String? path;
  final int red;
  final int green;
  final int blue;
  final double shakeIntensity;
  final double scale;
  final int animationDuration;

  PlayerImageInfo({
    this.path,
    this.red = 0,
    this.green = 0,
    this.blue = 0,
    this.shakeIntensity = 0.0,
    this.scale = 1.0,
    this.animationDuration = 0,
  });
}