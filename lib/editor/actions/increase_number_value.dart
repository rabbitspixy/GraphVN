import 'package:flutter/material.dart';
import 'package:graph_vn/editor/widgets/editor_rich_text.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/number_expression/constant_number_expression.dart';
import 'package:graph_vn/editor/number_expression/number_expression.dart';
import 'package:graph_vn/editor/modals/number_expression_editor.dart';
import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/editor/modals/variable_selector.dart';
import 'package:graph_vn/editor/variables.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';

class IncreaseNumberValue extends BaseAction {
  String variableId = "";
  NumberExpression numberExpression = ConstantNumberExpression();

  IncreaseNumberValue();

  @override
  String actionText() {
    return "Increase ${EditorState.variableName(variableId)} by ${numberExpression.asText()}";
  }

  @override
  void exec() {
    final variable = EditorState.variableById(variableId);
    if (variable != null && variable is NumberVariable) {
      variable.value = variable.value + numberExpression.evaluate();
    }
  }

  @override
  AbstractActionProto toProto() {
    final result = ActionIncreaseNumberValueProto();
    result.variableId = variableId;
    result.expression = numberExpression.toProto();
    return AbstractActionProto()
        ..id = id
        ..increaseNumberValue = result;
  }

  factory IncreaseNumberValue.fromProto(ActionIncreaseNumberValueProto proto) {
    final result = IncreaseNumberValue();
    result.variableId = proto.variableId;
    result.numberExpression = NumberExpression.fromProto(proto.expression);
    return result;
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
        text: EditorState.variableName(widget.action.variableId), 
        tap: () async { 
          final selectedVariable = await showVariableSelector(context, VariableType.number);
          if (selectedVariable != null) {
            widget.action.variableId = selectedVariable.id;
            setState(() {});
          }
        }
      ),
      ETextSpan(text: 'by'),
      ETextSpan(
        text: widget.action.numberExpression.asText(),
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