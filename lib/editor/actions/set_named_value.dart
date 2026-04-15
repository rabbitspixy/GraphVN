import 'package:flutter/material.dart';
import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/editor/widgets/editor_rich_text.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/modals/variable_selector.dart';
import 'package:graph_vn/editor/named_value_expression/constant_named_value_expression.dart';
import 'package:graph_vn/editor/named_value_expression/named_value_expression.dart';
import 'package:graph_vn/editor/modals/named_value_expression_editor.dart';
import 'package:graph_vn/editor/variables.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';

class SetNamedValue extends BaseAction {
  String variableId = "";
  NamedValueExpression expression = ConstantNamedValueExpression();

  SetNamedValue();

  @override
  String actionText() {
    return "Set ${EditorState.variableName(variableId)} to ${expression.asText()}";
  }

  @override
  void exec() {
    final variable = EditorState.variableById(variableId);
    if (variable != null && variable is NamedVariable) {
      variable.value = expression.evaluate();
    }
  }

  @override
  AbstractActionProto toProto() {
    final result = ActionSetNamedValueProto();
    result.variableId = variableId;
    result.expression = expression.toProto();
    return AbstractActionProto()
        ..id = id
        ..setNamedValue = result;
  }

  factory SetNamedValue.fromProto(ActionSetNamedValueProto proto) {
    final result = SetNamedValue();
    result.variableId = proto.variableId;
    result.expression = NamedValueExpression.fromProto(proto.expression);
    return result;
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
        text: EditorState.variableName(widget.action.variableId), 
        tap: () async { 
          widget.action.variableId = (await showVariableSelector(context, VariableType.namedValue))?.id ?? "";
          setState(() {});
        }
      ),
      ETextSpan(text: 'to'),
      ETextSpan(
        text: widget.action.expression.asText(),
        tap: () async {
          final newNumberExpression = await editNamedValueExpression(context, widget.action.expression);
          if (newNumberExpression != null) {
            widget.action.expression = newNumberExpression;
            setState(() {});
          }
        }
      )
    ]);
  }
}