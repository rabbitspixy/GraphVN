import 'package:flutter/material.dart';
import 'editor_state.dart';
import 'struct.dart';

class EditorVariablesPage extends StatefulWidget {
  const EditorVariablesPage({super.key});

  @override
  State<EditorVariablesPage> createState() => _EditorVariablesPageState();
}

class _EditorVariablesPageState extends State<EditorVariablesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: EditorState.structs.length,
            itemBuilder: (context, index) {
              final struct = EditorState.structs[index];
              return ListTile(
                title: Text(struct.name.isEmpty ? 'Unnamed' : struct.name),
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
                        print("newName = ${newName}");
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
    );
  }
}
