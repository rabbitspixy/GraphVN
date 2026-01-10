import 'package:uuid/uuid.dart';

class EditorTransition {
  String id = Uuid().v4();
  String text = "";
  String from = "";
  String to = "";
}