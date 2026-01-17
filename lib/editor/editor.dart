import 'package:flutter/material.dart';
import 'package:touch_of_the_unknown/editor/editor_canvas.dart';
import 'package:touch_of_the_unknown/editor/editor_node.dart';
import 'package:touch_of_the_unknown/editor/editor_transition.dart';
import 'package:touch_of_the_unknown/editor/editor_node_editor.dart';
import 'package:touch_of_the_unknown/editor/editor_transition_editor.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  EditorNode? _selectedNode;
  EditorTransition? _selectedTransition;

  void _onStartNodeEdit(EditorNode node) {
    setState(() {
      _selectedNode = node;
      _selectedTransition = null;
    });
  }

  void _onStartTransitionEdit(EditorTransition transition) {
    setState(() {
      _selectedNode = null;
      _selectedTransition = transition;
    });
  }

  void _onNodeEdited() {
    setState(() {});
  }

  void _onTransitionEdited() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        EditorCanvas(
          selectedNode: _selectedNode,
          selectedTransition: _selectedTransition,
          startNodeEdit: _onStartNodeEdit,
          startTransitionEdit: _onStartTransitionEdit,
        ),
        Positioned(
          left: size.width * 0.7,
          top: 0,
          bottom: 0,
          child: Container(
            width: size.width * 0.3,
            color: Colors.black.withAlpha(20),
            padding: const EdgeInsets.all(8.0),
            child: _selectedNode != null
                ? EditorNodeEditor(node: _selectedNode!, onChange: _onNodeEdited,)
                : _selectedTransition != null
                    ? EditorTransitionEditor(transition: _selectedTransition!, onChange: _onTransitionEdited,)
                    : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
