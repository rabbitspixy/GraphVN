import 'package:flutter/material.dart';
import 'package:touch_of_the_unknown/editor/editor_node.dart';
import 'package:touch_of_the_unknown/editor/editor_state.dart';

class EditorNodeEditor extends StatefulWidget {
  final EditorNode node;
  final VoidCallback onChange;

  EditorNodeEditor({
    required this.node,
    required this.onChange,
  }) : super(key: ValueKey(node));

  @override
  State<EditorNodeEditor> createState() => _EditorNodeEditorState();
}

class _EditorNodeEditorState extends State<EditorNodeEditor> {
  late TextEditingController _controller;
  bool _isStart = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.node.text);
    _isStart = widget.node.isStart;
    _controller.addListener(() {
      if (_controller.text != widget.node.text) {
        widget.node.text = _controller.text;
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
        const Text('Node Text:', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _controller,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        Row(
          children: [
            Checkbox(
              value: _isStart,
              onChanged: (bool? value) {
                setState(() {
                  _isStart = value ?? false;
                  widget.node.isStart = _isStart;
                  widget.onChange();
                });
              },
            ),
            const Text('Start Node'),
          ],
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            EditorState.deleteNode(widget.node.id);
            widget.onChange();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete Node'),
        ),
      ],
    );
  }
}
