import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graph_vn/editor/modals/confirm_dialog.dart';
import 'package:graph_vn/editor/pages/graph/editor_canvas.dart';
import 'package:graph_vn/game/game_node.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/game/game_transition.dart';
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
    GameState.selectedNode = null;
    GameState.selectedTransition = null;
    switch (selectedObject) {
      case GameNode _: GameState.selectedNode = selectedObject;
      case GameTransition _: GameState.selectedTransition = selectedObject;
    }
    setState(() {});
  }

  void _onNodeEdited() {
    setState(() {});
  }

  void _onTransitionEdited() {
    setState(() {});
  }

  void resetOffset() {
    final size = MediaQuery.of(context).size;
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
        CallbackShortcuts(
            bindings: <ShortcutActivator, VoidCallback>{
              const SingleActivator(LogicalKeyboardKey.delete): () async {
                final node = GameState.selectedNode;
                if (node != null) {
                  if (await showConfirmDialog(context, "Удалить узел?")) {
                    GameState.deleteNode(node.id);
                  }
                }
                final transition = GameState.selectedTransition;
                if (transition != null) {
                  if (await showConfirmDialog(context, "Удалить переход?")) {
                    GameState.deleteTransition(transition.id);
                  }
                }
              },

              const SingleActivator(LogicalKeyboardKey.home): () async {
                resetOffset();
              },
            },
            child: EditorCanvas(
              key: _canvasKey,
              selectedNode: GameState.selectedNode,
              selectedTransition: GameState.selectedTransition,
              onSelect: _onSelectHandler,
            )
        ),
        Positioned(
          left: size.width * 0.65,
          top: 0,
          bottom: 0,
          child: Container(
            width: size.width * 0.35 - 50,
            color: Color.fromARGB(255, 230, 230, 230),
            padding: const EdgeInsets.all(8.0),
            child: GameState.selectedNode != null
                ? NodeEditor(node: GameState.selectedNode!, onChange: _onNodeEdited,)
                : GameState.selectedTransition != null
                    ? TransitionEditor(transition: GameState.selectedTransition!, onChange: _onTransitionEdited,)
                    : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
