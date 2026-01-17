import 'package:flutter/material.dart';
import 'package:touch_of_the_unknown/editor/editor_node.dart';
import 'package:touch_of_the_unknown/editor/editor_state.dart';

class NodePainter extends CustomPainter {
  final Offset offset;
  final int nodesCount;
  final EditorNode? selectedNode;
  final int forcedRepaint;
  NodePainter({required this.offset, required this.selectedNode, required this.forcedRepaint}) : nodesCount = EditorState.nodes.length;

  @override
  void paint(Canvas canvas, Size size) {
    for (final node in EditorState.nodes.values) {
      final center = Offset(node.x.toDouble(), node.y.toDouble()) + offset;

      final pointPaint = Paint();
      pointPaint.color = node.isStart ? const Color.fromARGB(255, 37, 224, 43) : Colors.blue;
      pointPaint.style = PaintingStyle.fill;
      canvas.drawCircle(center, 5, pointPaint);

      if (node.id == selectedNode?.id) {
        final pointPaint = Paint()..color = Colors.black..style = PaintingStyle.stroke;
        canvas.drawCircle(center, 7, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant NodePainter oldDelegate) =>
      oldDelegate.forcedRepaint != forcedRepaint || oldDelegate.offset != offset || oldDelegate.nodesCount != nodesCount || oldDelegate.selectedNode != selectedNode;
}
