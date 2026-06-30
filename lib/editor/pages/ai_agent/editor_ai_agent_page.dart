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
          return _buildProgressDialog();
        },
      ),
    );

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
    _processEmptyFields();
    _refindReplaceableInTexts();
    
    final nodeActionLambdas = _processNodeActions();
    final transitionConditionLambdas = _processTransitionConditions();
    final transitionActionLambdas = _processTransitionActions();
    final replaceableTasks = _processNodeReplaceable();
    
    final allLambdas = [...nodeActionLambdas, ...transitionConditionLambdas, ...transitionActionLambdas, ...replaceableTasks];
    _totalTasks = allLambdas.length;
    
    await runInParallel(allLambdas, 4);
  }

  void _processEmptyFields() {
    for (final node in GameState.nodes.values) {
      if (node.naturalLanguageAction.isEmpty) {
        node.jsAction = "";
      }
    }
    for (final transition in GameState.transitions) {
      if (transition.naturalLanguageCondition.isEmpty) {
        transition.jsCondition = "";
      }
      if (transition.naturalLanguageAction.isEmpty) {
        transition.jsAction = "";
      }
    }
  }

  void _refindReplaceableInTexts() {
    for (final node in GameState.nodes.values) {
      node.jsReplace = filterMapByKeys(
          node.jsReplace,
          findBlockDoubleCurlyBraces(node.text)
      );
    }
    //TODO: сделать тоже самое для transitions
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

  List<Future<void> Function()> _processNodeReplaceable() {
    final tasks = <Future<void> Function()>[];
    for (final node in GameState.nodes.values) {
      for (final replaceable in node.jsReplace.keys) {
        tasks.add(() async {
          final code = await TextGenerator.writeReplaceable(replaceable.replaceAll("{{", "").replaceAll("}}", ""));
          if (code != null) {
            node.jsReplace[replaceable] = code;
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

  List<GameNode> _nodesWithDirtyActions() {
    return GameState.nodes.values.where((n) => n.naturalLanguageAction.isNotEmpty).toList();
  }

  List<GameTransition> _transitionsWithDirtyConditions() {
    return GameState.transitions.where((x) => x.naturalLanguageCondition.isNotEmpty).toList();
  }

  List<GameTransition> _transitionsWithDirtyActions() {
    return GameState.transitions.where((x) => x.naturalLanguageAction.isNotEmpty).toList();
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
