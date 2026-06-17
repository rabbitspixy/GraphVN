import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/llm/text_generator.dart';
import 'package:graph_vn/main.dart';

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
  late TextEditingController _jsActionController;
  late TextEditingController _naturalLanguageActionController;
  bool _isStart = false;
  bool _isActionGenerating = false;

  @override
  void initState() {
    super.initState();
    _nodeTextController = TextEditingController(text: widget.node.text);
    _speakerTextController = TextEditingController(text: widget.node.speaker);
    _labelTextController = TextEditingController(text: widget.node.label);
    _imagePathController = TextEditingController(text: widget.node.imagePath);
    _jsActionController = TextEditingController(text: widget.node.jsAction);
    _naturalLanguageActionController = TextEditingController(text: widget.node.naturalLanguageAction);
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
    _jsActionController.addListener(() {
      if (_jsActionController.text != widget.node.jsAction) {
        widget.node.jsAction = _jsActionController.text;
        widget.onChange();
        setState(() {});
      }
    });
    _naturalLanguageActionController.addListener(() {
      if (_naturalLanguageActionController.text != widget.node.naturalLanguageAction) {
        widget.node.naturalLanguageAction = _naturalLanguageActionController.text;
        widget.onChange();
        setState(() {});
      }
    });
  }

  void _doActionGenerate() async {
    if (_isActionGenerating) return;
    
    setState(() {
      _isActionGenerating = true;
    });
    
    final code = await TextGenerator.writeAction(widget.node.naturalLanguageAction);
    if (code != null) {
      _jsActionController.text = code;
    } else {
      logger.w("No code generated");
    }
    
    setState(() {
      _isActionGenerating = false;
    });
  }

  @override
  void dispose() {
    _nodeTextController.dispose();
    _imagePathController.dispose();
    _jsActionController.dispose();
    _naturalLanguageActionController.dispose();
    super.dispose();
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
        const Text('Natural Language Action:', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _naturalLanguageActionController,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          style: GoogleFonts.robotoMono(),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isActionGenerating ? null : _doActionGenerate,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isActionGenerating ? Colors.grey : null,
            ),
            child: _isActionGenerating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Generate'),
          ),
        ),
        const Text('JS Action:', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _jsActionController,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          style: GoogleFonts.robotoMono(),
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
