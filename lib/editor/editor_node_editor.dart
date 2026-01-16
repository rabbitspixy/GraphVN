import 'package:flutter/material.dart';
import 'package:touch_of_the_unknown/editor/editor_state.dart';
import 'package:touch_of_the_unknown/editor/editor_node.dart';

class EditorNodeEditor extends StatefulWidget {
  final String nodeId;
  const EditorNodeEditor({Key? key, required this.nodeId}) : super(key: key);

  @override
  State<EditorNodeEditor> createState() => _EditorNodeEditorState();
}

class _EditorNodeEditorState extends State<EditorNodeEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final node = EditorState.nodes[widget.nodeId];
    _controller = TextEditingController(text: node?.text ?? '');
    _controller.addListener(() {
      if (node != null) {
        node.text = _controller.text;
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
      ],
    );
  }
}
