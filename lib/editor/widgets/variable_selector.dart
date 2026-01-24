import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../struct.dart';

/// Shows a modal dialog that lists all [Variable]s in [struct] and
/// returns the selected one. If the user cancels, returns null.
///
/// Example usage:
/// ```dart
/// Variable? chosen = await showVariableSelector(context, myStruct);
/// if (chosen != null) {
///   // do something with chosen
/// }
/// ```
Future<Variable?> showVariableSelector(BuildContext context, Struct struct) async {
  return showDialog<Variable>(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: const Text('Select Variable'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: struct.variables.length,
            itemBuilder: (BuildContext ctx, int index) {
              final variable = struct.variables[index];
              return ListTile(
                title: Text(variable.name),
                subtitle: Text(variable.runtimeType.toString()),
                onTap: () => Navigator.of(ctx).pop(variable),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
