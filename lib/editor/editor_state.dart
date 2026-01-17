

import 'package:flutter/foundation.dart';
import 'package:touch_of_the_unknown/editor/editor_node.dart';
import 'package:touch_of_the_unknown/editor/editor_transition.dart';
import 'dart:ui';

class EditorState {
  static final Map<String, EditorNode> nodes = <String, EditorNode>{};
  static final List<EditorTransition> transitions = List.empty(growable: true);
  static final ValueNotifier<List<EditorTransition>> transitionsNotifier = ValueNotifier<List<EditorTransition>>([]);
  static EditorNode? selectedNode;
  static EditorTransition? selectedTransition;
  static Offset? _storedOffset;
  static Offset? get storedOffset => _storedOffset;
  static set storedOffset(Offset? value) => _storedOffset = value;

  static void load() {
    final n1 = EditorNode()
      ..text = "Текст ноды 1"
      ..x = 0
      ..y = 0;
    
    final n2 = EditorNode()
      ..text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      ..x = 50
      ..y = 0;

    nodes[n1.id] = n1;
    nodes[n2.id] = n2;
    transitions.add(EditorTransition()
      ..from=n1.id
      ..to=n2.id
      ..text="Переход");
    transitions.add(EditorTransition()
      ..from=n1.id
      ..to=n2.id
      ..text="Переход");
    transitions.add(EditorTransition()
      ..from=n1.id
      ..to=n2.id
      ..text="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.");
    transitionsNotifier.value = List.from(transitions);

    final n3 = EditorNode()
      ..text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      ..x = 150
      ..y = 150;

    nodes[n3.id] = n3;
  }

  static void deleteTransition(String id) {
    if (EditorState.selectedTransition?.id == id) {
      EditorState.selectedTransition = null;
    }
    final idx = EditorState.transitions.indexWhere((t) => t.id == id);
    if (idx != -1) {
      EditorState.transitions.removeAt(idx);
      EditorState.transitionsNotifier.value = List.from(EditorState.transitions);
    }
  }

  static void deleteNode(String id) {
    if (EditorState.selectedNode?.id == id) {
      EditorState.selectedNode = null;
    }
    final node = EditorState.nodes[id];
    if (node != null) {
      EditorState.nodes.remove(node.id);
      EditorState.transitions.removeWhere((t) => t.from == node.id || t.to == node.id);
      EditorState.transitionsNotifier.value = List.from(EditorState.transitions);
    }
  }

  static bool hasNodeInPosition(int x, int y) {
    return nodes.values.where((n) => n.x == x && n.y == y).firstOrNull != null;
  }

  static void trySetNodePosition(String nodeId, int x, int y) {
    final node = EditorState.nodes[nodeId];
    if (node != null) {
      final newX = (x.toDouble() / 25).round() * 25;
      final newY = (y.toDouble() / 25).round() * 25;
      if (!hasNodeInPosition(newX, newY)) {
        node.x = newX;
        node.y = newY;
      }
    }
  }
}
