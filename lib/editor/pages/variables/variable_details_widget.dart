import 'package:flutter/material.dart';
import 'package:graph_vn/common/js_util.dart';
import 'package:graph_vn/editor/modals/named_values_type_dialog.dart';
import 'package:graph_vn/editor/modals/number_edit_dialog.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';
import 'package:graph_vn/editor/modals/text_edit_dialog.dart';
import 'package:graph_vn/game/variables.dart';
import 'package:graph_vn/game/number_variable_stringifier.dart';
import 'package:graph_vn/game/named_variable_stringifier.dart';
import 'package:graph_vn/game/game_state.dart';

import '../../../editor/modals/number_variable_stringifier_editor.dart';
import '../../../editor/modals/named_variable_stringifier_editor.dart';
import '../../../game/struct.dart';

class VariableDetailsWidget extends StatefulWidget {
  final Struct struct;
  final Variable variable;

  const VariableDetailsWidget({
    super.key,
    required this.struct,
    required this.variable,
  });

  @override
  State<VariableDetailsWidget> createState() => _VariableDetailsWidgetState();
}

class _VariableDetailsWidgetState extends State<VariableDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    final variable = widget.variable;
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputDecorator(
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
          SizedBox(height: 8),
          InputDecorator(
            decoration: InputDecoration(labelText: 'Description'),
            child: GestureDetector(
              onTap: () async {
                showTextEditDialog(context, 'Edit Variable Description', variable.description, (newDescription) {
                  setState(() {
                    variable.description = newDescription;
                  });
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  variable.description,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          InputDecorator(
            decoration: InputDecoration(labelText: 'Current value'),
            child: GestureDetector(
              onTap: () async {
                if (variable is NumberVariable) {
                  await showNumberEditDialog(context, "${variable.name} current value", int.parse(variable.currentValueAsText()), (newValue) {
                    GameState.jsRuntime.evaluate("variables[${toJsString("${widget.struct.name}->${variable.name}")}] = ${newValue.toString()}");
                  });
                }
                if (variable is NamedVariable) {
                  final namedValuesType = GameState.namedValueTypes.findById(variable.typeId);
                  if (namedValuesType != null) {
                    await showNamedValuesTypeDialog(context, namedValuesType: namedValuesType, onValueSelected: (newValue) {
                      GameState.jsRuntime.evaluate("variables[${toJsString("${widget.struct.name}->${variable.name}")}] = ${newValue.name}");
                    });
                  }
                }
                setState(() {});
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  variable.currentValueAsText(),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          InputDecorator(
            decoration: InputDecoration(labelText: 'Initial value'),
            child: GestureDetector(
              onTap: () async {
                if (variable is NumberVariable) {
                  await showNumberEditDialog(context, "${variable.name} initial value", variable.initialValue, (newValue) {
                    variable.initialValue = newValue;
                  });
                }
                if (variable is NamedVariable) {
                  final namedValuesType = GameState.namedValueTypes.findById(variable.typeId);
                  if (namedValuesType != null) {
                    await showNamedValuesTypeDialog(context, namedValuesType: namedValuesType, onValueSelected: (newValue) {
                      variable.initialValue = newValue.id;
                    });
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
          SizedBox(height: 8),
          InputDecorator(
            decoration: InputDecoration(labelText: 'Display as'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (variable is NumberVariable) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: variable.stringifiers.length,
                    itemBuilder: (context, idx) {
                      final s = variable.stringifiers[idx];
                      return ListTile(
                        title: Text('${s.rangeStart} - ${s.rangeEnd}'),
                        subtitle: Text(s.template),
                        onTap: () async {
                          final updated = await editNumberVariableStringifier(context, s);
                          if (updated != null) {
                            setState(() {
                              variable.stringifiers[idx] = updated;
                            });
                          }
                        },
                      );
                    },
                  ),
                ] else if (variable is NamedVariable) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: variable.stringifiers.length,
                    itemBuilder: (context, idx) {
                      final s = variable.stringifiers[idx];
                      return ListTile(
                        title: Text(GameState.namedValueTypes.findValueById(s.valueId)?.name ?? "Unknown"),
                        subtitle: Text(s.template),
                        onTap: () async {
                          final namedValues = GameState.namedValueTypes.findById(variable.typeId)?.values ?? [];
                          final updated = await editNamedVariableStringifier(context, s, namedValues);
                          if (updated != null) {
                            setState(() {
                              variable.stringifiers[idx] = updated;
                            });
                          }
                        },
                      );
                    },
                  ),
                ],
                SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add'),
                  onPressed: () async {
                    if (variable is NumberVariable) {
                      final newStringifier = NumberVariableStringifier(
                        rangeStart: 0,
                        rangeEnd: 0,
                        template: "{}",
                      );
                      final updated = await editNumberVariableStringifier(context, newStringifier);
                      if (updated != null) {
                        setState(() {
                          variable.stringifiers.add(updated);
                        });
                      }
                    } else if (variable is NamedVariable) {
                      final namedValues = GameState.namedValueTypes.findById(variable.typeId)?.values ?? [];
                      final newStringifier = NamedVariableStringifier(
                        valueId: '',
                        template: '',
                      );
                      final updated = await editNamedVariableStringifier(context, newStringifier, namedValues);
                      if (updated != null) {
                        setState(() {
                          variable.stringifiers.add(updated);
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
