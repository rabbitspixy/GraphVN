

import 'package:touch_of_the_unknown/editor/editor_node.dart';
import 'package:touch_of_the_unknown/editor/editor_transition.dart';

class EditorState {
  static final Map<String, EditorNode> nodes = <String, EditorNode>{};
  static final List<EditorTransition> transitions = List.empty(growable: true);

  static void load() {
    final n1 = EditorNode()
      ..text = "Текст ноды 1"
      ..x = 0
      ..y = 0;
    
    final n2 = EditorNode()
      ..text = "Текст 2"
      ..x = 50
      ..y = 0;

    nodes[n1.id] = n1;
    nodes[n2.id] = n2;
    transitions.add(EditorTransition()..from=n1.id..to=n2.id);
  }
}
