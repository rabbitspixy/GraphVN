import 'package:flutter/material.dart';
import 'package:graph_vn/common/js_util.dart';
import 'package:graph_vn/editor/modals/named_values_type_dialog.dart';
import 'package:graph_vn/editor/modals/number_edit_dialog.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';
import 'package:graph_vn/editor/modals/text_edit_dialog.dart';
import 'package:graph_vn/game/variables.dart';
import 'package:graph_vn/game/game_state.dart';

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
        ],
      ),
    );
  }
}
