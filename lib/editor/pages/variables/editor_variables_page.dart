import 'package:flutter/material.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';
import 'package:graph_vn/editor/pages/variables/struct_editor_tabs.dart';
import 'package:graph_vn/editor/pages/variables/named_value_type_editor.dart';
import 'package:graph_vn/editor/widgets/help_button.dart';
import 'package:graph_vn/game/struct.dart';
import '../../../game/game_state.dart';

class EditorVariablesPage extends StatefulWidget {
  const EditorVariablesPage({super.key});

  @override
  State<EditorVariablesPage> createState() => _EditorVariablesPageState();
}

class _EditorVariablesPageState extends State<EditorVariablesPage> {
  int? _selectedStructIndex;
  int? _selectedNamedValueTypeIndex;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: GameState.structs.length,
                    itemBuilder: (context, index) {
                      final struct = GameState.structs[index];
                      return ListTile(
                        title: Text(struct.name),
                        selected: _selectedStructIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedStructIndex = index;
                            _selectedNamedValueTypeIndex = null;
                          });
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            final newName = await showRenameDialog(
                                context, 'Edit Struct Name', struct.name);
                            if (newName != null) {
                              GameState.renameStruct(struct.id, newName);
                              setState(() {});
                            }
                          },
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Struct'),
                      onPressed: () async {
                        final name = await showRenameDialog(
                            context, 'New Named Value Type', '');
                        if (name != null) {
                          GameState.structs.add(
                              Struct()
                                ..name = name
                          );
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: GameState.namedValueTypes
                        .all()
                        .length,
                    itemBuilder: (context, index) {
                      final namedValueType = GameState.namedValueTypes
                          .all()[index];
                      return ListTile(
                        title: Text(namedValueType.name),
                        selected: _selectedNamedValueTypeIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedStructIndex = null;
                            _selectedNamedValueTypeIndex = index;
                          });
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            final newName = await showRenameDialog(
                                context, 'Edit NamedValueType Name',
                                namedValueType.name);
                            if (newName != null) {
                              setState(() {
                                namedValueType.name = newName;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Named Value Type'),
                      onPressed: () async {
                        final name = await showRenameDialog(
                            context, 'New Named Value Type', '');
                        if (name != null && name.isNotEmpty) {
                          GameState.namedValueTypes.createEmpty(name);
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 4,
                child: _selectedStructIndex == null &&
                    _selectedNamedValueTypeIndex == null
                    ? Center(
                    child: Text('Select a struct or named value type to edit'))
                    : _selectedStructIndex != null
                    ? StructEditorTabs(
                    struct: GameState.structs[_selectedStructIndex!])
                    : NamedValueTypeEditor(
                    namedValuesType: GameState.namedValueTypes
                        .all()[_selectedNamedValueTypeIndex!])
            ),
          ],
        ),
        Positioned(
          top: 4,
          left: 4,
          child: HelpButton(helpTexts: [
            'На этой странице нужно создать изменяемые во время игры параметры, которые потребуются для логики квеста',
            'Для этого нужно создать структуру, в неё добавить параметр',
            'Заполнить имя, например "здоровье персонажа", описание для AI и изменить начальное значение'
            'Есть возможность указать не числовой тип параметра - Named Value',
            'Например создать Named Value Type с двумя значениями "да" и "нет"',
            'И создать переменную с этим типом, например "найден ключ от двери?"',
          ]),
        ),
      ],
    );
  }
}
