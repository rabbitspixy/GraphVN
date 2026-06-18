import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showJavascriptCodeDialog(BuildContext context, String jsAction) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 800,
          maxWidth: 800,
          maxHeight: 600,
        ),
        child: TextField(
          controller: TextEditingController(text: jsAction),
          maxLines: null,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'JavaScript code',
            border: OutlineInputBorder(),
          ),
          style: GoogleFonts.robotoMono(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
