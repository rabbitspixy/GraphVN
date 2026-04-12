import 'package:flutter/material.dart';
import 'package:graph_vn/editor/named_value_expression/constant_named_value_expression.dart';
import 'package:graph_vn/editor/modals/named_number_expression_editor.dart';
import 'package:graph_vn/editor/number_expression/constant_number_expression.dart';
import 'package:graph_vn/editor/modals/number_expression_editor.dart';
import 'package:graph_vn/editor/modals/add_variable_dialog.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';
import 'package:graph_vn/editor/variables.dart';

import '../../struct.dart';

class StructVariables extends StatefulWidget {
  final Struct struct;
  
  StructVariables({
    required this.struct
  }) : super(key: ValueKey(struct.id));

  @override
  State<StructVariables> createState() => _StructVariablesState();
}

class _StructVariablesState extends State<StructVariables> {
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
              Padding(
                padding: EdgeInsets.all(8),
                child: OutlinedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Variable'),
                  onPressed: () async {
                    final newVariable = await showAddVariableDialog(context);
                    if (newVariable != null) {
                      setState(() {
                        widget.struct.variables.add(newVariable);
                        if (_selectedIndex == null) _selectedIndex = 0;
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
              ? Center(child: Text('Select a variable'))
              : _buildVariableDetails(sortedVariables[_selectedIndex!]),
        ),
      ],
    );
  }

  Widget _buildVariableDetails(Variable variable) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputDecorator(
            decoration: InputDecoration(labelText: 'Name'),
            child: GestureDetector(
              onTap: () async {
                final newName = await showRenameDialog(context, 'Edit Variable Name', variable.name);
                if (newName != null) {
                  setState(() {
                    variable.name = newName;
                  });
                }
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  variable.name,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          InputDecorator(
            decoration: InputDecoration(labelText: 'Current value'),
            child: GestureDetector(
              onTap: () async {
                if (variable is NumberVariable) {
                  final fake = ConstantNumberExpression()..value = variable.value;
                  final number = (await editNumberExpression(context, fake, allowChangeType: false))?.evaluate();
                  if (number != null) {
                    variable.value = number;
                  }
                } else if (variable is NamedVariable) {
                  final fake = ConstantNamedValueExpression()..valueId = variable.value;
                  final newVal = (await editNamedValueExpression(context, fake, allowChangeType: false))?.evaluate();
                  if (newVal != null) {
                    variable.value = newVal;
                  }
                }
                setState(() {});
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  variable.currentValueAsText(),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          InputDecorator(
            decoration: InputDecoration(labelText: 'Initial value'),
            child: GestureDetector(
              onTap: () async {
                if (variable is NumberVariable) {
                  final fake = ConstantNumberExpression()..value = variable.initialValue;
                  final number = (await editNumberExpression(context, fake, allowChangeType: false))?.evaluate();
                  if (number != null) {
                    variable.initialValue = number;
                  }
                } else if (variable is NamedVariable) {
                  final fake = ConstantNamedValueExpression()..valueId = variable.initialValue;
                  final newVal = (await editNamedValueExpression(context, fake, allowChangeType: false))?.evaluate();
                  if (newVal != null) {
                    variable.initialValue = newVal;
                  }
                }
                setState(() {});
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  variable.initialValueAsText(),
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
