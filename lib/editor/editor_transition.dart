import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/services.dart';
import 'package:graph_vn/editor/transition_position.dart';
import 'package:uuid/uuid.dart';

part 'editor_transition.mapper.dart';

@MappableClass()
class EditorTransition with EditorTransitionMappable {
  String id = Uuid().v4();
  String text = "";
  String from = "";
  String to = "";

  bool get isButton => text.isNotEmpty;

  TransitionPosition pos = TransitionPosition(
    start: Offset(0, 0),
    end: Offset(0, 0),
    control: Offset(0, 0),
    center: Offset(0, 0),
    direction: 0,
  );

  EditorTransition();

  @MappableConstructor()
  EditorTransition.mappableConstructor({
    required this.id,
    required this.text,
    required this.from,
    required this.to,
  });
}