import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_constants.dart';
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

    // Map to keep track of how many transitions have been drawn between each pair
    final Map<String, int> pairCount = {};

    for (final transition in EditorState.transitions) {
      final fromNode = EditorState.nodes[transition.from];
      final toNode = EditorState.nodes[transition.to];
      if (fromNode == null || toNode == null) continue;

      final start = Offset(
        fromNode.x.toDouble(),
        fromNode.y.toDouble(),
      ) + offset;
      
      final end = Offset(
        toNode.x.toDouble(),
        toNode.y.toDouble(),
      ) + offset;

      final double angle = atan2(end.dy - start.dy, end.dx - start.dx);
      paint.shader = LinearGradient(
        colors: [Colors.black.withAlpha(26), Colors.black.withAlpha(50), Colors.black],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        transform: GradientRotation(angle),
      ).createShader(Rect.fromPoints(start, end));

      final key = '${transition.from}->${transition.to}';
      final index = pairCount.update(key, (v) => v + 1, ifAbsent: () => 1);

      // Multiple transitions – add increasing curvature
      final mid = Offset(
        (start.dx + end.dx) / 2,
        (start.dy + end.dy) / 2,
      );
      final Offset d = end - start;
      final Offset perp = Offset(-d.dy, d.dx);
      final double perpLength = perp.distance;
      final double magnitude = EditorConstants.transitionDeviationMagnitude * index;
      final Offset unitPerp = perpLength == 0 ? Offset.zero : Offset(perp.dx / perpLength, perp.dy / perpLength);
      final Offset control = mid + unitPerp * magnitude;

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
      final center = Offset(
        0.25 * start.dx + 0.5 * control.dx + 0.25 * end.dx,
        0.25 * start.dy + 0.5 * control.dy + 0.25 * end.dy,
      );
      canvas.drawPath(path, paint);
      final centerPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final arrow = _arrowPath(center, d.direction);
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
