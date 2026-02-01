import 'package:flutter/material.dart';
import 'package:graph_vn/editor/named_value_expression/constant_named_value_expression.dart';
import 'package:graph_vn/editor/named_value_expression/named_number_expression_editor.dart';
import 'package:graph_vn/editor/number_expression/constant_number_expression.dart';
import 'package:graph_vn/editor/number_expression/number_expression_editor.dart';
import 'package:graph_vn/editor/pages/variables/add_variable_dialog.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';
import 'package:graph_vn/editor/variables.dart';

class StructVariables extends StatefulWidget {
  final Struct struct;
  
  StructVariables({
    required this.struct
  }) : super(key: ValueKey(struct.id));

  @override
  State<StructVariables> createState() => _StructVariablesState();
}

class _StructVariablesState extends State<StructVariables> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.struct.variables.length + 1,
            itemBuilder: (context, varIndex) {
              if (varIndex == widget.struct.variables.length) {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('Variable'),
                    onPressed: () async {
                      final newVariable = await showAddVariableDialog(context);
                      if (newVariable != null) {
                        setState(() {
                          widget.struct.variables.add(newVariable);
                        });
                      }
                    },
                  ),
                );
              }
              final variable = widget.struct.variables[varIndex];
              return Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: InputDecorator(
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
                  ),
                  Expanded(
                    flex: 3,
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: 'Current value'),
                      child: Text(
                        variable.currentValueAsText(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: 'Initial value'),
                      child: GestureDetector(
                        onTap: () async {
                          switch (variable) {
                            case NumberVariable _: {
                              final fakeExpression = ConstantNumberExpression()
                                ..value = variable.initialValue;
                              final number = (await editNumberExpression(context, fakeExpression, allowChangeType: false))?.evaluate();
                              if (number != null) {
                                variable.initialValue = number;
                              }
                            }
                            case NamedVariable _ : {
                              final fakeExpression = ConstantNamedValueExpression(namedNumbersTypeId: variable.typeId)
                                ..value = variable.initialValue;
                              final newStartValue = (await editNamedValueExpression(context, fakeExpression, allowChangeType: false))?.evaluate();
                              if (newStartValue != null) {
                                variable.initialValue = newStartValue;
                              }
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
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.delete, color: Colors.red),
                  //   onPressed: () {
                  //     setState(() {
                  //       widget.struct.variables.removeAt(varIndex);
                  //     });
                  //   },
                  // ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
