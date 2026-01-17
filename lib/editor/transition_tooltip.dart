import 'package:flutter/material.dart';
import 'package:touch_of_the_unknown/editor/editor_transition.dart';
import 'package:touch_of_the_unknown/editor/tooltip_positioned.dart';

class TransitionTooltip extends StatelessWidget {
  final Offset position;
  final EditorTransition transition;
  const TransitionTooltip({
    Key? key,
    required this.position,
    required this.transition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TooltipPositioned(
      position: position,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 400.0,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(180),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            transition.text,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }
}