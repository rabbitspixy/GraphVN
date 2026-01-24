import 'package:flutter/material.dart';
import 'package:graph_vn/editor/pages/variables/add_variable_dialog.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';
import 'package:graph_vn/editor/variables.dart';
import 'package:graph_vn/editor/actions/do_nothing.dart';
import 'package:graph_vn/editor/actions/struct_action_editor.dart';

class StructEditor extends StatefulWidget {
  final Struct struct;
  
  StructEditor({
    required this.struct
  }) : super(key: ValueKey(struct.id));

  @override
  State<StructEditor> createState() => _StructEditorState();
}

class _StructEditorState extends State<StructEditor> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.struct.variables.length,
            itemBuilder: (context, varIndex) {
              final variable = widget.struct.variables[varIndex];
              TextEditingController valueController;
              if (variable is NumberVariable) {
                valueController = TextEditingController(text: variable.startValue);
              } else {
                valueController = TextEditingController(text: '');
              }
              return Row(
                children: [
                  Expanded(
                    flex: 3,
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
                  switch (variable) {
                    NumberVariable _ => Expanded(
                      flex: 3,
                      child: TextField(
                        controller: valueController,
                        decoration: InputDecoration(labelText: 'Start Value'),
                        onChanged: (newStartValue) {
                          variable.startValue = newStartValue;
                        },
                      ),
                    ),
                    NamedNumberVariable _ => Text(variable.startValue),
                    _ => Text('Not implemented')
                  },
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Variable'),
            onPressed: () async {
              final newVariable = await showAddVariableDialog(context);
              if (newVariable != null) {
                setState(() {
                  widget.struct.variables.add(newVariable);
                });
              }
            },
          ),
        ),
        Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: widget.struct.procedures.length,
            itemBuilder: (context, procIndex) {
              final procedure = widget.struct.procedures[procIndex];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              final controller = TextEditingController(text: procedure.name);
                              final newName = await showDialog<String>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Edit Procedure Name'),
                                  content: TextField(
                                    controller: controller,
                                    decoration: InputDecoration(labelText: 'Name'),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel')),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, controller.text),
                                        child: Text('Save')),
                                  ],
                                ),
                              );
                              if (newName != null) {
                                setState(() {
                                  procedure.name = newName;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Column(
                        children: procedure.actions.map((action) {
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
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: Icon(Icons.add),
                          label: Text('Add Action'),
                          onPressed: () {
                            setState(() {
                              procedure.actions.add(DoNothing());
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Procedure'),
            onPressed: () {
              setState(() {
                widget.struct.procedures.add(StructProcedure());
              });
            },
          ),
        ),
      ],
    );
  }
}
