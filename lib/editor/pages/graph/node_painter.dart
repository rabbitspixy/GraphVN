import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/editor_state.dart';

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
      pointPaint.color = _colorOf(node);
      pointPaint.style = PaintingStyle.fill;
      canvas.drawCircle(center, 5, pointPaint);
      if (node.label.isNotEmpty) {
        _paintText(canvas, center, node.label);
      }

      if (node.id == selectedNode?.id) {
        final pointPaint = Paint()..color = Colors.black..style = PaintingStyle.stroke;
        canvas.drawCircle(center, 7, pointPaint);
      }
    }
  }

  Color _colorOf(EditorNode node) {
    if (node.isStart) {
      return const Color.fromARGB(255, 21, 207, 27);
    }
    if (node.isEmpty) {
      return const Color.fromARGB(255, 201, 201, 201);
    }
    return const Color.fromARGB(255, 90, 128, 255);
  }

  void _paintText(Canvas canvas, Offset nodePosition, String text) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 200.0,
      maxWidth: 200.0,
    );
    textPainter.paint(canvas, nodePosition + Offset(-100.0, -26.0));
  }

  @override
  bool shouldRepaint(covariant NodePainter oldDelegate) =>
      oldDelegate.forcedRepaint != forcedRepaint || oldDelegate.offset != offset || oldDelegate.nodesCount != nodesCount || oldDelegate.selectedNode != selectedNode;
}
