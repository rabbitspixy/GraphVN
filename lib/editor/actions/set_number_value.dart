import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_rich_text.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/number_expression/constant_number_expression.dart';
import 'package:graph_vn/editor/number_expression/number_expression.dart';
import 'package:graph_vn/editor/number_expression/number_expression_editor.dart';
import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/editor/modals/variable_selector.dart';

class SetNumberValue extends BaseAction {
  String variableId = "";
  NumberExpression numberExpression = ConstantNumberExpression();

  @override
  String actionText() {
    return "Set ${EditorState.variableAsString(variableId)} to ${numberExpression.asString()}";
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
        text: EditorState.variableAsString(widget.action.variableId), 
        tap: () async { 
          widget.action.variableId = (await showVariableSelector(context))?.id ?? "";
          setState(() {});
        }
      ),
      ETextSpan(text: 'to'),
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