import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:graph_vn/editor/widgets/editor_rich_text.dart';
import 'package:graph_vn/editor/actions/base.dart';

part 'package:graph_vn/generated/editor/actions/do_nothing.mapper.dart';

@MappableClass()
class DoNothing extends BaseAction with DoNothingMappable {

  DoNothing();

  @MappableConstructor()
  DoNothing.mappableConstructor({
    required super.id,
  }) : super.mappableConstructor();

  @override
  String actionText() {
    return "Do nothing";
  }

  @override
  void exec() {
    // do nothing
  }
}

class DoNothingEditor extends StatefulWidget {
  final DoNothing action;
  const DoNothingEditor({super.key, required this.action});

  @override
  State<DoNothingEditor> createState() => _DoNothingEditorState();
}

class _DoNothingEditorState extends State<DoNothingEditor> {
  @override
  Widget build(BuildContext context) {
    return EditorRichText([
      ETextSpan(text: 'Do nothing')
    ]);
  }
}