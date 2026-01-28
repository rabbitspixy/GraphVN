import 'package:flutter/material.dart';

Future<T?> showEnumSelector<T extends Enum>(BuildContext context, List<T> values, String Function(T) textExtractor) async {
  final result = await showDialog<T>(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: const Text('Select value'),
        content: SizedBox(
          width: 400,
          height: 500,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: values.length,
            itemBuilder: (BuildContext ctx, int index) {
              final v = values[index];
              return ListTile(
                title: Text(textExtractor(v)),
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
  return result;
}
