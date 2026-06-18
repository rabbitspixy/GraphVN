import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/editor_transition.dart';
import 'package:graph_vn/llm/text_generator.dart';
import 'package:graph_vn/main.dart';

class EditorAiAgentPage extends StatefulWidget {
  const EditorAiAgentPage({super.key});

  @override
  State<EditorAiAgentPage> createState() => _EditorAiAgentPageState();
}

class _EditorAiAgentPageState extends State<EditorAiAgentPage> {
  late int _totalTasks;
  late int _completedTasks;
  late BuildContext _dialogContext;
  late StateSetter _dialogSetState;

  void _runAiAgent() async {
    _totalTasks = _nodesWithDirtyActions().length +
        _transitionsWithDirtyConditions().length +
        _transitionsWithDirtyActions().length;

    if (_totalTasks == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет задач для обработки AI агентом')),
      );
      return;
    }

    _completedTasks = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          _dialogContext = dialogContext;
          _dialogSetState = setDialogState;
          return _buildProgressDialog();
        },
      ),
    );

    final stopwatch = Stopwatch()..start();
    await _processAllTasks();
    stopwatch.stop();

    if (mounted) {
      Navigator.pop(_dialogContext);
      final duration = stopwatch.elapsed;
      final message = 'AI агент завершил работу. Обработано: $_totalTasks задач за ${duration.toString()}';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _processAllTasks() async {
    _processEmptyFields();
    
    final nodeActionLambdas = _processNodeActions();
    final transitionConditionLambdas = _processTransitionConditions();
    final transitionActionLambdas = _processTransitionActions();
    
    final allLambdas = [...nodeActionLambdas, ...transitionConditionLambdas, ...transitionActionLambdas];
    
    // Разбиваем на чанки по 4 элемента и выполняем каждый чанк параллельно
    const chunkSize = 4;
    for (int i = 0; i < allLambdas.length; i += chunkSize) {
      final chunk = allLambdas.sublist(
        i,
        i + chunkSize > allLambdas.length ? allLambdas.length : i + chunkSize,
      );
      await Future.wait(chunk.map((lambda) => lambda()));
    }
  }

  void _processEmptyFields() {
    for (final node in EditorState.nodes.values) {
      if (node.naturalLanguageAction.isEmpty) {
        node.jsAction = "";
      }
    }
    for (final transition in EditorState.transitions) {
      if (transition.naturalLanguageCondition.isEmpty) {
        transition.jsCondition = "";
      }
      if (transition.naturalLanguageAction.isEmpty) {
        transition.jsAction = "";
      }
    }
  }

  List<Future<void> Function()> _processNodeActions() {
    final lambdas = <Future<void> Function()>[];
    for (final node in _nodesWithDirtyActions()) {
      lambdas.add(() async {
        final code = await TextGenerator.writeAction(node.naturalLanguageAction);
        if (code != null) {
          node.jsAction = code;
        } else {
          logger.w("No code generated for actions of node ${node.id}");
        }
        _completedTasks++;
        _dialogSetState(() {});
        await Future.delayed(Duration.zero);
      });
    }
    return lambdas;
  }

  List<Future<void> Function()> _processTransitionConditions() {
    final lambdas = <Future<void> Function()>[];
    for (final transition in _transitionsWithDirtyConditions()) {
      lambdas.add(() async {
        final code = await TextGenerator.writeCondition(transition.naturalLanguageCondition);
        if (code != null) {
          transition.jsCondition = code;
        } else {
          logger.w("No code generated for conditions of transition ${transition.id}");
        }
        _completedTasks++;
        _dialogSetState(() {});
        await Future.delayed(Duration.zero);
      });
    }
    return lambdas;
  }

  List<Future<void> Function()> _processTransitionActions() {
    final lambdas = <Future<void> Function()>[];
    for (final transition in _transitionsWithDirtyActions()) {
      lambdas.add(() async {
        final code = await TextGenerator.writeAction(transition.naturalLanguageAction);
        if (code != null) {
          transition.jsAction = code;
        } else {
          logger.w("No code generated for actions of transition ${transition.id}");
        }
        _completedTasks++;
        _dialogSetState(() {});
        await Future.delayed(Duration.zero);
      });
    }
    return lambdas;
  }

  Widget _buildProgressDialog() {
    return AlertDialog(
      title: const Text('Обработка AI агентом'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Выполнено: $_completedTasks из $_totalTasks'),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: _completedTasks / _totalTasks),
        ],
      ),
    );
  }

  List<EditorNode> _nodesWithDirtyActions() {
    return EditorState.nodes.values.where((n) => n.naturalLanguageAction.isNotEmpty).toList();
  }

  List<EditorTransition> _transitionsWithDirtyConditions() {
    return EditorState.transitions.where((x) => x.naturalLanguageCondition.isNotEmpty).toList();
  }

  List<EditorTransition> _transitionsWithDirtyActions() {
    return EditorState.transitions.where((x) => x.naturalLanguageAction.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _runAiAgent,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.play_arrow),
            SizedBox(width: 8),
            Text('Запустить AI агент'),
          ],
        ),
      ),
    );
  }
}
