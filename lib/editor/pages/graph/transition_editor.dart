import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graph_vn/common/number_util.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/editor_transition.dart';
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
  late TextEditingController _jsConditionController;
  late TextEditingController _jsActionController;
  late TextEditingController _naturalLanguageConditionController;
  late TextEditingController _naturalLanguageActionController;
  bool _isActionGenerating = false;
  bool _isConditionGenerating = false;

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
    _jsConditionController = TextEditingController(text: widget.transition.jsCondition);
    _jsConditionController.addListener(() {
      if (_jsConditionController.text != widget.transition.jsCondition) {
        widget.transition.jsCondition = _jsConditionController.text;
        widget.onChange();
        setState(() {});
      }
    });
    _jsActionController = TextEditingController(text: widget.transition.jsAction);
    _jsActionController.addListener(() {
      if (_jsActionController.text != widget.transition.jsAction) {
        widget.transition.jsAction = _jsActionController.text;
        widget.onChange();
        setState(() {});
      }
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

  void _doActionGenerate() async {
    if (_isActionGenerating) return;

    setState(() {
      _isActionGenerating = true;
    });

    final code = await TextGenerator.writeAction(widget.transition.naturalLanguageAction);
    if (code != null) {
      _jsActionController.text = code;
    } else {
      logger.w("No code generated");
    }

    setState(() {
      _isActionGenerating = false;
    });
  }

  void _doConditionGenerate() async {
    if (_isConditionGenerating) return;

    setState((){
      _isConditionGenerating = true;
    });

    final code = await TextGenerator.writeCondition(widget.transition.naturalLanguageCondition);
    if (code != null) {
      _jsConditionController.text = code;
    } else {
      logger.w("No code generated");
    }

    setState((){
      _isConditionGenerating = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _weightController.dispose();
    _jsConditionController.dispose();
    _jsActionController.dispose();
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
        const Text('Natural Language Condition:', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _naturalLanguageConditionController,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          style: GoogleFonts.robotoMono(),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isConditionGenerating ? null : _doConditionGenerate,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isConditionGenerating ? Colors.grey : null,
            ),
            child: _isConditionGenerating
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text('Generate'),
          ),
        ),
        const SizedBox(height: 8),
        const Text('JS Condition:', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _jsConditionController,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          style: GoogleFonts.robotoMono(),
        ),
        const SizedBox(height: 8),
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
        const SizedBox(height: 8),
        const Text('JS Action:', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _jsActionController,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          style: GoogleFonts.robotoMono(),
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
