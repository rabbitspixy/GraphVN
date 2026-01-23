import 'package:flutter/material.dart';
import 'package:graph_vn/editor/pages/graph/editor_canvas.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/editor_transition.dart';
import 'package:graph_vn/editor/pages/graph/node_editor.dart';
import 'package:graph_vn/editor/pages/graph/transition_editor.dart';

class EditorGraphPage extends StatefulWidget {
  const EditorGraphPage({super.key});

  @override
  State<EditorGraphPage> createState() => _EditorGraphPageState();
}

class _EditorGraphPageState extends State<EditorGraphPage> {
  void _onStartNodeEdit(EditorNode node) {
    setState(() {
      EditorState.selectedNode = node;
      EditorState.selectedTransition = null;
    });
  }

  void _onStartTransitionEdit(EditorTransition transition) {
    setState(() {
      EditorState.selectedNode = null;
      EditorState.selectedTransition = transition;
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
          selectedNode: EditorState.selectedNode,
          selectedTransition: EditorState.selectedTransition,
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
            child: EditorState.selectedNode != null
                ? NodeEditor(node: EditorState.selectedNode!, onChange: _onNodeEdited,)
                : EditorState.selectedTransition != null
                    ? TransitionEditor(transition: EditorState.selectedTransition!, onChange: _onTransitionEdited,)
                    : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
