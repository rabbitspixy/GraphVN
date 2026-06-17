import 'package:flutter/material.dart';

void showTextEditDialog(BuildContext context, String title, String text, void Function(String) onSave) async {
  final controller = TextEditingController(text: text);
  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(title),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600,
            maxHeight: 200,
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Text'),
            autofocus: true,
            maxLines: 6,
            onChanged: (_) => setState(() {}),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: controller.text.isEmpty ? null : () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    ),
  );
}
