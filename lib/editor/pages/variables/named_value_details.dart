import 'package:flutter/material.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';
import 'package:graph_vn/editor/modals/text_edit_dialog.dart';
import 'package:graph_vn/game/variables.dart';

class NamedValueDetails extends StatefulWidget {
  final NamedValue item;

  const NamedValueDetails({
    super.key,
    required this.item,
  });

  @override
  State<NamedValueDetails> createState() => _NamedValueDetailsState();
}

class _NamedValueDetailsState extends State<NamedValueDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputDecorator(
            decoration: InputDecoration(labelText: 'Name'),
            child: GestureDetector(
              onTap: () async {
                final newName = await showRenameDialog(context, 'Edit Name', widget.item.name);
                if (newName != null) {
                  setState(() {
                    widget.item.name = newName;
                  });
                }
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  widget.item.name,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          InputDecorator(
            decoration: InputDecoration(labelText: 'Description'),
            child: GestureDetector(
              onTap: () async {
                showTextEditDialog(context, 'Edit Description', widget.item.description, (newDescription) {
                  setState(() {
                    widget.item.description = newDescription;
                  });
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  widget.item.description,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
