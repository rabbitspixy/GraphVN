import 'package:flutter/material.dart';
import 'package:graph_vn/editor/modals/create_variable_dialog.dart';
import 'package:graph_vn/game/variables.dart';

import '../../../game/struct.dart';
import 'variable_details_widget.dart';

class StructVariablesEditor extends StatefulWidget {
  final Struct struct;
  
  StructVariablesEditor({
    required this.struct
  }) : super(key: ValueKey(struct.id));

  @override
  State<StructVariablesEditor> createState() => _StructVariablesEditorState();
}

class _StructVariablesEditorState extends State<StructVariablesEditor> {
  int? _selectedIndex;
  @override
  Widget build(BuildContext context) {
    final sortedVariables = List<Variable>.from(widget.struct.variables)
      ..sort((a, b) => a.name.compareTo(b.name));
    if (_selectedIndex == null && sortedVariables.isNotEmpty) {
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
                        final newVariable = await showCreateVariableDialog(context);
                        if (newVariable != null) {
                          setState(() {
                            widget.struct.variables.add(newVariable);
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
                                final variableToRemove = sortedVariables[_selectedIndex!];
                                widget.struct.variables.remove(variableToRemove);
                                if (widget.struct.variables.isEmpty) {
                                  _selectedIndex = null;
                                } else if (_selectedIndex! >= widget.struct.variables.length) {
                                  _selectedIndex = widget.struct.variables.length - 1;
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
                  itemCount: sortedVariables.length,
                  itemBuilder: (context, index) {
                    final variable = sortedVariables[index];
                    return ListTile(
                      title: Text(variable.name),
                      subtitle: Text(variable.currentValueAsText()),
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
              ? Center(child: Text('Select a variable'))
              : VariableDetailsWidget(struct: widget.struct, variable: sortedVariables[_selectedIndex!]),
        ),
      ],
    );
  }
}
