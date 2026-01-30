import 'package:flutter/material.dart';
import 'package:graph_vn/editor/named_number_expression/compare_numbers_expression.dart';
import 'package:graph_vn/editor/named_number_expression/constant_named_number_expression.dart';
import 'package:graph_vn/editor/named_number_expression/named_number_expression.dart';

Future<NamedNumberExpression?> editNamedNumberExpression(BuildContext context, NamedNumberExpression namedNumberExpression, {bool allowChangeType = true}) async {
  NamedNumberExpression current = namedNumberExpression;
  NamedNumberExpressionType currentType = NamedNumberExpressionType.values.singleWhere((item) => item.type == current.runtimeType);

  final result = await showDialog<NamedNumberExpression>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: switch (allowChangeType) {
              true => DropdownButton<NamedNumberExpressionType>(
                value: currentType,
                items: NamedNumberExpressionType.values.map((item) {
                  return DropdownMenuItem(value: item, child: Text(item.title));
                }).toList(),
                onChanged: (NamedNumberExpressionType? newType) {
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
                ConstantNamedNumberExpression exp => ConstantNamedNumberExpressionEditor(expression: exp),
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
