import 'package:flutter/material.dart';
import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/editor/widgets/editor_rich_text.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/modals/variable_selector.dart';
import 'package:graph_vn/editor/variables.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';

class RotateNamedValue extends BaseAction {
  String variableId = "";

  RotateNamedValue();

  @override
  String actionText() {
    return "Set ${EditorState.variableName(variableId)} to next value";
  }

  @override
  void exec() {
    final variable = EditorState.variableById(variableId);
    
    if (variable != null && variable is NamedVariable) {
      final type = namedVariableTypes.where((t) => t.id == variable.typeId).first;
      final index = type.list.indexWhere((x) => x.id == variable.value);
      final nextValue = type.list[(index + 1) % type.list.length].id;
      variable.value = nextValue;
    }
  }

  @override
  AbstractActionProto toProto() {
    final result = ActionRotateNamedValueProto();
    result.variableId = variableId;
    return AbstractActionProto()
        ..id = id
        ..rotateNamedValue = result;
  }

  factory RotateNamedValue.fromProto(ActionRotateNamedValueProto proto) {
    final result = RotateNamedValue();
    result.variableId = proto.variableId;
    return result;
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
        text: EditorState.variableName(widget.action.variableId), 
        tap: () async { 
          widget.action.variableId = (await showVariableSelector(context, VariableType.namedNumber))?.id ?? "";
          setState(() {});
        }
      ),
      ETextSpan(text: 'to next value'),
    ]);
  }
}