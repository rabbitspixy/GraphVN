import 'package:flutter/material.dart';
import 'package:graph_vn/editor/widgets/editor_rich_text.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/modals/variable_selector.dart';
import 'package:graph_vn/editor/number_expression/number_expression.dart';
import 'package:graph_vn/editor/variables.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:rational/rational.dart';

class NumberVariableValue extends NumberExpression {
  String variableId = "";

  NumberVariableValue();

  @override
  String asText() {
    return EditorState.variableName(variableId);
  }

  @override
  Rational evaluate() {
    final variable = EditorState.variableById(variableId);
    if (variable != null && variable is NumberVariable) {
      return variable.value;
    }
    throw Exception('variable is null or wrong type');
  }

  @override
  bool isValid() {
    final variable = EditorState.variableById(variableId);
    return variable != null && variable is NumberVariable;
  }

  @override
  Widget widgetEditor() {
    return NumberVariableValueEditor(expression: this);
  }

  @override
  NumberExpressionProto toProto() {
    final result = NumberVariableValueProto();
    result.variableId = variableId;
    return NumberExpressionProto()
        ..numberVariableValue = result;
  }

  factory NumberVariableValue.fromProto(NumberVariableValueProto proto) {
    final result = NumberVariableValue();
    result.variableId = proto.variableId;
    return result;
  }
}

class NumberVariableValueEditor extends StatefulWidget {
  final NumberVariableValue expression;
  const NumberVariableValueEditor({super.key, required this.expression});

  @override
  State<NumberVariableValueEditor> createState() => _NumberVariableValueEditorState();
}

class _NumberVariableValueEditorState extends State<NumberVariableValueEditor> {
  @override
  Widget build(BuildContext context) {
    return EditorRichText([
      ETextSpan(
        text: EditorState.variableName(widget.expression.variableId), 
        tap: () async { 
          final selectedVariable = await showVariableSelector(context, VariableType.number);
          if (selectedVariable != null) {
            widget.expression.variableId = selectedVariable.id;
            setState(() {});
          }
        }
      ),
    ]);
  }
}