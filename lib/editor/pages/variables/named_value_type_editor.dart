import 'package:flutter/material.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';
import 'package:graph_vn/editor/modals/text_edit_dialog.dart';
import 'package:graph_vn/game/variables.dart';

class NamedValueTypeEditor extends StatefulWidget {
  final NamedValuesType namedValuesType;

  const NamedValueTypeEditor({
    super.key,
    required this.namedValuesType,
  });

  @override
  State<NamedValueTypeEditor> createState() => _NamedValueTypeEditorState();
}

class _NamedValueTypeEditorState extends State<NamedValueTypeEditor> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final sortedList = List<NamedValue>.from(widget.namedValuesType.values)
      ..sort((a, b) => a.name.compareTo(b.name));
    
    if (_selectedIndex == null && sortedList.isNotEmpty) {
      _selectedIndex = 0;
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: sortedList.length,
                  itemBuilder: (context, index) {
                    final item = sortedList[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.description),
                      selected: _selectedIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Named Value'),
                  onPressed: () async {
                    final newName = await showRenameDialog(context, 'Add Named Value', '');
                    if (newName != null && newName.isNotEmpty) {
                      setState(() {
                        widget.namedValuesType.addValue(newName);
                        _selectedIndex ??= 0;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: _selectedIndex == null
              ? Center(child: Text('Select an item'))
              : _buildItemDetails(sortedList[_selectedIndex!]),
        ),
      ],
    );
  }

  Widget _buildItemDetails(NamedValue item) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputDecorator(
            decoration: InputDecoration(labelText: 'Name'),
            child: GestureDetector(
              onTap: () async {
                final newName = await showRenameDialog(context, 'Edit Name', item.name);
                if (newName != null) {
                  setState(() {
                    item.name = newName;
                  });
                }
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  item.name,
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
                showTextEditDialog(context, 'Edit Description', item.description, (newDescription) {
                  setState(() {
                    item.description = newDescription;
                  });
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  item.description,
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
