import 'package:flutter/material.dart';
import 'package:touch_of_the_unknown/editor/editor_state.dart';
import 'package:touch_of_the_unknown/editor/editor_transition.dart';

class EditorTransitionEditor extends StatefulWidget {
  final String transitionId;
  final VoidCallback onChange;

  EditorTransitionEditor({
    required this.transitionId,
    required this.onChange,
  }) : super(key: ValueKey(transitionId));

  @override
  State<EditorTransitionEditor> createState() => _EditorTransitionEditorState();
}

class _EditorTransitionEditorState extends State<EditorTransitionEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final transition = EditorState.transitions.firstWhere((t) => t.id == widget.transitionId, orElse: () => EditorTransition());
    _controller = TextEditingController(text: transition.text);
    _controller.addListener(() {
      if (transition.text != _controller.text) {
        transition.text = _controller.text;
        setState(() {});
      }
    });
  }

  // @override
  // void didUpdateWidget(covariant EditorTransitionEditor oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   final transition = EditorState.transitions.firstWhere((t) => t.id == widget.transitionId, orElse: () => EditorTransition());
  //   _controller.text = transition.text;
  // }

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
            EditorState.deleteTransition(widget.transitionId);
          },
          child: const Text('Delete Transition'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }
}
