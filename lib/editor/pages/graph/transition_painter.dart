import 'package:flutter/material.dart';
import 'package:graph_vn/game/game_state.dart';
import 'dart:math';

import 'package:graph_vn/game/game_transition.dart';

class TransitionPainter extends CustomPainter {
  final Offset offset;
  final int transitionCount;
  final GameTransition? selectedTransition;
  final GameTransition? hoveredTransition;
  TransitionPainter({required this.offset, required this.selectedTransition, required this.hoveredTransition}) : transitionCount = GameState.transitions.length;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final transition in GameState.transitions) {
      final start = transition.pos.start + offset;
      final end = transition.pos.end + offset;
      final control = transition.pos.control + offset;
      final center = transition.pos.center + offset;

      final line = end - start;
      paint.shader = LinearGradient(
        colors: _colorsOf(transition),
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        transform: GradientRotation(transition.pos.direction),
      ).createShader(
        Rect.fromCenter(
          center: (start + end) / 2,
          width: line.distance,
          height: line.distance,
        ),
      );

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
      canvas.drawPath(path, paint);
      final centerPaint = Paint()
        ..color = _arrowColorOf(transition)
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final arrow = _arrowPath(center, transition.pos.direction);
      canvas.drawPath(arrow, centerPaint);
      if (transition.id == selectedTransition?.id) {
        final pointPaint = Paint()..color = Colors.black..style = PaintingStyle.stroke;
        canvas.drawCircle(center, 7, pointPaint);
      }
      if (transition.id == hoveredTransition?.id && transition.id != selectedTransition?.id) {
        final pointPaint = Paint()..color = Colors.black.withAlpha(60)..style = PaintingStyle.stroke;
        canvas.drawCircle(center, 7, pointPaint);
      }
    }
  }

  Path _arrowPath(Offset center, double direction) {
    final l = 5.0;
    final angle = pi * 0.8;
    final p2 = center + Offset.fromDirection(direction, l * 0.45);
    final p1 = p2 + Offset.fromDirection(direction - angle, l);
    final p3 = p2 + Offset.fromDirection(direction + angle, l);
    return Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy);
  }

  static final transitionButtonColors = [Colors.black.withAlpha(20), Colors.black.withAlpha(80), Colors.black.withAlpha(180)];
  static final emptyTransitionColors = [Colors.black.withAlpha(20), Colors.black.withAlpha(40), Colors.black.withAlpha(75)];

  List<Color> _colorsOf(GameTransition transition) {
    if (transition.isButton) {
      return transitionButtonColors;
    } else {
      return emptyTransitionColors;
    }
  }

  Color _arrowColorOf(GameTransition transition) {
    if (transition.isButton) {
      return Colors.black.withAlpha(255);
    } else {
      return Colors.black.withAlpha(80);
    }
  }

  @override
  bool shouldRepaint(covariant TransitionPainter oldDelegate) =>
      oldDelegate.offset != offset || oldDelegate.transitionCount != transitionCount || oldDelegate.selectedTransition != selectedTransition || oldDelegate.hoveredTransition != hoveredTransition;
}
