import 'package:flutter/foundation.dart';
import 'package:graph_vn/components.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/game_logic/game_state.dart';

final ValueNotifier<NodeImageInfo> imageInfoNotifier = ValueNotifier<NodeImageInfo>(NodeImageInfo(path: ''));
final ValueNotifier<String> narrativeText = ValueNotifier<String>('');
final ValueNotifier<List<Transition>> transitions = ValueNotifier<List<Transition>>([]);

void goToNode(String nodeId) {
  final node = EditorState.nodes[nodeId];
  if (node == null) {
    return;
  }
  // GameState.currentNode.onLeave?.call();
  GameState.currentNode = nodeId;
  // GameState.currentNode.onEnter?.call();
  // imageInfoNotifier.value = no.imageInfo();
  
  updateNode();
}

void updateNode() {
  transitions.value.clear();
  if (GameState.currentNode == "") {
    initStartGame();
    return;
  }
  final node = EditorState.nodes[GameState.currentNode];
  if (node == null) {
    return;
  }
  narrativeText.value = node.text;
  transitions.value = EditorState.transitions
    .where((t) => t.from == GameState.currentNode)
    .map((t) => Transition(text: t.text, nextNode: t.to))
    .toList();
}

void initStartGame() {
  final startNode = EditorState.nodes.values.where((node) => node.isStart).firstOrNull;
  narrativeText.value = '';
  if (startNode != null) {
    transitions.value.addAll([
      Transition(text: 'Начать', nextNode: startNode.id),
    ]);
  }
}