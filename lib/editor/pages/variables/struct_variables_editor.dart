import 'package:flutter/material.dart';
import 'package:graph_vn/common/js_util.dart';
import 'package:graph_vn/editor/modals/confirm_dialog.dart';
import 'package:graph_vn/editor/modals/create_variable_dialog.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/game/variables.dart';

import '../../../game/struct.dart';
import 'variable_details_widget.dart';

class StructVariablesEditor extends StatefulWidget {
  final Struct struct;

  StructVariablesEditor({required this.struct})
    : super(key: ValueKey(struct.id));

  @override
  State<StructVariablesEditor> createState() => _StructVariablesEditorState();
}

class _StructVariablesEditorState extends State<StructVariablesEditor> {
  int? _selectedIndex;

  List<Variable> _sortedVariables() {
    return List<Variable>.from(widget.struct.variables)
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> _removeSelectedVariable() async {
    final variableToRemove = _sortedVariables()[_selectedIndex!];
    if (await showConfirmDialog(context, "Удалить ${variableToRemove.name}?")) {
      setState(() {
        widget.struct.variables.remove(variableToRemove);
        if (widget.struct.variables.isEmpty) {
          _selectedIndex = null;
        } else if (_selectedIndex! >= widget.struct.variables.length) {
          _selectedIndex = widget.struct.variables.length - 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedVariables = _sortedVariables();
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
                        final newVariable = await showCreateVariableDialog(
                          context,
                        );
                        if (newVariable != null) {
                          setState(() {
                            widget.struct.variables.add(newVariable);
                            var jsName = toJsString("${widget.struct.name}->${newVariable.name}");
                            GameState.jsRuntime.evaluate("variables[$jsName] = ${newVariable.initialValueAsJsCode()};");
                            _selectedIndex ??= 0;
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: _selectedIndex != null ? () async {
                        await _removeSelectedVariable();
                      } : null,
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
              : VariableDetailsWidget(
                  struct: widget.struct,
                  variable: sortedVariables[_selectedIndex!],
                ),
        ),
      ],
    );
  }
}
