import 'package:flutter/material.dart';
import 'package:rational/rational.dart';
import 'package:graph_vn/editor/number_variable_stringifier.dart';

/// Opens a modal dialog to edit a [NumberVariableStringifier].
/// The dialog contains text fields for [rangeStart], [rangeEnd] and [template].
/// If the user presses **Save**, a new [NumberVariableStringifier] with the
/// updated values is returned. If the user cancels, `null` is returned.
///
/// Example usage:
/// ```dart
/// final updated = await editNumberVariableStringifier(context, existing);
/// if (updated != null) {
///   // use updated
/// }
/// ```
Future<NumberVariableStringifier?> editNumberVariableStringifier(
  BuildContext context,
  NumberVariableStringifier stringifier,
) async {
  final startController = TextEditingController(
    text: stringifier.rangeStart.toString(),
  );
  final endController = TextEditingController(
    text: stringifier.rangeEnd.toString(),
  );
  final templateController = TextEditingController(
    text: stringifier.template,
  );

  return await showDialog<NumberVariableStringifier>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Number Variable Stringifier'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: startController,
                    decoration: const InputDecoration(
                      labelText: 'Range Start',
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: endController,
                    decoration: const InputDecoration(
                      labelText: 'Range End',
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: templateController,
                    decoration: const InputDecoration(
                      labelText: 'Template',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  try {
                    final newStart = Rational.parse(startController.text);
                    final newEnd = Rational.parse(endController.text);
                    final newTemplate = templateController.text;
                    Navigator.of(context).pop(
                      NumberVariableStringifier(
                        rangeStart: newStart,
                        rangeEnd: newEnd,
                        template: newTemplate,
                      ),
                    );
                  } catch (_) {
                    // If parsing fails, keep dialog open
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
}
