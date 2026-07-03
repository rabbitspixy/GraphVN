import 'package:flutter/material.dart';
import 'package:graph_vn/game/variables.dart';

typedef NamedValueCallback = void Function(NamedValue namedValue);

Future<void> showNamedValuesTypeDialog(
  BuildContext context, {
  required NamedValuesType namedValuesType,
  required NamedValueCallback onValueSelected,
}) async {
  return await showDialog<void>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(namedValuesType.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: namedValuesType.values.map((namedValue) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: FilledButton(
                  onPressed: () {
                    onValueSelected(namedValue);
                    Navigator.pop(context);
                  },
                  child: Text(namedValue.name),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    ),
  );
}
