import 'package:flutter/material.dart';
import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/editor/editor_rich_text.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/modals/variable_selector.dart';
import 'package:graph_vn/editor/named_number_expression/constant_named_number_expression.dart';
import 'package:graph_vn/editor/named_number_expression/named_number_expression.dart';
import 'package:graph_vn/editor/named_number_expression/named_number_expression_editor.dart';
import 'package:graph_vn/editor/variables.dart';

class SetNamedValue extends BaseAction {
  String variableId = "";
  NamedNumberExpression expression = ConstantNamedNumberExpression(namedNumbersTypeId: namedNumbersTypes.first.id);

  void recreateExpressionIfNotValid() {
    final variable = EditorState.variableById(variableId);
    if (variable == null) {
      return;
    }
    if (variable is NamedNumberVariable) {
      if (variable.typeId != expression.namedNumbersTypeId) {
        expression = ConstantNamedNumberExpression(namedNumbersTypeId: variable.typeId);
      }
    }
  }

  @override
  String actionText() {
    return "Set ${EditorState.variableAsString(variableId)} to ${expression.asString()}";
  }

  @override
  void exec() {
    final variable = EditorState.variableById(variableId);
    if (variable != null && variable is NamedNumberVariable) {
      variable.value = expression.evaluate();
    }
  }
}

class SetNamedValueEditor extends StatefulWidget {
  final SetNamedValue action;
  const SetNamedValueEditor({super.key, required this.action});

  @override
  State<SetNamedValueEditor> createState() => _SetNamedValueEditorState();
}

class _SetNamedValueEditorState extends State<SetNamedValueEditor> {
  @override
  Widget build(BuildContext context) {
    return EditorRichText([
      ETextSpan(text: 'Set'),
      ETextSpan(
        text: EditorState.variableAsString(widget.action.variableId), 
        tap: () async { 
          widget.action.variableId = (await showVariableSelector(context, VariableType.namedNumber))?.id ?? "";
          widget.action.recreateExpressionIfNotValid();
          setState(() {});
        }
      ),
      ETextSpan(text: 'to'),
      ETextSpan(
        text: widget.action.expression.asString(),
        tap: () async {
          final newNumberExpression = await editNamedNumberExpression(context, widget.action.expression);
          if (newNumberExpression != null) {
            widget.action.expression = newNumberExpression;
            setState(() {});
          }
        }
      )
    ]);
  }
}