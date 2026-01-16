import 'package:uuid/uuid.dart';

class EditorNode {
  String id = Uuid().v4();
  String text = '';

  int x = 0;
  int y = 0;
  bool isStart = false;
}
