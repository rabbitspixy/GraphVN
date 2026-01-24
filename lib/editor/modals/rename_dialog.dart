import 'package:flutter/material.dart';

Future<String?> showRenameDialog(BuildContext context, String title, String currentName) async {
  final controller = TextEditingController(text: currentName);
  return await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: 'Name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (controller.text.isEmpty) return;
            Navigator.pop(context, controller.text);
          },
          child: Text('Save'),
        ),
      ],
    ),
  );
}
