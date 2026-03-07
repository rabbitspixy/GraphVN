import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/editor/widgets/editor_rich_text.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/modals/variable_selector.dart';
import 'package:graph_vn/editor/named_value_expression/constant_named_value_expression.dart';
import 'package:graph_vn/editor/named_value_expression/named_value_expression.dart';
import 'package:graph_vn/editor/modals/named_number_expression_editor.dart';
import 'package:graph_vn/editor/variables.dart';

part 'set_named_value.mapper.dart';

@MappableClass()
class SetNamedValue extends BaseAction with SetNamedValueMappable {
  String variableId = "";
  NamedValueExpression expression = ConstantNamedValueExpression();

  SetNamedValue();

  @MappableConstructor()
  SetNamedValue.mappableConstructor({
    required super.id,
    required this.variableId,
    required this.expression,
  }) : super.mappableConstructor();

  @override
  String actionText() {
    return "Set ${EditorState.variableName(variableId)} to ${expression.asText()}";
  }

  @override
  void exec() {
    final variable = EditorState.variableById(variableId);
    if (variable != null && variable is NamedVariable) {
      variable.value = expression.evaluate();
    }
  }
}

class SetNamedValueEditor extends StatefulWidget {
  final SetNamedValue action;
  const SetNamedValueEditor({super.key, required this.action});

  @override
  State<SetNamedValueEditor> createState() => _SetNamedValueEditorState();
}

class _SetNamedValueEditorState extends State<SetNamedValueEditor> {
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
      ETextSpan(text: 'to'),
      ETextSpan(
        text: widget.action.expression.asText(),
        tap: () async {
          final newNumberExpression = await editNamedValueExpression(context, widget.action.expression);
          if (newNumberExpression != null) {
            widget.action.expression = newNumberExpression;
            setState(() {});
          }
        }
      )
    ]);
  }
}