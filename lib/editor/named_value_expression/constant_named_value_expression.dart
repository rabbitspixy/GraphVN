import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/named_value_expression/named_value_expression.dart';
import 'package:graph_vn/editor/variables.dart';

part 'package:graph_vn/generated/editor/named_value_expression/constant_named_value_expression.mapper.dart';

@MappableClass()
class ConstantNamedValueExpression extends NamedValueExpression with ConstantNamedValueExpressionMappable {
  String valueId = "";

  ConstantNamedValueExpression();

  @MappableConstructor()
  ConstantNamedValueExpression.mappableConstructor({
    required this.valueId,
  }) : super.mappableConstructor();

  @override
  String evaluate() {
    return valueId;
  }

  @override
  String asText() {
    return EditorState.namedValue(valueId)?.name ?? "?";
  }

  @override
  bool isValid() {
    return true;
  }

  @override
  Widget widgetEditor() {
    return ConstantNamedValueExpressionEditor(expression: this);
  }

  NamedValuesType? type() {
    return EditorState.namedValueType(valueId);
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: namedVariableTypes.expand((t) => t.list).map((item) {
        final bool isSelected = item.id == widget.expression.valueId;
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: isSelected ? Theme.of(context).primaryColor.withAlpha(50) : null,
          ),
          onPressed: () {
            setState(() {
              widget.expression.valueId = item.id;
            });
          },
          child: Text(item.name),
        );
      }).toList(),
    );
  }
}
