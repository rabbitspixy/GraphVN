import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_rich_text.dart';
import 'package:graph_vn/editor/struct.dart';
import 'package:graph_vn/editor/struct_actions/base.dart';

class DoNothing extends StructAction {

  DoNothing(Struct struct) : super(struct: struct);

  @override
  String actionText() {
    return "Do nothing";
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