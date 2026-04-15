import 'package:flutter/material.dart';
import 'package:graph_vn/editor/actions/do_nothing.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/modals/struct_action_editor.dart';

class NodeEditor extends StatefulWidget {
  final EditorNode node;
  final VoidCallback onChange;

  NodeEditor({
    required this.node,
    required this.onChange,
  }) : super(key: ValueKey(node));

  @override
  State<NodeEditor> createState() => _NodeEditorState();
}

class _NodeEditorState extends State<NodeEditor> {
  late TextEditingController _nodeTextController;
  late TextEditingController _speakerTextController;
  late TextEditingController _labelTextController;
  late TextEditingController _imagePathController;
  bool _isStart = false;

  @override
  void initState() {
    super.initState();
    _nodeTextController = TextEditingController(text: widget.node.text);
    _speakerTextController = TextEditingController(text: widget.node.speaker);
    _labelTextController = TextEditingController(text: widget.node.label);
    _imagePathController = TextEditingController(text: widget.node.imagePath);
    _isStart = widget.node.isStart;
    _nodeTextController.addListener(() {
      if (_nodeTextController.text != widget.node.text) {
        widget.node.text = _nodeTextController.text;
        widget.onChange();
        setState(() {});
      }
    });
    _speakerTextController.addListener(() {
      if (_speakerTextController.text != widget.node.speaker) {
        widget.node.speaker = _speakerTextController.text;
        widget.onChange();
        setState(() {});
      }
    });
    _labelTextController.addListener(() {
      if (_labelTextController.text != widget.node.label) {
        widget.node.label = _labelTextController.text;
        widget.onChange();
        setState(() {});
      }
    });
    _imagePathController.addListener(() {
      if (_imagePathController.text != widget.node.imagePath) {
        widget.node.imagePath = _imagePathController.text;
        widget.onChange();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nodeTextController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  Future<void> _addAction() async {
    final action = await editStructAction(context, DoNothing());
    if (action != null) {
      setState(() {
        widget.node.actions.add(action);
        widget.onChange();
      });
    }
  }

  Widget _buildActionList() {
    final widgets = <Widget>[];
    for (final action in widget.node.actions) {
      final actionText = action.actionText();
      widgets.add(
        ListTile(
          title: Text(actionText),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                widget.node.actions.remove(action);
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
          label: const Text('Add Action'),
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
        const Text('Speaker:', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _speakerTextController,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const Text('Text:', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _nodeTextController,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const Text('Label:', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _labelTextController,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const Text('Image Path:', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _imagePathController,
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
        const Text('Actions:', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildActionList(),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              EditorState.deleteNode(widget.node.id);
              widget.onChange();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Node'),
          ),
        ),
      ],
    );
  }
}
