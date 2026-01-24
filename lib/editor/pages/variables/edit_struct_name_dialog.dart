import 'package:flutter/material.dart';

Future<String?> showEditStructNameDialog(BuildContext context, String currentName) async {
  final controller = TextEditingController(text: currentName);
  return await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Edit Variable Name'),
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
          onPressed: () => Navigator.pop(context, controller.text),
          child: Text('Save'),
        ),
      ],
    ),
  );
}
