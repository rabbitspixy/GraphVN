import 'package:flutter/material.dart';
import 'package:graph_vn/editor/first_match_condition_item.dart';
import 'package:graph_vn/editor/modals/named_number_expression_editor.dart';
import 'package:graph_vn/editor/named_value_expression/named_value_expression.dart';

Future<FirstMatchConditionItem?> editFirstMatchConditionItem(
  BuildContext context,
  FirstMatchConditionItem item,
) async {
  NamedValueExpression expression = item.expression;
  FirstMatchResult result = item.action;

  final updated = await showDialog<FirstMatchConditionItem>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final edited = await editNamedValueExpression(
                      context,
                      expression,
                      allowChangeType: true,
                    );
                    if (edited != null) {
                      setState(() {
                        expression = edited;
                      });
                    }
                  },
                  child: const Text('Edit Expression'),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Expression: ${expression.asText()}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('Pass'),
                      selected: result == FirstMatchResult.pass,
                      onSelected: (_) {
                        setState(() {
                          result = FirstMatchResult.pass;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Fail'),
                      selected: result == FirstMatchResult.fail,
                      onSelected: (_) {
                        setState(() {
                          result = FirstMatchResult.fail;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    FirstMatchConditionItem(
                      expression: expression,
                      action: result,
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );

  return updated;
}
