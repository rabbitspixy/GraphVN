import 'package:flutter/material.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/game/variables.dart';

const VARIABLE_TYPE_NUMBER = 'Number';
const VARIABLE_TYPE_NAMED_VALUE = 'Named Value';

Future<Variable?> showAddVariableDialog(BuildContext context) async {
  String selectedType = VARIABLE_TYPE_NUMBER;
  String name = '';
  String? selectedNamedTypeId;

  return await showDialog<Variable>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add Variable'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (val) => name = val,
                ),
                SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedType,
                  items: [VARIABLE_TYPE_NUMBER, VARIABLE_TYPE_NAMED_VALUE]
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedType = val;
                        if (selectedType == VARIABLE_TYPE_NAMED_VALUE &&
                            selectedNamedTypeId == null) {
                          selectedNamedTypeId = GameState.namedValueTypes.first()?.id;
                        }
                      });
                    }
                  },
                ),
                if (selectedType == 'Named Value')
                  DropdownButton<String>(
                    value: selectedNamedTypeId,
                    items: GameState.namedValueTypes.all()
                        .map((t) => DropdownMenuItem(
                              value: t.id,
                              child: Text(t.name),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedNamedTypeId = val;
                        });
                      }
                    },
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (name.isEmpty) return;
                  Variable newVariable;
                  if (selectedType == VARIABLE_TYPE_NUMBER) {
                    newVariable = NumberVariable()..name = name;
                  } else {
                    newVariable = NamedVariable(typeId: selectedNamedTypeId!, initialValue: GameState.namedValueTypes.findById(selectedNamedTypeId!)?.list.firstOrNull?.id ?? '')
                      ..name = name;
                  }
                  Navigator.pop(context, newVariable);
                },
                child: Text('Add'),
              ),
            ],
          );
        },
      );
    },
  );
}