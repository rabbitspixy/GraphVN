import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'dart:math';

import 'package:graph_vn/editor/editor_transition.dart';

class TransitionPainter extends CustomPainter {
  final Offset offset;
  final int transitionCount;
  final EditorTransition? selectedTransition;
  TransitionPainter({required this.offset, required this.selectedTransition}) : transitionCount = EditorState.transitions.length;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final transition in EditorState.transitions) {
      final start = transition.pos.start + offset;
      final end = transition.pos.end + offset;
      final control = transition.pos.control + offset;
      final center = transition.pos.center + offset;

      paint.shader = LinearGradient(
        colors: [Colors.black.withAlpha(26), Colors.black.withAlpha(50), Colors.black],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        transform: GradientRotation(transition.pos.direction),
      ).createShader(Rect.fromPoints(start, end));

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
      canvas.drawPath(path, paint);
      final centerPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final arrow = _arrowPath(center, transition.pos.direction);
      canvas.drawPath(arrow, centerPaint);
      if (transition.id == selectedTransition?.id) {
        final pointPaint = Paint()..color = Colors.black..style = PaintingStyle.stroke;
        canvas.drawCircle(center, 7, pointPaint);
      }
    }
  }

  Path _arrowPath(Offset center, double direction) {
    final l = 5.0;
    final angle = pi * 0.75;
    final p2 = center + Offset.fromDirection(direction, l * 0.45);
    final p1 = p2 + Offset.fromDirection(direction - angle, l);
    final p3 = p2 + Offset.fromDirection(direction + angle, l);
    return Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy);
  }

  @override
  bool shouldRepaint(covariant TransitionPainter oldDelegate) =>
      oldDelegate.offset != offset || oldDelegate.transitionCount != transitionCount || oldDelegate.selectedTransition != selectedTransition;
}
