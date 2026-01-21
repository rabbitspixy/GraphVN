import 'package:flutter/material.dart';
import 'package:rational/rational.dart';
import 'editor_state.dart';
import 'struct.dart';

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
                      title: Text(struct.name.isEmpty ? 'Unnamed' : struct.name),
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
                      EditorState.structs.add(Struct());
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
                          final valueController = TextEditingController(text: variable.startValue);
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
                                    variable.startValue = val;
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
                            EditorState.structs[_selectedStructIndex!].variables.add(Variable());
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
