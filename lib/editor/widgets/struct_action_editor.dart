import 'package:flutter/material.dart';
import 'package:graph_vn/editor/struct_actions.dart';

/// Opens a modal dialog to edit a [StructAction].
/// The dialog contains:
/// * A dropdown at the top to select the concrete type of the action.
///   Changing the selection creates a new instance of the chosen type.
/// * The widget returned by `action.edit()` in the center.
/// * Save / Cancel buttons at the bottom.
/// Returns the edited action (or a new instance) if the user presses **Save**,
/// otherwise returns `null` if the user cancels.
///
/// Example usage:
/// ```dart
/// final newAction = await editStructAction(context, existingAction);
/// if (newAction != null) {
///   // use newAction
/// }
/// ```
Future<StructAction?> editStructAction(BuildContext context, StructAction action) async {
  // Current action being edited; may change type.
  StructAction current = action;

  // Helper to create a new instance based on type.
  StructAction _createInstance(String type) {
    switch (type) {
      case 'DoNothing':
        return DoNothing();
      case 'VariableSetNumberValue':
        return VariableSetNumberValue();
      case 'IncreaseNumberValue':
        return IncreaseNumberValue();
      default:
        return DoNothing();
    }
  }

  // Determine initial type string.
  String currentType = current.runtimeType.toString();

  final result = await showDialog<StructAction>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: DropdownButton<String>(
              value: currentType,
              items: const [
                DropdownMenuItem(value: 'DoNothing', child: Text('Do Nothing')),
                DropdownMenuItem(value: 'VariableSetNumberValue', child: Text('Set Number Value')),
                DropdownMenuItem(value: 'IncreaseNumberValue', child: Text('Increase Number Value')),
              ],
              onChanged: (String? newType) {
                if (newType == null || newType == currentType) return;
                setState(() {
                  currentType = newType;
                  current = _createInstance(newType);
                });
              },
            ),
            content: SizedBox(
              width: 400,
              height: 300,
              child: current.edit(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(current),
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
