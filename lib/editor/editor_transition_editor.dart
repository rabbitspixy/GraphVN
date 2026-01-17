import 'package:flutter/material.dart';
import 'package:touch_of_the_unknown/editor/editor_state.dart';
import 'package:touch_of_the_unknown/editor/editor_transition.dart';

class EditorTransitionEditor extends StatefulWidget {
  final String transitionId;
  const EditorTransitionEditor({Key? key, required this.transitionId}) : super(key: key);

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
      transition.text = _controller.text;
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant EditorTransitionEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final transition = EditorState.transitions.firstWhere((t) => t.id == widget.transitionId, orElse: () => EditorTransition());
    _controller.text = transition.text;
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
            final idx = EditorState.transitions.indexWhere((t) => t.id == widget.transitionId);
            if (idx != -1) {
              EditorState.transitions.removeAt(idx);
              EditorState.transitionsNotifier.value = List.from(EditorState.transitions);
            }
          },
          child: const Text('Delete Transition'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }
}
