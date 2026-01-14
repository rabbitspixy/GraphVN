

import 'package:flutter/foundation.dart';
import 'package:touch_of_the_unknown/editor/editor_node.dart';
import 'package:touch_of_the_unknown/editor/editor_transition.dart';
import 'dart:ui';

class EditorState {
  static final Map<String, EditorNode> nodes = <String, EditorNode>{};
  static final List<EditorTransition> transitions = List.empty(growable: true);
  static final ValueNotifier<List<EditorTransition>> transitionsNotifier = ValueNotifier<List<EditorTransition>>([]);
  // <‑‑ NEW: store the last canvas offset
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
}
