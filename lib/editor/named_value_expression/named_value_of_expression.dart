
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_rich_text.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/modals/variable_selector.dart';
import 'package:graph_vn/editor/named_value_expression/named_value_expression.dart';
import 'package:graph_vn/editor/variables.dart';

part 'named_value_of_expression.mapper.dart';

@MappableClass()
class NamedValueOfExpression extends NamedValueExpression with NamedValueOfExpressionMappable {
  String variableId = "";

  NamedValueOfExpression();

  @MappableConstructor()
  NamedValueOfExpression.mappableConstructor({
    required this.variableId,
  }) : super.mappableConstructor();

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
    return NamedValueOfExpressionEditor(expression: this);
  }
}

class NamedValueOfExpressionEditor extends StatefulWidget {
  final NamedValueOfExpression expression;
  const NamedValueOfExpressionEditor({super.key, required this.expression});

  @override
  State<NamedValueOfExpressionEditor> createState() => _NamedValueOfExpressionEditorState();
}

class _NamedValueOfExpressionEditorState extends State<NamedValueOfExpressionEditor> {
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