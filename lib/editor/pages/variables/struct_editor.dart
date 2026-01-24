import 'package:flutter/material.dart';
import 'package:graph_vn/editor/number_expression/constant_number_expression.dart';
import 'package:graph_vn/editor/number_expression/number_expression_editor.dart';
import 'package:graph_vn/editor/pages/variables/add_variable_dialog.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';
import 'package:graph_vn/editor/variables.dart';
import 'package:graph_vn/editor/actions/do_nothing.dart';
import 'package:graph_vn/editor/actions/struct_action_editor.dart';
import 'package:collection/collection.dart';

class StructEditor extends StatefulWidget {
  final Struct struct;
  
  StructEditor({
    required this.struct
  }) : super(key: ValueKey(struct.id));

  @override
  State<StructEditor> createState() => _StructEditorState();
}

class _StructEditorState extends State<StructEditor> {
  StructProcedure? _selectedProcedure;

  Widget expandedProcedure(StructProcedure procedure) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(procedure.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  final newName = await showRenameDialog(context, 'Edit Procedure Name', procedure.name);
                  if (newName != null) {
                    setState(() {
                      procedure.name = newName;
                    });
                  }
                },
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              procedure.actions.map((action) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: ElevatedButton(
                    onPressed: () async {
                      final editResult = await editStructAction(context, action);
                      if (editResult != null) {
                        procedure.actions[procedure.actions.indexOf(action)] = editResult;
                        setState(() {});
                      }
                    },
                    child: Text(action.actionText()),
                  ),
                );
              }).toList(),
              [
                TextButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Action'),
                  onPressed: () {
                    setState(() {
                      procedure.actions.add(DoNothing());
                    });
                  },
                )
              ]
            ].flattenedToList
          ),
        ],
      ),
    );
  }

  Widget minimizedProcedure(StructProcedure procedure) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedProcedure = procedure;
          });
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(procedure.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                        variable.currentValueAsString(),
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
                              final number = (await editNumberExpression(context, ConstantNumberExpression(), allowChangeType: false))?.evaluate();
                              if (number != null) {
                                variable.startValue = number;
                              }
                            }
                            case NamedNumberVariable _ : {

                            }
                          }
                          setState(() {});
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            variable.initialValueAsString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.struct.variables.removeAt(varIndex);
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ),
        Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: widget.struct.procedures.length + 1,
            itemBuilder: (context, procIndex) {
              if (procIndex == widget.struct.procedures.length) {
                return Padding(
                  padding: EdgeInsets.all(8),
                    child: OutlinedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('Procedure'),
                    onPressed: () {
                      setState(() {
                        widget.struct.procedures.add(StructProcedure());
                      });
                    },
                  ),
                );
              }
              final procedure = widget.struct.procedures[procIndex];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: _selectedProcedure == procedure ? expandedProcedure(procedure) : minimizedProcedure(procedure),
              );
            },
          ),
        ),
      ],
    );
  }
}
