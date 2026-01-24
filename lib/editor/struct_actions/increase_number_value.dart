import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_rich_text.dart';
import 'package:graph_vn/editor/struct.dart';
import 'package:graph_vn/editor/struct_actions/base.dart';
import 'package:graph_vn/editor/widgets/variable_selector.dart';
import 'package:rational/rational.dart';

class IncreaseNumberValue extends StructAction {
  String variableId = "";
  Rational increaseValue = Rational.zero;

  IncreaseNumberValue(Struct struct) : super(struct: struct);

  String variableName() {
    return struct.variableById(variableId)?.name ?? 'variable';
  }

  String numberValueAsString() {
    return increaseValue.toString();
  }

  @override
  String actionText() {
    return "Increase ${variableName()} by ${numberValueAsString()}";
  }
}

class IncreaseNumberValueEditor extends StatefulWidget {
  final IncreaseNumberValue action;
  const IncreaseNumberValueEditor({super.key, required this.action});

  @override
  State<IncreaseNumberValueEditor> createState() => _IncreaseNumberValueEditorState();
}

class _IncreaseNumberValueEditorState extends State<IncreaseNumberValueEditor> {
  @override
  Widget build(BuildContext context) {
    return EditorRichText([
      ETextSpan(text: 'Increase'),
      ETextSpan(
        text: widget.action.variableName(), 
        tap: () async { 
          widget.action.variableId = (await showVariableSelector(context, widget.action.struct))?.id ?? "";
          setState(() {});
        }
      ),
      ETextSpan(text: 'by'),
      ETextSpan(text: widget.action.numberValueAsString(), tap: () {})
    ]);
  }
}