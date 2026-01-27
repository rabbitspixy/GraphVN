import 'package:flutter/material.dart';
import 'package:graph_vn/common/number_util.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/editor_transition.dart';
import 'package:graph_vn/editor/modals/procedure_selector.dart';

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
    final proc = await showProcedureSelector(context);
    if (proc != null && !widget.transition.actionIds.contains(proc.id)) {
      setState(() {
        widget.transition.actionIds.add(proc.id);
        widget.onChange();
      });
    }
  }

  String? _procedureName(String id) {
    for (final struct in EditorState.structs) {
      for (final proc in struct.procedures) {
        if (proc.id == id) return proc.name;
      }
    }
    return null;
  }

  Widget _buildActionList() {
    final widgets = <Widget>[];
    for (final actionId in widget.transition.actionIds) {
      final name = _procedureName(actionId) ?? actionId;
      widgets.add(
        ListTile(
          leading: const Icon(Icons.play_arrow),
          title: Text(name),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                widget.transition.actionIds.remove(actionId);
                widget.onChange();
              });
            },
          ),
        ),
      );
    }
    widgets.add(
      ElevatedButton.icon(
        onPressed: _addAction,
        icon: const Icon(Icons.add),
        label: const Text('Add Action'),
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
        // Actions list
        const Text('Actions:', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildActionList(),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            EditorState.deleteTransition(widget.transition.id);
            widget.onChange();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete Transition'),
        ),
      ],
    );
  }
}
