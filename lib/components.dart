import 'package:flutter/foundation.dart';
import 'package:touch_of_the_unknown/engine.dart';

class Node {
  final NodeImageInfo Function() imageInfo;
  final String Function() text;
  final VoidCallback? onEnter;
  final VoidCallback? onLeave;
  final List<Transition> transitions;

  Node({
    required this.imageInfo,
    required this.text,
    this.onEnter,
    this.onLeave,
    required this.transitions,
  });
}

class Transition {
  final String Function() text;
  final Node Function() nextNode;
  final VoidCallback? onTransition;
  final bool Function()? condition;

  Transition({
    required this.text,
    required this.nextNode,
    this.onTransition,
    this.condition,
  });

  void go() {
    onTransition?.call();
    enterNode(nextNode());
  }

  bool canGo() {
    return condition?.call() ?? true;
  }
}

class NodeImageInfo {
  final String? path;
  final int red;
  final int green;
  final int blue;
  final double shakeIntensity;
  final double scale;
  final int animationDuration;

  NodeImageInfo({
    this.path,
    this.red = 0,
    this.green = 0,
    this.blue = 0,
    this.shakeIntensity = 0.0,
    this.scale = 1.0,
    this.animationDuration = 0,
  });
}