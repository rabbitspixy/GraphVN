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
  String? _beingEditedNode;
  String? _beingEditedTransition;

  void _onStartNodeEdit(EditorNode node) {
    setState(() {
      _beingEditedNode = node.id;
      _beingEditedTransition = null;
    });
  }

  void _onStartTransitionEdit(EditorTransition transition) {
    setState(() {
      _beingEditedNode = null;
      _beingEditedTransition = transition.id;
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
            child: _beingEditedNode != null
                ? EditorNodeEditor(nodeId: _beingEditedNode!, onChange: _onNodeEdited,)
                : _beingEditedTransition != null
                    ? EditorTransitionEditor(transitionId: _beingEditedTransition!, onChange: _onTransitionEdited,)
                    : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
