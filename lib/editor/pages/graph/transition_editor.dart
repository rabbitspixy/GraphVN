import 'package:flutter/material.dart';
import 'package:graph_vn/common/number_util.dart';
import 'package:graph_vn/editor/modals/confirm_dialog.dart';
import 'package:graph_vn/editor/widgets/label_with_button.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/game/game_transition.dart';
import 'package:graph_vn/editor/modals/view_js_dialog.dart';

class TransitionEditor extends StatefulWidget {
  final GameTransition transition;
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
        LabelWithButton(
            label: 'Transition Text',
          help: [
            'Текст на кнопке перехода',
            '',
            'Если текста нет, то кнопка не отображается',
            'Если окажется так что у игрока нет вообще ниодной кнопки, то сработает случайный доступный бестекстовый переход'
          ],
        ),
        TextField(
          controller: _controller,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        LabelWithButton(
            label: 'Weight',
          help: [
            'Используется только для определения шанса случайного перехода',
            'Если во время выполнения случайного перехода доступно несколько переходов, то шанс работает как отношение веса одного перехода к весу другого перехода',
            'Например переход с весом 15, будет срабатывать в три раза чаще чем переход с весом 5, потому что 15 в три раза больше чем 5',
            'Шансы в процентах на примере с четырьмя доступными переходами:',
            'Переход с весом 1 - Шанс 1/20 (0.05%)',
            'Переход с весом 4 - Шанс 4/20 (0.2%)',
            'Переход с весом 5 - Шанс 5/20 (0.25%)',
            'Переход с весом 10 - Шанс 10/20 (0.5%)',
          ],
        ),
        TextField(
          controller: _weightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        LabelWithButton(
            label: 'Natural Language Condition',
          help: [
            'Условие доступности перехода на естественном языке'
          ],
          onShowJs: () {
            showJavascriptCodeDialog(context, GameState.codeRepository.conditions[widget.transition.naturalLanguageCondition] ?? '');
          },
        ),
        TextField(
          controller: _naturalLanguageConditionController,
          maxLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        LabelWithButton(
            label: 'Natural Language Action',
          help: [
            'Действия на естественном языке, которые выполнятся при совершении перехода'
          ],
          onShowJs: () {
            showJavascriptCodeDialog(context, GameState.codeRepository.actions[widget.transition.naturalLanguageAction] ?? '');
          },
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
            onPressed: () async {
              if (await showConfirmDialog(context, "Удалить переход?")) {
                GameState.deleteTransition(widget.transition.id);
                widget.onChange();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Transition'),
          ),
        ),
      ],
    );
  }
}
