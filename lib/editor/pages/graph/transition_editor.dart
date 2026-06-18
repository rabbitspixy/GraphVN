import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graph_vn/common/number_util.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/editor_transition.dart';
import 'package:graph_vn/editor/modals/view_js_dialog.dart';
import 'package:graph_vn/llm/text_generator.dart';
import 'package:graph_vn/main.dart';

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
  late TextEditingController _naturalLanguageConditionController;
  late TextEditingController _naturalLanguageActionController;

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
    _naturalLanguageConditionController = TextEditingController(text: widget.transition.naturalLanguageCondition);
    _naturalLanguageConditionController.addListener(() {
      if (_naturalLanguageConditionController.text != widget.transition.naturalLanguageCondition) {
        widget.transition.naturalLanguageCondition = _naturalLanguageConditionController.text;
        widget.onChange();
        setState(() {});
      }
    });
    _naturalLanguageActionController = TextEditingController(text: widget.transition.naturalLanguageAction);
    _naturalLanguageActionController.addListener(() {
      if (_naturalLanguageActionController.text != widget.transition.naturalLanguageAction) {
        widget.transition.naturalLanguageAction = _naturalLanguageActionController.text;
        widget.onChange();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _weightController.dispose();
    _naturalLanguageConditionController.dispose();
    _naturalLanguageActionController.dispose();
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
        const Text('Weight:', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _weightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Natural Language Condition:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Просмотр JS Condition',
              child: SizedBox(
                width: 24,
                height: 24,
                child: IconButton(
                  icon: const Icon(Icons.visibility, size: 14),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showJavascriptCodeDialog(context, widget.transition.jsCondition);
                  },
                ),
              ),
            ),
          ],
        ),
        TextField(
          controller: _naturalLanguageConditionController,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Natural Language Action:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Просмотр JS Action',
              child: SizedBox(
                width: 24,
                height: 24,
                child: IconButton(
                  icon: const Icon(Icons.visibility, size: 14),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showJavascriptCodeDialog(context, widget.transition.jsAction);
                  },
                ),
              ),
            ),
          ],
        ),
        TextField(
          controller: _naturalLanguageActionController,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
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
