import 'package:flutter/material.dart';
import 'package:graph_vn/editor/named_number_expression/compare_numbers_expression.dart';
import 'package:graph_vn/editor/named_number_expression/constant_named_value_expression.dart';
import 'package:graph_vn/editor/named_number_expression/named_value_expression.dart';

Future<NamedValueExpression?> editNamedValueExpression(BuildContext context, NamedValueExpression namedNumberExpression, {bool allowChangeType = true}) async {
  NamedValueExpression current = namedNumberExpression;
  NamedExpressionType currentType = NamedExpressionType.values.singleWhere((item) => item.type == current.runtimeType);

  final result = await showDialog<NamedValueExpression>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: switch (allowChangeType) {
              true => DropdownButton<NamedExpressionType>(
                value: currentType,
                items: NamedExpressionType.values.map((item) {
                  return DropdownMenuItem(value: item, child: Text(item.title));
                }).toList(),
                onChanged: (NamedExpressionType? newType) {
                  if (newType == null || newType == currentType) return;
                  setState(() {
                    currentType = newType;
                    current = newType.create(namedNumbersTypeId: current.namedNumbersTypeId);
                  });
                },
              ),
              false => Text(currentType.title)
            },
            content: SizedBox(
              width: 400,
              height: 300,
              child: switch (current) {
                ConstantNamedValueExpression exp => ConstantNamedValueExpressionEditor(expression: exp),
                CompareNumbersExpression exp => BooleanNumberExpressionEditor(expression: exp),
                _ => const Placeholder(),
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (current.isValid()) {
                    Navigator.of(context).pop(current);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );

  return result;
}
