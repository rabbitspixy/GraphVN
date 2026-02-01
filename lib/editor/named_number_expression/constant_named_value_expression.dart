import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/named_number_expression/named_value_expression.dart';
import 'package:graph_vn/editor/variables.dart';

part 'constant_named_value_expression.mapper.dart';

@MappableClass()
class ConstantNamedValueExpression extends NamedValueExpression with ConstantNamedValueExpressionMappable {
  String value = "";

  ConstantNamedValueExpression({required super.namedNumbersTypeId}) {
    value = namedVariableTypes.where((type) => type.id == namedNumbersTypeId).first.list.first.id;
  }

  @MappableConstructor()
  ConstantNamedValueExpression.mappableConstructor({
    required super.namedNumbersTypeId,
    required this.value,
  }) : super.mappableConstructor();

  @override
  String evaluate() {
    return value;
  }

  @override
  String asText() {
    return EditorState.namedValue(namedNumbersTypeId, value)?.name ?? "?";
  }

  @override
  bool isValid() {
    return true;
  }

  @override
  Widget widgetEditor() {
    return ConstantNamedValueExpressionEditor(expression: this);
  }
}

class ConstantNamedValueExpressionEditor extends StatefulWidget {
  final ConstantNamedValueExpression expression;
  const ConstantNamedValueExpressionEditor({
    super.key,
    required this.expression,
  });

  @override
  State<ConstantNamedValueExpressionEditor> createState() => _ConstantNamedValueExpressionEditorState();
}

class _ConstantNamedValueExpressionEditorState extends State<ConstantNamedValueExpressionEditor> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.expression.value,
      items: namedVariableTypes.where((t) => t.id == widget.expression.namedNumbersTypeId).first.list.map((item) {
        return DropdownMenuItem(value: item.id, child: Text(item.name));
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          if (newValue != null) {
            widget.expression.value = newValue;
          }
        });
      },
    );
  }
}