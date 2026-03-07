import 'package:flutter/material.dart';
import 'package:graph_vn/editor/number_expression/number_expression.dart';

Future<NumberExpression?> editNumberExpression(BuildContext context, NumberExpression numberExpression, {bool allowChangeType = true}) async {
  NumberExpression current = numberExpression;
  NumberExpressionType currentType = NumberExpressionType.of(current);

  final result = await showDialog<NumberExpression>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: switch (allowChangeType) {
              true => DropdownButton<NumberExpressionType>(
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
              false => Text(currentType.title)
            },
            content: SizedBox(
              width: 400,
              height: 300,
              child: current.widgetEditor(),
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
