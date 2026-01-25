import 'package:flutter/material.dart';
import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/editor/actions/do_nothing.dart';
import 'package:graph_vn/editor/actions/increase_number_value.dart';
import 'package:graph_vn/editor/actions/set_named_value.dart';
import 'package:graph_vn/editor/actions/set_number_value.dart';

/// Opens a modal dialog to edit a [BaseAction].
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
Future<BaseAction?> editStructAction(BuildContext context, BaseAction action) async {
  BaseAction current = action;
  StructActionType currentType = StructActionType.values.singleWhere((item) => item.type == current.runtimeType);

  final result = await showDialog<BaseAction>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: DropdownButton<StructActionType>(
              value: currentType,
              items: StructActionType.values.map((item) {
                return DropdownMenuItem(value: item, child: Text(item.title));
              }).toList(),
              onChanged: (StructActionType? newType) {
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
                DoNothing action => DoNothingEditor(action: action),
                IncreaseNumberValue action => IncreaseNumberValueEditor(action: action),
                SetNumberValue action => SetNumberValueEditor(action: action),
                SetNamedValue action => SetNamedValueEditor(action: action),
                _ => Placeholder()
              },
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
