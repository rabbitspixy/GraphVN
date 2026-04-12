import 'package:flutter/material.dart';
import 'package:graph_vn/editor/widgets/editor_rich_text.dart';
import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';

class DoNothing extends BaseAction {

  DoNothing();

  @override
  String actionText() {
    return "Do nothing";
  }

  @override
  void exec() {
    // do nothing
  }

  @override
  AbstractActionProto toProto() {
    final result = ActionDoNothingProto();
    return AbstractActionProto()
        ..id = id
        ..doNothing = result;
  }

  factory DoNothing.fromProto(ActionDoNothingProto proto) {
    final result = DoNothing();
    return result;
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