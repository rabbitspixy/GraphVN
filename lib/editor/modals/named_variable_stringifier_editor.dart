import 'package:flutter/material.dart';
import 'package:graph_vn/editor/named_variable_stringifier.dart';
import 'package:graph_vn/editor/variables.dart';

/// Opens a modal dialog to edit a [NamedVariableStringifier].
/// The dialog shows a text field for the template and a vertical list of
/// buttons representing the provided [namedValues]. The user can select a
/// value by tapping a button, which sets the `valueId` of the stringifier.
/// When the user taps **Save**, a new [NamedVariableStringifier] with the
/// updated fields is returned. If the user taps **Cancel**, `null` is returned.
///
/// Example usage:
/// ```dart
/// final updated = await editNamedVariableStringifier(
///   context,
///   existingStringifier,
///   namedValues,
/// );
/// if (updated != null) {
///   // use updated
/// }
/// ```
Future<NamedVariableStringifier?> editNamedVariableStringifier(
  BuildContext context,
  NamedVariableStringifier stringifier,
  List<NamedValue> namedValues,
) async {
  String valueId = stringifier.valueId;
  String template = stringifier.template;
  String? selectedValueId = valueId.isNotEmpty ? valueId : null;

  final result = await showDialog<NamedVariableStringifier>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Named Variable Stringifier'),
            content: SizedBox(
              width: 400,
              height: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Select Value:'),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: namedValues.length,
                      itemBuilder: (context, index) {
                        final nv = namedValues[index];
                        final isSelected = nv.id == selectedValueId;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isSelected ? Colors.blue : null,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedValueId = nv.id;
                                valueId = nv.id;
                              });
                            },
                            child: Text(nv.name),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Template'),
                    controller: TextEditingController(text: template),
                    onChanged: (val) => template = val,
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
                  Navigator.of(context).pop(
                    NamedVariableStringifier(
                      valueId: valueId,
                      template: template,
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

  return result;
}
