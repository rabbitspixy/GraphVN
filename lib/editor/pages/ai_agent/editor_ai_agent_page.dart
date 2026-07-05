import 'package:flutter/material.dart';
import 'package:graph_vn/common/collection_util.dart';
import 'package:graph_vn/common/find_block_util.dart';
import 'package:graph_vn/common/parallel_util.dart';
import 'package:graph_vn/game/game_node.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/game/game_transition.dart';
import 'package:graph_vn/llm/text_generator.dart';
import 'package:graph_vn/main.dart';

class EditorAiAgentPage extends StatefulWidget {
  const EditorAiAgentPage({super.key});

  @override
  State<EditorAiAgentPage> createState() => _EditorAiAgentPageState();
}

class _EditorAiAgentPageState extends State<EditorAiAgentPage> {
  int _totalTasks = 0;
  int _completedTasks = 0;
  late BuildContext _dialogContext;
  late StateSetter _dialogSetState;

  void _runAiAgent() async {
    //TODO: обработать ошибки LLM, например нет подключения
    _totalTasks = 0;
    _completedTasks = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          _dialogContext = dialogContext;
          _dialogSetState = setDialogState;
          _runAiAgentStep2();
          return _buildProgressDialog();
        },
      ),
    );
  }

  void _runAiAgentStep2() async {
    final stopwatch = Stopwatch()..start();
    try {
      await _processAllTasks();
      stopwatch.stop();

      if (mounted) {
        Navigator.pop(_dialogContext);
        final duration = stopwatch.elapsed;
        final message = 'AI агент завершил работу. Обработано: $_totalTasks задач за ${duration.toString()}';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      logger.e("AI agent request error", error: e);
      if (mounted) {
        Navigator.pop(_dialogContext);
        final errorMessage = 'Ошибка: $e';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  Future<void> _processAllTasks() async {
    final tasks = [
      ..._nodeActionTasks(),
      ..._transitionConditionTasks(),
      ..._transitionActionTasks(),
      ..._nodeReplaceableTasks()
    ];
    _totalTasks = tasks.length;
    
    await runInParallel(tasks, 4);
  }

  List<Future<void> Function()> _nodeActionTasks() {
    final lambdas = <Future<void> Function()>[];
    for (final node in GameState.nodes.values) {
      if (node.naturalLanguageAction.isEmpty) {
        continue;
      }
      if (GameState.codeRepository.actions.containsKey(node.naturalLanguageAction)) {
        continue;
      }
      lambdas.add(() async {
        final code = await TextGenerator.writeAction(node.naturalLanguageAction);
        if (code != null) {
          GameState.codeRepository.actions[node.naturalLanguageAction] = code;
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

  List<Future<void> Function()> _transitionConditionTasks() {
    final lambdas = <Future<void> Function()>[];
    for (final transition in GameState.transitions) {
      if (transition.naturalLanguageCondition.isEmpty) {
        continue;
      }
      if (GameState.codeRepository.conditions.containsKey(transition.naturalLanguageCondition)) {
        continue;
      }
      lambdas.add(() async {
        final code = await TextGenerator.writeCondition(transition.naturalLanguageCondition);
        if (code != null) {
          GameState.codeRepository.conditions[transition.naturalLanguageCondition] = code;
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

  List<Future<void> Function()> _transitionActionTasks() {
    final lambdas = <Future<void> Function()>[];
    for (final transition in GameState.transitions) {
      if (transition.naturalLanguageAction.isEmpty) {
        continue;
      }
      if (GameState.codeRepository.actions.containsKey(transition.naturalLanguageAction)) {
        continue;
      }
      lambdas.add(() async {
        final code = await TextGenerator.writeAction(transition.naturalLanguageAction);
        if (code != null) {
          GameState.codeRepository.actions[transition.naturalLanguageAction] = code;
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

  List<Future<void> Function()> _nodeReplaceableTasks() {
    final tasks = <Future<void> Function()>[];
    for (final node in GameState.nodes.values) {
      final replaceables = findBlockDoubleCurlyBraces(node.text);
      for (final replaceable in replaceables) {
        if (replaceable.isEmpty) {
          continue;
        }
        if (GameState.codeRepository.replaceables.containsKey(replaceable)) {
          continue;
        }
        tasks.add(() async {
          final code = await TextGenerator.writeReplaceable(replaceable.replaceAll("{{", "").replaceAll("}}", ""));
          if (code != null) {
            GameState.codeRepository.replaceables[replaceable] = code;
          } else {
            logger.w("No code generated for replaceable $replaceable of node ${node.id}");
          }
          _completedTasks++;
          _dialogSetState(() {});
          await Future.delayed(Duration.zero);
        });
      }
    }
    return tasks;
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
