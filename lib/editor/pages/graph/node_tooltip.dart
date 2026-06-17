import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/pages/graph/tooltip_positioned.dart';

class NodeTooltip extends StatelessWidget {
  final Offset position;
  final EditorNode node;
  const NodeTooltip({
    super.key,
    required this.position,
    required this.node,
  });

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
            text(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }

  String text() {
    final result = StringBuffer();
    result.writeln("--- Текст ---");
    result.writeln(node.text);
    result.writeln();
    if (node.naturalLanguageAction.isNotEmpty) {
      result.writeln("--- Действия ---");
      result.writeln(node.naturalLanguageAction);
      result.writeln();
    }
    return result.toString();
  }
}