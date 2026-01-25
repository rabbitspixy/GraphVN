import 'package:flutter/material.dart';
import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/editor/editor_rich_text.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/modals/variable_selector.dart';
import 'package:graph_vn/editor/variables.dart';

class RotateNamedValue extends BaseAction {
  String variableId = "";

  @override
  String actionText() {
    return "Set ${EditorState.variableAsString(variableId)} to next value";
  }

  @override
  void exec() {
    final variable = EditorState.variableById(variableId);
    
    if (variable != null && variable is NamedNumberVariable) {
      final type = namedNumbersTypes.where((t) => t.id == variable.typeId).first;
      final index = type.list.indexWhere((x) => x.key == variable.value);
      final nextValue = type.list[(index + 1) % type.list.length].key;
      variable.value = nextValue;
    }
  }
}

class RotateNamedValueEditor extends StatefulWidget {
  final RotateNamedValue action;
  const RotateNamedValueEditor({super.key, required this.action});

  @override
  State<RotateNamedValueEditor> createState() => _RotateNamedValueEditorState();
}

class _RotateNamedValueEditorState extends State<RotateNamedValueEditor> {
  @override
  Widget build(BuildContext context) {
    return EditorRichText([
      ETextSpan(text: 'Set'),
      ETextSpan(
        text: EditorState.variableAsString(widget.action.variableId), 
        tap: () async { 
          widget.action.variableId = (await showVariableSelector(context, VariableType.namedNumber))?.id ?? "";
          setState(() {});
        }
      ),
      ETextSpan(text: 'to next value'),
    ]);
  }
}