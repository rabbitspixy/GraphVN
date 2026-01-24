import 'package:flutter/material.dart';
import 'package:graph_vn/editor/number_expression/constant_number_expression.dart';
import 'package:graph_vn/editor/number_expression/number_expression.dart';

Future<NumberExpression?> editNumberExpression(BuildContext context, NumberExpression numberExpression) async {
  NumberExpression current = numberExpression;
  NumberExpressionType currentType = NumberExpressionType.values.singleWhere((item) => item.type == current.runtimeType);

  final result = await showDialog<NumberExpression>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: DropdownButton<NumberExpressionType>(
              value: currentType,
              items: NumberExpressionType.values.map((item) {
                return DropdownMenuItem(value: item, child: Text(item.title));
              }).toList(),
              onChanged: (NumberExpressionType? newType) {
                if (newType == null || newType == currentType) return;
                setState(() {
                  currentType = newType;
                  current = newType.create();
                });
              },
            ),
            content: SizedBox(
              width: 400,
              height: 300,
              child: switch (current) {
                ConstantNumberExpression _ => ConstantNumberExpressionEditor(
                  expression: current as ConstantNumberExpression,
                  onValidityChanged: (valid) {
                    setState(() {
                      isValid = valid;
                    });
                  },
                ),
                _ => const Placeholder(),
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isValid ? () => Navigator.of(context).pop(current) : null,
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
