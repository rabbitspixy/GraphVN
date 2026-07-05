import 'package:flutter/material.dart';
import 'package:graph_vn/editor/modals/view_text_dialog.dart';

class LabelWithButton extends StatelessWidget {
  final String label;
  final VoidCallback? onShowJs;
  final List<String>? help;
  final double? iconSize;

  const LabelWithButton({
    super.key,
    required this.label,
    this.onShowJs,
    this.help,
    this.iconSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[Text(label, style: const TextStyle(fontWeight: FontWeight.bold))];

    if (onShowJs != null) {
      children.addAll([
        const SizedBox(width: 8),
        Tooltip(
          message: 'Просмотр кода',
          child: SizedBox(
            width: 24,
            height: 24,
            child: IconButton(
              icon: Icon(Icons.code, size: iconSize),
              padding: EdgeInsets.zero,
              onPressed: onShowJs!,
            ),
          ),
        ),
      ]);
    }

    if (help != null) {
      children.addAll([
        const SizedBox(width: 8),
        Tooltip(
          message: 'Помощь',
          child: SizedBox(
            width: 24,
            height: 24,
            child: IconButton(
              icon: Icon(Icons.help_outline, size: iconSize),
              padding: EdgeInsets.zero,
              onPressed: () async {
                await showViewTextDialog(context, label, (help ?? []).join("\n"));
              },
            ),
          ),
        ),
      ]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
