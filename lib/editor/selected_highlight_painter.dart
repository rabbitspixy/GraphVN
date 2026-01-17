import 'package:flutter/material.dart';
import 'package:touch_of_the_unknown/editor/editor_node.dart';
import 'package:touch_of_the_unknown/editor/editor_transition.dart';
import 'dart:math';

class SelectedHighlightPainter extends CustomPainter {
  final EditorNode? selectedNode;
  final EditorTransition? selectedTransition;
  final Offset offset;

  SelectedHighlightPainter({
    required this.selectedNode,
    required this.selectedTransition,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Highlight selected node
    if (selectedNode != null) {
      final center = Offset(
        selectedNode!.x.toDouble() + offset.dx,
        selectedNode!.y.toDouble() + offset.dy,
      );
      canvas.drawCircle(center, 7.0, paint);
    }

    // Highlight selected transition
    if (selectedTransition != null) {
      final fromNode = EditorState.nodes[selectedTransition!.from];
      final toNode = EditorState.nodes[selectedTransition!.to];
      if (fromNode != null && toNode != null) {
        final start = Offset(
          fromNode.x.toDouble(),
          fromNode.y.toDouble(),
        ) + offset;
        final end = Offset(
          toNode.x.toDouble(),
          toNode.y.toDouble(),
        ) + offset;

        // Compute center similar to TransitionPainter
        final key = '${selectedTransition!.from}->${selectedTransition!.to}';
        final keyReversed = '${selectedTransition!.to}->${selectedTransition!.from}';
        final pairCount = <String, int>{};
        final index = (pairCount.update(key, (v) => v + 1, ifAbsent: () => 1) +
                pairCount.update(keyReversed, (v) => v + 1, ifAbsent: () => 1)) /
            2;

        Offset center;
        if (index == 1) {
          center = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
        } else {
          final mid = Offset(
            (start.dx + end.dx) / 2,
            (start.dy + end.dy) / 2,
          );
          final sign = (index % 2 == 0) ? 1 : -1;
          final d = end - start;
          final perp = Offset(-d.dy, d.dx);
          final perpLength = perp.distance;
          final magnitude = 50.0 * (((index - 2) ~/ 2) + 1);
          final unitPerp = perpLength == 0 ? Offset.zero : Offset(perp.dx / perpLength, perp.dy / perpLength);
          final control = mid + unitPerp * (sign.toDouble() * magnitude);
          center = Offset(
            0.25 * start.dx + 0.5 * control.dx + 0.25 * end.dx,
            0.25 * start.dy + 0.5 * control.dy + 0.25 * end.dy,
          );
        }

        canvas.drawCircle(center, 7.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SelectedHighlightPainter oldDelegate) =>
      oldDelegate.selectedNode != selectedNode ||
      oldDelegate.selectedTransition != selectedTransition ||
      oldDelegate.offset != offset;
}
