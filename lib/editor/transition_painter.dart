import 'package:flutter/material.dart';
import 'package:touch_of_the_unknown/editor/editor_state.dart';

class TransitionPainter extends CustomPainter {
  final Offset offset;
  TransitionPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
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

      final key = '${transition.from}->${transition.to}';
      final index = pairCount.update(key, (v) => v + 1, ifAbsent: () => 1);

      if (index == 1) {
        // Single transition – draw a straight line
        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..lineTo(end.dx, end.dy);
        canvas.drawPath(path, paint);
      } else {
        // Multiple transitions – add increasing curvature
        final mid = Offset(
          (start.dx + end.dx) / 2,
          (start.dy + end.dy) / 2,
        );
        // Calculate a control point that alternates sides of the straight line
        // and increases the deviation every two transitions.
        final sign = (index % 2 == 0) ? 1 : -1;
        final Offset d = end - start;
        final Offset perp = Offset(-d.dy, d.dx);
        final double perpLength = perp.distance;
        final double magnitude = 50.0 * (((index - 2) ~/ 2) + 1);
        final Offset unitPerp = perpLength == 0 ? Offset.zero : Offset(perp.dx / perpLength, perp.dy / perpLength);
        final Offset control = mid + unitPerp * (sign.toDouble() * magnitude);

        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant TransitionPainter oldDelegate) =>
      oldDelegate.offset != offset;
}
