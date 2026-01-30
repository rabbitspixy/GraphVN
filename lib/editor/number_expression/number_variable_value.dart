
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_rich_text.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/modals/variable_selector.dart';
import 'package:graph_vn/editor/number_expression/number_expression.dart';
import 'package:graph_vn/editor/variables.dart';
import 'package:rational/rational.dart';

part 'number_variable_value.mapper.dart';

@MappableClass()
class NumberVariableValue extends NumberExpression with NumberVariableValueMappable {
  String variableId = "";

  NumberVariableValue();

  @MappableConstructor()
  NumberVariableValue.mappableConstructor({
    required this.variableId,
  }) : super.mappableConstructor();

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