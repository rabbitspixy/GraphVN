import 'package:flutter/material.dart';
import 'package:graph_vn/common/number_util.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/editor_transition.dart';
import 'package:graph_vn/editor/first_match_condition_item.dart';
import 'package:graph_vn/editor/modals/first_match_condition_item_editor.dart';
import 'package:graph_vn/editor/named_value_expression/constant_named_value_expression.dart';

import '../../actions/do_nothing.dart';
import '../../modals/named_value_expression_editor.dart';
import '../../modals/struct_action_editor.dart';

class TransitionEditor extends StatefulWidget {
  final EditorTransition transition;
  final VoidCallback onChange;

  TransitionEditor({
    required this.transition,
    required this.onChange,
  }) : super(key: ValueKey(transition));

  @override
  State<TransitionEditor> createState() => _TransitionEditorState();
}

class _TransitionEditorState extends State<TransitionEditor> {
  late TextEditingController _controller;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.transition.text);
    _controller.addListener(() {
      if (widget.transition.text != _controller.text) {
        widget.transition.text = _controller.text;
        widget.onChange();
        setState(() {});
      }
    });
    _weightController = TextEditingController(text: widget.transition.weight.toString());
    _weightController.addListener(() {
      final text = _weightController.text;
      final parsed = parseWithCoerce(text, 1, 999999);
      if (parsed.toString() != text) {
        _weightController.text = parsed.toString();
      }
      widget.transition.weight = parsed;
      widget.onChange();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _addAction() async {
    final action = await editStructAction(context, DoNothing());
    if (action != null) {
      setState(() {
        widget.transition.actions.add(action);
        widget.onChange();
      });
    }
  }

  Widget _buildActionList() {
    final widgets = <Widget>[];
    for (final action in widget.transition.actions) {
      final actionText = action.actionText();
      widgets.add(
        ListTile(
          title: Text(actionText),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                widget.transition.actions.remove(action);
                widget.onChange();
              });
            },
          ),
        ),
      );
    }
    widgets.add(
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _addAction,
          icon: const Icon(Icons.add),
          label: const Text('Add action'),
        ),
      ),
    );
    return Column(children: widgets);
  }

  Future<void> _addCondition() async {
    final newCondition = await editFirstMatchConditionItem(context, FirstMatchConditionItem(expression: ConstantNamedValueExpression(), result: FirstMatchResult.pass));
    if (newCondition == null) {
      return;
    }
    setState(() {
      widget.transition.conditions.add(newCondition);
      widget.onChange();
    });
  }

  Future<void> _editCondition(int index) async {
    final condition = widget.transition.conditions[index];
    final newCondition = await editFirstMatchConditionItem(context, condition);
    if (newCondition == null) {
      return;
    }
    widget.transition.conditions[index] = newCondition;
    widget.onChange();
    setState(() {

    });
  }

  Widget _buildConditionList() {
    final widgets = <Widget>[];
    for (int i = 0; i < widget.transition.conditions.length; i++) {
      final cond = widget.transition.conditions[i];
      widgets.add(
        ListTile(
          title: Text(cond.asText()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editCondition(i),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    widget.transition.conditions.removeAt(i);
                    widget.onChange();
                  });
                },
              ),
            ],
          ),
        ),
      );
    }
    widgets.add(
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _addCondition,
          icon: const Icon(Icons.add),
          label: const Text('Conditions'),
        ),
      ),
    );
    return Column(children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Transition Text:', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _controller,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        const Text('Weight:', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _weightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Condition:', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildConditionList(),
        const SizedBox(height: 8),
        const Text('Actions:', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildActionList(),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              EditorState.deleteTransition(widget.transition.id);
              widget.onChange();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Transition'),
          ),
        ),
      ],
    );
  }
}
