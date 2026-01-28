import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:graph_vn/editor/named_number_expression/named_number_expression.dart';
import 'package:graph_vn/editor/variables.dart';

part 'constant_named_number_expression.mapper.dart';

@MappableClass(discriminatorValue: 'ConstantNamedNumberExpression')
class ConstantNamedNumberExpression extends NamedNumberExpression with ConstantNamedNumberExpressionMappable {
  String value = "";
  bool _isValid = true;

  ConstantNamedNumberExpression({required super.namedNumbersTypeId}) {
    value = namedNumbersTypes.where((t) => t.id == namedNumbersTypeId).first.list.first.key;
  }

  @MappableConstructor()
  ConstantNamedNumberExpression.mappableConstructor({
    required super.namedNumbersTypeId,
    required this.value,
  }) : super.mappableConstructor();

  @override
  String evaluate() {
    return value;
  }

  @override
  String asString() {
    return value.toString();
  }

  @override
  bool isValid() {
    return _isValid;
  }
}

class ConstantNamedNumberExpressionEditor extends StatefulWidget {
  final ConstantNamedNumberExpression expression;
  const ConstantNamedNumberExpressionEditor({
    super.key,
    required this.expression,
  });

  @override
  State<ConstantNamedNumberExpressionEditor> createState() => _ConstantNamedNumberExpressionEditorState();
}

class _ConstantNamedNumberExpressionEditorState extends State<ConstantNamedNumberExpressionEditor> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.expression.value,
      items: namedNumbersTypes.where((t) => t.id == widget.expression.namedNumbersTypeId).first.list.map((item) {
        return DropdownMenuItem(value: item.key, child: Text(item.key));
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