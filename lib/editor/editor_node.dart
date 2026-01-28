import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'editor_node.mapper.dart';

@MappableClass()
class EditorNode with EditorNodeMappable {
  String id = Uuid().v4();
  String text = '';
  String label = '';
  int x = 0;
  int y = 0;
  bool isStart = false;
  List<String> procedureIds = [];
  String imagePath = "";

  bool get isEmpty => text.isEmpty;

  EditorNode();

  @MappableConstructor()
  EditorNode.mappableConstructor({
    required this.id,
    required this.text,
    required this.label,
    required this.x,
    required this.y,
    required this.isStart,
    List<String>? procedureIds,
    this.imagePath = "",
  }) {
    this.procedureIds = procedureIds ?? [];
  }
}
