import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/pages/graph/tooltip_positioned.dart';

class NodeTooltip extends StatelessWidget {
  final Offset position;
  final EditorNode node;
  const NodeTooltip({
    Key? key,
    required this.position,
    required this.node,
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
            node.text,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }
}