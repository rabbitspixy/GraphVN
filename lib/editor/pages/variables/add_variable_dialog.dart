import 'package:flutter/material.dart';
import 'package:graph_vn/editor/variables.dart';

Future<Variable?> showAddVariableDialog(BuildContext context) async {
  String selectedType = 'Number';
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
                  items: ['Number', 'Named Number']
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedType = val;
                        if (selectedType == 'Named Number' &&
                            selectedNamedTypeId == null) {
                          selectedNamedTypeId = namedNumbersTypes.first.id;
                        }
                      });
                    }
                  },
                ),
                if (selectedType == 'Named Number')
                  DropdownButton<String>(
                    value: selectedNamedTypeId,
                    items: namedNumbersTypes
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
                  Variable varr;
                  if (selectedType == 'Number') {
                    varr = NumberVariable()..name = name;
                  } else {
                    varr = NamedNumberVariable(typeId: selectedNamedTypeId!)
                      ..name = name;
                  }
                  Navigator.pop(context, varr);
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