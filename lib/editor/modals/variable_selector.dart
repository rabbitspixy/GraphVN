import 'package:flutter/material.dart';
import 'package:graph_vn/editor/struct.dart';
import 'package:graph_vn/editor/variables.dart';
import 'package:graph_vn/editor/editor_state.dart';

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
Future<Variable?> showVariableSelector(BuildContext? context, VariableType variableType) async {
  if (context == null) {
    return null;
  }
  // First, let user pick a struct
  final struct = await showDialog<Struct>(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: const Text('Select Struct'),
        content: SizedBox(
          width: 400,
          height: 500,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: EditorState.structs.length,
            itemBuilder: (BuildContext ctx, int index) {
              final s = EditorState.structs[index];
              return ListTile(
                title: Text(s.name),
                onTap: () => Navigator.of(ctx).pop(s),
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
  if (struct == null) {
    return null;
  }
  final filteredVariables = struct.variables.where((v) => v.runtimeType == variableType.type).toList();
  final variable = await showDialog<Variable>(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: const Text('Select Variable'),
        content: SizedBox(
          width: 400,
          height: 500,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredVariables.length,
            itemBuilder: (BuildContext ctx, int index) {
              final v = filteredVariables[index];
              return ListTile(
                title: Text(v.name),
                onTap: () => Navigator.of(ctx).pop(v),
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
  return variable;
}
