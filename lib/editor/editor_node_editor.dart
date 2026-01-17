import 'package:flutter/material.dart';
import 'package:touch_of_the_unknown/editor/editor_state.dart';

class EditorNodeEditor extends StatefulWidget {
  final String nodeId;
  const EditorNodeEditor({Key? key, required this.nodeId}) : super(key: key);

  @override
  State<EditorNodeEditor> createState() => _EditorNodeEditorState();
}

class _EditorNodeEditorState extends State<EditorNodeEditor> {
  late TextEditingController _controller;
  bool _isStart = false;

  @override
  void initState() {
    super.initState();
    final node = EditorState.nodes[widget.nodeId];
    _controller = TextEditingController(text: node?.text ?? '');
    _isStart = node?.isStart ?? false;
    _controller.addListener(() {
      if (node != null && _controller.text != node.text) {
        node.text = _controller.text;
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(covariant EditorNodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final node = EditorState.nodes[widget.nodeId];
    if (node != null) {
      _controller.text = node.text;
      _isStart = node.isStart;
    }
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
                  final node = EditorState.nodes[widget.nodeId];
                  if (node != null) {
                    node.isStart = _isStart;
                  }
                });
              },
            ),
            const Text('Start Node'),
          ],
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            EditorState.deleteNode(widget.nodeId);
          },
          child: const Text('Delete Node'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }
}
