import 'package:touch_of_the_unknown/editor/editor_transition.dart';
import 'package:uuid/uuid.dart';

class EditorNode {
  String id = Uuid().v4();
  String text = "";
  List<EditorTransition> transitions = List.empty();

  int x = 0;
  int y = 0;
}