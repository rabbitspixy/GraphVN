import 'package:flutter/material.dart';
import 'package:graph_vn/editor/modals/confirm_dialog.dart';
import 'package:graph_vn/game/game_node.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/editor/modals/view_js_dialog.dart';
import 'package:graph_vn/editor/widgets/label_with_button.dart';

class NodeEditor extends StatefulWidget {
  final GameNode node;
  final VoidCallback onChange;

  NodeEditor({
    required this.node,
    required this.onChange,
  }) : super(key: ValueKey(node));

  @override
  State<NodeEditor> createState() => _NodeEditorState();
}

class _NodeEditorState extends State<NodeEditor> {
  late TextEditingController _nameTextController;
  late TextEditingController _textTextController;
  late TextEditingController _speakerTextController;
  late TextEditingController _labelTextController;
  late TextEditingController _imagePathController;
  late TextEditingController _naturalLanguageTriggerController;
  late TextEditingController _naturalLanguageActionController;
  late TextEditingController _gotoLabelTextController;
  bool _isStart = false;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController(text: widget.node.name);
    _textTextController = TextEditingController(text: widget.node.text);
    _speakerTextController = TextEditingController(text: widget.node.speaker);
    _labelTextController = TextEditingController(text: widget.node.label);
    _imagePathController = TextEditingController(text: widget.node.imagePath);
    _naturalLanguageTriggerController = TextEditingController(text: widget.node.naturalLanguageTrigger);
    _naturalLanguageActionController = TextEditingController(text: widget.node.naturalLanguageAction);
    _gotoLabelTextController = TextEditingController(text: widget.node.gotoLabel);
    _isStart = widget.node.isStart;
    _nameTextController.addListener(() {
      if (_nameTextController.text != widget.node.name) {
        widget.node.name = _nameTextController.text;
        widget.onChange();
        setState(() {});
      }
    });
    _textTextController.addListener(() {
      if (_textTextController.text != widget.node.text) {
        widget.node.text = _textTextController.text;
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
    _naturalLanguageTriggerController.addListener(() {
      if (_naturalLanguageTriggerController.text != widget.node.naturalLanguageTrigger) {
        widget.node.naturalLanguageTrigger = _naturalLanguageTriggerController.text;
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
    _gotoLabelTextController.addListener(() {
      if (_gotoLabelTextController.text != widget.node.gotoLabel) {
        widget.node.gotoLabel = _gotoLabelTextController.text;
        widget.onChange();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _textTextController.dispose();
    _speakerTextController.dispose();
    _labelTextController.dispose();
    _imagePathController.dispose();
    _naturalLanguageTriggerController.dispose();
    _naturalLanguageActionController.dispose();
    _gotoLabelTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelWithButton(
          label: 'Название',
          help: [
            'Название узла',
          ],
        ),
        TextField(
          controller: _nameTextController,
          maxLines: 1,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        LabelWithButton(
          label: 'Label',
          help: [
            'Метка узла.',
            'Отображается на графе узла.',
            'Позволяет сделать переход в узел через поле Goto label',
          ],
        ),
        TextField(
          controller: _labelTextController,
          maxLines: 1,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        LabelWithButton(
            label: 'Speaker',
          help: [
            'Отображается как имя говорящего персонажа над текстом'
          ],
        ),
        TextField(
          controller: _speakerTextController,
          minLines: 1,
          maxLines: 2,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        LabelWithButton(
            label: 'Text',
          help: [
            'Отображаемый текст',
            '',
            'ИИ вставка текста:',
            '{{ Количество здоровья }} - блок из двоных фигурных скобок, с инструкцией внутри что нужно вставить в это место в тексте.',
            '(( В комнате темно )) - блок из двойных круглых скобок, это комментарий. AI увидит этот комментарий, а игрок нет.'
          ],
        ),
        TextField(
          controller: _textTextController,
          maxLines: 18,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        LabelWithButton(
            label: 'Image Path',
          help: [
            'Путь к отображаемому изображению'
          ],
        ),
        TextField(
          controller: _imagePathController,
          maxLines: 1,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        LabelWithButton(
          label: 'Natural Language Trigger',
          onShowJs: () {
            showJavascriptCodeDialog(context, GameState.codeRepository.conditions[widget.node.naturalLanguageTrigger] ?? '');
          },
          help: [
            'Триггер-проверка на естественном языке',
            'Если проверка сработает, то игрока моментально перенесет в этот узел',
            'Если игрок уже находится в этом узле, то ничего не произойдёт',
          ],
        ),
        TextField(
          controller: _naturalLanguageTriggerController,
          minLines: 1,
          maxLines: 5,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        LabelWithButton(
          label: 'Natural Language Action',
          onShowJs: () {
            showJavascriptCodeDialog(context, GameState.codeRepository.actions[widget.node.naturalLanguageAction] ?? '');
          },
          help: [
            'Действия на естественном языке, которые выполняются при переходе в этот узел',
            'Действия выполняются до отображения текста узла',
          ],
        ),
        TextField(
          controller: _naturalLanguageActionController,
          minLines: 1,
          maxLines: 5,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        LabelWithButton(
            label: 'Goto label',
          help: [
            'Если сюда вписать корректную метку узла, то игрока моментально перенесет в указанный узел без отображения текста в текущем узле'
          ],
        ),
        TextField(
          controller: _gotoLabelTextController,
          maxLines: 1,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
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
            LabelWithButton(
                label: 'Start Node',
              help: [
                'Стартовая локация',
                'Может быть только одна'
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (await showConfirmDialog(context, "Удалить узел?")) {
                GameState.deleteNode(widget.node.id);
                widget.onChange();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Удалить узел'),
          ),
        ),
      ],
    );
  }
}
