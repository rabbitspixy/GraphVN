import 'package:flutter/material.dart';
import 'package:graph_vn/editor/named_value_expression/named_value_expression.dart';

List<DropdownMenuItem<NamedValueExpressionType>> _dropdownItems() {
  var types = NamedValueExpressionType.values;
  return types.map((item) => DropdownMenuItem(value: item, child: Text(item.title))).toList();
}

Future<NamedValueExpression?> editNamedValueExpression(
  BuildContext context,
  NamedValueExpression namedNumberExpression, {
  bool allowChangeType = true,
}) async {
  NamedValueExpression current = namedNumberExpression;
  NamedValueExpressionType currentType = NamedValueExpressionType.of(current);

  final result = await showDialog<NamedValueExpression>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: switch (allowChangeType) {
              true => DropdownButton<NamedValueExpressionType>(
                value: currentType,
                items: _dropdownItems(),
                onChanged: (NamedValueExpressionType? newType) {
                  if (newType == null || newType == currentType) return;
                  setState(() {
                    currentType = newType;
                    current = newType.create();
                  });
                },
              ),
              false => Text(currentType.title),
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
