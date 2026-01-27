import 'package:flutter/foundation.dart';
import 'package:graph_vn/common/random_util.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/editor_transition.dart';
import 'package:graph_vn/player/components.dart';
import 'package:graph_vn/editor/editor_state.dart';

class Player {
  static final ValueNotifier<PlayerImageInfo> imageInfoNotifier = ValueNotifier<PlayerImageInfo>(PlayerImageInfo(path: ''));
  static final ValueNotifier<String> narrativeText = ValueNotifier<String>('');
  static final ValueNotifier<List<ChoiseButton>> buttons = ValueNotifier<List<ChoiseButton>>([]);

  static void useRandomTransitionIfAllowed() {
    final allowedTransitions = allowedTransitionsForCurrentState();
    if (allowedTransitions.any((x) => x.isButton)) {
      return;
    }
    final allowedEmptyTransitions = allowedTransitions.where((x) => !x.isButton).toList();
    final randomTransition = selectRandomTransition(allowedEmptyTransitions);
    if (randomTransition != null) {
      updateState(useTransition: randomTransition.id);
    }
  }

  static void updateState({String? useTransition}) {
    EditorTransition? transition;
    if (useTransition != null) {
      transition = EditorState.transitions.where((x) => x.id == useTransition).firstOrNull;
    }

    EditorNode? node;
    int iterations = 0;
    int maxIterations = 10000;
    while (true) {
      if (transition != null) {
        node = EditorState.nodes[transition.to];
        transition = null;
      }
      if (node != null) {
        EditorState.currentNode = node.id;
        if (node.isEmpty) {
          final allowedTransitions = Player.allowedTransitionsForCurrentState();
          if (allowedTransitions.every((x) => !x.isButton)){
            transition = selectRandomTransition(allowedTransitions);
          }
        }
        node = null;
      }

      if (transition == null && node == null) {
        break;
      }

      iterations++;
      if (iterations == maxIterations) {
        throw Exception('reached max iterations count');
      }
    }

    _updateStill();
  }

  static List<EditorTransition> allowedTransitionsForCurrentState() {
    return EditorState.transitions
      .where((t) => t.from == EditorState.currentNode)
      .toList();
  }

  static void _updateStill() {
    buttons.value.clear();
    if (EditorState.currentNode == "") {
      final initResult = initStartGame();
      if (!initResult) {
        return;
      }
    }
    final node = EditorState.nodes[EditorState.currentNode];
    if (node == null) {
      return;
    }
    narrativeText.value = node.text;
    buttons.value = allowedTransitionsForCurrentState()
        .where((t) => t.isButton)
        .map((t) => ChoiseButton(text: t.text, transitionId: t.id))
        .toList();
  }

  static bool initStartGame() {
    final startNode = EditorState.nodes.values.where((node) => node.isStart).firstOrNull;
    if (startNode != null) {
      EditorState.currentNode = startNode.id;
      return true;
    } else {
      return false;
    }
  }
}