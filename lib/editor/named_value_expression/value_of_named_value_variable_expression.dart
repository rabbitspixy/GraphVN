import 'package:flutter/material.dart';
import 'package:graph_vn/editor/widgets/editor_rich_text.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/modals/variable_selector.dart';
import 'package:graph_vn/editor/named_value_expression/named_value_expression.dart';
import 'package:graph_vn/editor/variables.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';

class ValueOfNamedValueVariableExpression extends NamedValueExpression {
  String variableId = "";

  ValueOfNamedValueVariableExpression();

  @override
  String asText() {
    return EditorState.variableName(variableId);
  }

  @override
  String evaluate() {
    final variable = EditorState.variableById(variableId);
    if (variable != null && variable is NamedVariable) {
      return variable.value;
    }
    throw Exception('variable is null or wrong type');
  }

  @override
  bool isValid() {
    final variable = EditorState.variableById(variableId);
    return variable != null && variable is NamedVariable;
  }

  @override
  Widget widgetEditor() {
    return ValueOfNamedValueVariableExpressionEditor(expression: this);
  }

  @override
  NamedValueExpressionProto toProto() {
    final result = ValueOfNamedValueVariableExpressionProto();
    result.variableId = variableId;
    return NamedValueExpressionProto()
        ..valueOfNamedValueVariableExpression = result;
  }

  factory ValueOfNamedValueVariableExpression.fromProto(ValueOfNamedValueVariableExpressionProto proto) {
    final result = ValueOfNamedValueVariableExpression();
    result.variableId = proto.variableId;
    return result;
  }
}

class ValueOfNamedValueVariableExpressionEditor extends StatefulWidget {
  final ValueOfNamedValueVariableExpression expression;
  const ValueOfNamedValueVariableExpressionEditor({super.key, required this.expression});

  @override
  State<ValueOfNamedValueVariableExpressionEditor> createState() => _ValueOfNamedValueVariableExpressionEditorState();
}

class _ValueOfNamedValueVariableExpressionEditorState extends State<ValueOfNamedValueVariableExpressionEditor> {
  @override
  Widget build(BuildContext context) {
    return EditorRichText([
      ETextSpan(
        text: EditorState.variableName(widget.expression.variableId), 
        tap: () async { 
          final selectedVariable = await showVariableSelector(context, VariableType.namedNumber);
          if (selectedVariable != null) {
            widget.expression.variableId = selectedVariable.id;
            setState(() {});
          }
        }
      ),
    ]);
  }
}