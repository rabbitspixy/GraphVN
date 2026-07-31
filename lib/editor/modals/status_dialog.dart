import 'package:flutter/material.dart';

enum StatusDialogType { done, error }

Future<void> showStatusDialog(
  BuildContext context,
  String text,
  StatusDialogType type,
) async {
  final (title, icon) = switch (type) {
    StatusDialogType.done => ('Done', Icons.check_circle_outline),
    StatusDialogType.error => ('Error', Icons.error_outline),
  };
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ok'),
        ),
      ],
    ),
  );
}
