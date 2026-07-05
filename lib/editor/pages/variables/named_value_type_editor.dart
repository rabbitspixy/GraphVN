import 'package:flutter/material.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';
import 'package:graph_vn/editor/pages/variables/named_value_details.dart';
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
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add),
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
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: _selectedIndex != null
                          ? () async {
                              setState(() {
                                final itemToRemove = sortedList[_selectedIndex!];
                                widget.namedValuesType.values.remove(itemToRemove);
                                if (widget.namedValuesType.values.isEmpty) {
                                  _selectedIndex = null;
                                } else if (_selectedIndex! >= widget.namedValuesType.values.length) {
                                  _selectedIndex = widget.namedValuesType.values.length - 1;
                                }
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ),
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
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: _selectedIndex == null
              ? Center(child: Text('Select an item'))
              : NamedValueDetails(item: sortedList[_selectedIndex!]),
        ),
      ],
    );
  }
}
