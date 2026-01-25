import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'editor_transition.mapper.dart';

@MappableClass()
class EditorTransition with EditorTransitionMappable {
  String id = Uuid().v4();
  String text = "";
  String from = "";
  String to = "";

  EditorTransition();

  @MappableConstructor()
  EditorTransition.mappableConstructor({
    required this.id,
    required this.text,
    required this.from,
    required this.to,
  });
}