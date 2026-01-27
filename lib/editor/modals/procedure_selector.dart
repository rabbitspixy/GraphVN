import 'package:flutter/material.dart';
import 'package:graph_vn/editor/variables.dart';
import 'package:graph_vn/editor/editor_state.dart';

/// Shows a modal dialog that lists all [StructProcedure]s in a selected [Struct]
/// and returns the chosen one. If the user cancels, returns null.
///
/// Example usage:
/// ```dart
/// StructProcedure? chosen = await showProcedureSelector(context);
/// if (chosen != null) {
///   // do something with chosen
/// }
/// ```
Future<StructProcedure?> showProcedureSelector(BuildContext? context) async {
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

  // Then let user pick a procedure from the selected struct
  final procedure = await showDialog<StructProcedure>(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: const Text('Select Procedure'),
        content: SizedBox(
          width: 400,
          height: 500,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: struct.procedures.length,
            itemBuilder: (BuildContext ctx, int index) {
              final p = struct.procedures[index];
              return ListTile(
                title: Text(p.name),
                onTap: () => Navigator.of(ctx).pop(p),
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
  return procedure;
}
