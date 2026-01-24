import 'package:flutter/material.dart';

Future<String?> showRenameDialog(BuildContext context, String title, String currentName) async {
  final controller = TextEditingController(text: currentName);
  return await showDialog<String>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Name'),
          onChanged: (_) => setState(() {}),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: controller.text.isEmpty ? null : () => Navigator.pop(context, controller.text),
            child: Text('Save'),
          ),
        ],
      ),
    ),
  );
}
