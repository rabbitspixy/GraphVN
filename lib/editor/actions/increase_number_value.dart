import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_rich_text.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/number_expression/constant_number_expression.dart';
import 'package:graph_vn/editor/number_expression/number_expression.dart';
import 'package:graph_vn/editor/number_expression/number_expression_editor.dart';
import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/editor/modals/variable_selector.dart';

class IncreaseNumberValue extends BaseAction {
  String variableId = "";
  NumberExpression numberExpression = ConstantNumberExpression();

  @override
  String actionText() {
    return "Increase ${EditorState.variableAsString(variableId)} by ${numberExpression.asString()}";
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
        text: EditorState.variableAsString(widget.action.variableId), 
        tap: () async { 
          final selectedVariable = await showVariableSelector(context);
          if (selectedVariable != null) {
            widget.action.variableId = selectedVariable.id;
            setState(() {});
          }
        }
      ),
      ETextSpan(text: 'by'),
      ETextSpan(
        text: widget.action.numberExpression.asString(),
        tap: () async {
          final newNumberExpression = await editNumberExpression(context, widget.action.numberExpression);
          if (newNumberExpression != null) {
            widget.action.numberExpression = newNumberExpression;
            setState(() {});
          }
        }
      )
    ]);
  }
}