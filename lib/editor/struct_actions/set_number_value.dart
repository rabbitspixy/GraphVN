import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_rich_text.dart';
import 'package:graph_vn/editor/struct.dart';
import 'package:graph_vn/editor/struct_actions/base.dart';
import 'package:graph_vn/editor/widgets/variable_selector.dart';
import 'package:rational/rational.dart';

class SetNumberValue extends StructAction {
  String variableId = "";
  Rational newValue = Rational.zero;

  SetNumberValue(Struct struct) : super(struct: struct);

  String variableName() {
    return struct.variableById(variableId)?.name ?? 'variable';
  }

  String numberValueAsString() {
    return newValue.toString();
  }

  @override
  String actionText() {
    return "Set ${variableName()} to ${numberValueAsString()}";
  }
}

class SetNumberValueEditor extends StatefulWidget {
  final SetNumberValue action;
  const SetNumberValueEditor({super.key, required this.action});

  @override
  State<SetNumberValueEditor> createState() => _SetNumberValueEditorState();
}

class _SetNumberValueEditorState extends State<SetNumberValueEditor> {
  @override
  Widget build(BuildContext context) {
    return EditorRichText([
      ETextSpan(text: 'Set'),
      ETextSpan(
        text: widget.action.variableName(), 
        tap: () async { 
          widget.action.variableId = (await showVariableSelector(context, widget.action.struct))?.id ?? "";
          setState(() {});
        }
      ),
      ETextSpan(text: 'to'),
      ETextSpan(text: widget.action.numberValueAsString(), tap: () {})
    ]);
  }
}