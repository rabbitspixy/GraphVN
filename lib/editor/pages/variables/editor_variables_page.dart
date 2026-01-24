import 'package:flutter/material.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';
import 'package:graph_vn/editor/pages/variables/struct_editor.dart';
import '../../editor_state.dart';
import '../../variables.dart';

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
                          final newName = await showRenameDialog(context, 'Edit Struct Name', struct.name);
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
              : StructEditor(struct: EditorState.structs[_selectedStructIndex!])
        ),
      ],
    );
  }
}
