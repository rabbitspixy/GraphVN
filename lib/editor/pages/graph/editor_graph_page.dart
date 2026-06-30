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
  State<EditorGraphPage> createState() => EditorGraphPageState();
}

class EditorGraphPageState extends State<EditorGraphPage> {
  final GlobalKey<EditorCanvasState> _canvasKey = GlobalKey();
  static EditorGraphPageState? instance;

  void _onSelectHandler(dynamic selectedObject) {
    EditorState.selectedNode = null;
    EditorState.selectedTransition = null;
    switch (selectedObject) {
      case EditorNode _: EditorState.selectedNode = selectedObject;
      case EditorTransition _: EditorState.selectedTransition = selectedObject;
    }
    setState(() {});
  }

  void _onNodeEdited() {
    setState(() {});
  }

  void _onTransitionEdited() {
    setState(() {});
  }

  void resetOffset(Size size) {
    _canvasKey.currentState?.resetOffset(size);
  }

  @override
  void initState() {
    super.initState();
    instance = this;
  }

  @override
  void dispose() {
    instance = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        EditorCanvas(
          key: _canvasKey,
          selectedNode: EditorState.selectedNode,
          selectedTransition: EditorState.selectedTransition,
          onSelect: _onSelectHandler,
        ),
        Positioned(
          left: size.width * 0.5,
          top: 0,
          bottom: 0,
          child: Container(
            width: size.width * 0.5 - 50,
            color: Color.fromARGB(255, 230, 230, 230),
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
