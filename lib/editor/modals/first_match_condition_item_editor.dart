import 'package:flutter/material.dart';
import 'package:graph_vn/editor/first_match_condition_item.dart';
import 'package:graph_vn/editor/modals/named_number_expression_editor.dart';

/// Opens a modal dialog to edit a [FirstMatchConditionItem].
/// The dialog first allows the user to edit the [expression] using
/// [editNamedValueExpression] with `allowChangeType: false`.  If the user
/// cancels that step, the whole edit is cancelled and `null` is returned.
///
/// After a successful expression edit, the dialog shows two buttons
/// allowing the user to choose the desired [FirstMatchResult] (`pass` or
/// `fail`).  If the user cancels this step, `null` is returned.
///
/// If both steps succeed, a new [FirstMatchConditionItem] with the
/// updated fields is returned.
///
/// Example usage:
/// ```dart
/// final updated = await editFirstMatchConditionItem(context, item);
/// if (updated != null) {
///   // use updated
/// }
/// ```
Future<FirstMatchConditionItem?> editFirstMatchConditionItem(
  BuildContext context,
  FirstMatchConditionItem item,
) async {
  // Step 1: Edit the expression
  final editedExpression = await editNamedValueExpression(
    context,
    item.expression,
    allowChangeType: true,
  );
  if (editedExpression == null) {
    return null; // user cancelled expression editing
  }

  // Step 2: Choose the result
  final result = await showDialog<FirstMatchResult>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Select Result'),
        content: const Text('Choose the result for this condition:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(FirstMatchResult.pass),
            child: const Text('Pass'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(FirstMatchResult.fail),
            child: const Text('Fail'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );

  if (result == null) {
    return null; // user cancelled result selection
  }

  // Return a new instance with updated values
  return FirstMatchConditionItem(
    expression: editedExpression,
    action: result,
  );
}
