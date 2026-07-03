import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showNumberEditDialog(BuildContext context, String title, int number, void Function(int) onSave) async {
  final controller = TextEditingController(text: number.toString());

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
            decoration: InputDecoration(labelText: 'Number'),
            keyboardType: TextInputType.number,
            autofocus: true,
            maxLines: 1,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^-?\d*$')),
            ],
            onChanged: (_) => setState(() {}),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: controller.text.isNotEmpty &&
                    RegExp(r'^-?\d+$').hasMatch(controller.text)
                ? (() {
                    final numValue = int.parse(controller.text);
                    if (numValue >= -9999999 && numValue <= 9999999) {
                      onSave(numValue);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Number must be between -9999999 and 9999999')),
                      );
                    }
                  })
                : null,
            child: Text('Save'),
          ),
        ],
      ),
    ),
  );
}
