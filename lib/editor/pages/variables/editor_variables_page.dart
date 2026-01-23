import 'package:flutter/material.dart';
import '../../editor_state.dart';
import '../../struct.dart';
import '../../struct_actions.dart';

class EditorVariablesPage extends StatefulWidget {
  const EditorVariablesPage({super.key});

  @override
  State<EditorVariablesPage> createState() => _EditorVariablesPageState();
}

class _EditorVariablesPageState extends State<EditorVariablesPage> {
  int? _selectedStructIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: EditorState.structs.length,
                  itemBuilder: (context, index) {
                    final struct = EditorState.structs[index];
                    return ListTile(
                      title: Text(struct.name),
                      selected: _selectedStructIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedStructIndex = index;
                        });
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final controller = TextEditingController(text: struct.name);
                          final newName = await showDialog<String>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Edit Struct Name'),
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
                              struct.name = newName;
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add Struct'),
                  onPressed: () {
                    setState(() {
                      EditorState.structs.add(
                        Struct()
                          ..name="Структура ${EditorState.structs.length + 1}"
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: _selectedStructIndex == null
              ? Center(child: Text('Select a struct to edit'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: EditorState.structs[_selectedStructIndex!].variables.length,
                        itemBuilder: (context, varIndex) {
                          final variable = EditorState.structs[_selectedStructIndex!].variables[varIndex];
                          final nameController = TextEditingController(text: variable.name);
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
                                child: TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(labelText: 'Name'),
                                  onChanged: (val) {
                                    variable.name = val;
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: valueController,
                                  decoration: InputDecoration(labelText: 'Start Value'),
                                  onChanged: (val) {
                                    if (variable is NumberVariable) {
                                      variable.startValue = val;
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    EditorState.structs[_selectedStructIndex!].variables.removeAt(varIndex);
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
                        onPressed: () {
                          setState(() {
                            EditorState.structs[_selectedStructIndex!].variables.add(NumberVariable());
                          });
                        },
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: EditorState.structs[_selectedStructIndex!].procedures.length,
                        itemBuilder: (context, procIndex) {
                          final procedure = EditorState.structs[_selectedStructIndex!].procedures[procIndex];
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
                                          onPressed: () {},
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
                                          procedure.actions.add(VariableSetNumberValue());
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
                            EditorState.structs[_selectedStructIndex!].procedures.add(StructProcedure());
                          });
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
