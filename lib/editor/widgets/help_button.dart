import 'package:flutter/material.dart';
import 'package:graph_vn/editor/modals/view_text_dialog.dart';

class HelpButton extends StatelessWidget {
  final List<String> helpTexts;

  const HelpButton({super.key, required this.helpTexts});

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      child: SizedBox(
        width: 24,
        height: 24,
        child: IconButton(
          icon: const Icon(Icons.help_outline, size: 14),
          padding: EdgeInsets.zero,
          onPressed: () async {
            await showViewTextDialog(
              context, 'Помощь', helpTexts.join('\n'),
            );
          },
        ),
      ),
    );
  }
}
