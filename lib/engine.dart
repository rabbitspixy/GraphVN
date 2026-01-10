import 'package:flutter/foundation.dart';
import 'package:touch_of_the_unknown/components.dart';
import 'package:touch_of_the_unknown/game_logic/game_state.dart';
import 'package:touch_of_the_unknown/game_logic/start.dart';

final ValueNotifier<NodeImageInfo> imageInfoNotifier = ValueNotifier<NodeImageInfo>(NodeImageInfo(path: ''));
final ValueNotifier<String> narrativeText = ValueNotifier<String>('');
final ValueNotifier<List<Transition>> transitions = ValueNotifier<List<Transition>>([]);

void initGame() {
  enterNode(startNode);
}

void enterNode(Node node) {
  GameState.currentNode.onLeave?.call();
  GameState.currentNode = node;
  GameState.currentNode.onEnter?.call();
  imageInfoNotifier.value = node.imageInfo();
  narrativeText.value = node.text();
  transitions.value = node.transitions.where((t) => t.canGo()).toList();
}

