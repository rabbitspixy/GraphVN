import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/editor_transition.dart';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
