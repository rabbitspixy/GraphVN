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

class SetNumberValue extends BaseAction {
  String variableId = "";
  NumberExpression numberExpression = ConstantNumberExpression();

  SetNumberValue();

  @override
  String actionText() {
    return "Set ${EditorState.variableName(variableId)} to ${numberExpression.asText()}";
  }

  @override
  void exec() {
    final variable = EditorState.variableById(variableId);
    if (variable != null && variable is NumberVariable) {
      variable.value = numberExpression.evaluate();
    }
  }

  @override
  AbstractActionProto toProto() {
    final result = ActionSetNumberValueProto();
    result.variableId = variableId;
    result.expression = numberExpression.toProto();
    return AbstractActionProto()
        ..id = id
        ..setNumberValue = result;
  }

  factory SetNumberValue.fromProto(ActionSetNumberValueProto proto) {
    final result = SetNumberValue();
    result.variableId = proto.variableId;
    result.numberExpression = NumberExpression.fromProto(proto.expression);
    return result;
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
        text: EditorState.variableName(widget.action.variableId), 
        tap: () async { 
          widget.action.variableId = (await showVariableSelector(context, VariableType.number))?.id ?? "";
          setState(() {});
        }
      ),
      ETextSpan(text: 'to'),
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