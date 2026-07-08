import 'package:flutter/material.dart';
import 'package:graph_vn/common/substring_util.dart';
import 'package:graph_vn/common/parallel_util.dart';
import 'package:graph_vn/game/game_node.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/game/game_transition.dart';
import 'package:graph_vn/llm/js_code_generator.dart';
import 'package:graph_vn/main.dart';

class EditorAiAgentPage extends StatefulWidget {
  const EditorAiAgentPage({super.key});

  @override
  State<EditorAiAgentPage> createState() => _EditorAiAgentPageState();
}

class _EditorAiAgentPageState extends State<EditorAiAgentPage> {
  int _totalTasks = 0;
  int _completedTasks = 0;

  void _runAiAgent() async {
    _totalTasks = 0;
    _completedTasks = 0;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _AiAgentProgressDialog(
        totalTasks: _totalTasks,
        completedTasks: _completedTasks,
        onTaskCompleted: () => setState(() => _completedTasks++),
      ),
    );
    
    if (_totalTasks > 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('AI агент завершил работу. Обработано: $_totalTasks задач'),
        ),
      );
    }
  }

  Future<void> _clearGeneratedCode() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Очистить сгенерированный код'),
        content: const Text('Вы уверены, что хотите очистить весь сгенерированный код?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Очистить'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      GameState.codeRepository.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Сгенерированный код очищен'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
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
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _clearGeneratedCode,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.clear),
                SizedBox(width: 8),
                Text('Очистить сгенерированный код'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AiAgentProgressDialog extends StatefulWidget {
  final int totalTasks;
  final int completedTasks;
  final void Function() onTaskCompleted;

  const _AiAgentProgressDialog({
    required this.totalTasks,
    required this.completedTasks,
    required this.onTaskCompleted,
  });

  @override
  State<_AiAgentProgressDialog> createState() => _AiAgentProgressDialogState();
}

class _AiAgentProgressDialogState extends State<_AiAgentProgressDialog> {
  late int _totalTasks;
  late int _completedTasks;

  @override
  void initState() {
    super.initState();
    _totalTasks = widget.totalTasks;
    _completedTasks = widget.completedTasks;
    _startProcessing();
  }

  Future<void> _startProcessing() async {
    try {
      await _processAllTasks();
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      logger.e("AI agent request error", error: e);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _processAllTasks() async {
    final tasks = <Future<void> Function()>[];
    
    for (final node in GameState.nodes.values) {
      tasks.addAll(_createNodeActionTasks(node));
      tasks.addAll(_createNodeTriggerTasks(node));
      tasks.addAll(_createNodeReplaceableTasks(node));
    }

    for (final transition in GameState.transitions) {
      tasks.addAll(_createTransitionConditionTasks(transition));
      tasks.addAll(_createTransitionActionTasks(transition));
    }

    setState(() => _totalTasks = tasks.length);
    
    if (tasks.isNotEmpty) {
      await runInParallel(tasks, 4);
    }
  }

  List<Future<void> Function()> _createNodeActionTasks(GameNode node) {
    final tasks = <Future<void> Function()>[];
    
    if (node.naturalLanguageAction.isNotEmpty &&
        !GameState.codeRepository.actions.containsKey(node.naturalLanguageAction)) {
      tasks.add(() async {
        final code = await JsCodeGenerator.writeAction(node.naturalLanguageAction);
        if (code != null) {
          GameState.codeRepository.actions[node.naturalLanguageAction] = code;
        } else {
          logger.w("No code generated for actions of node ${node.id}");
        }
        widget.onTaskCompleted();
      });
    }
    
    return tasks;
  }

  List<Future<void> Function()> _createNodeTriggerTasks(GameNode node) {
    final tasks = <Future<void> Function()>[];
    
    if (node.naturalLanguageTrigger.isNotEmpty &&
        !GameState.codeRepository.conditions.containsKey(node.naturalLanguageTrigger)) {
      tasks.add(() async {
        final code = await JsCodeGenerator.writeCondition(node.naturalLanguageTrigger);
        if (code != null) {
          GameState.codeRepository.conditions[node.naturalLanguageTrigger] = code;
        } else {
          logger.w("No code generated for trigger of node ${node.id}");
        }
        widget.onTaskCompleted();
      });
    }
    
    return tasks;
  }

  List<Future<void> Function()> _createNodeReplaceableTasks(GameNode node) {
    final tasks = <Future<void> Function()>[];
    final replaceables = findBlockDoubleCurlyBraces(node.text);
    
    for (final replaceable in replaceables) {
      if (replaceable.isEmpty ||
          GameState.codeRepository.replaceables.containsKey(replaceable)) {
        continue;
      }
      
      final cleanReplaceable = replaceable.replaceAll("{{", "").replaceAll("}}", "");
      
      tasks.add(() async {
        final code = await JsCodeGenerator.writeReplaceable(cleanReplaceable);
        if (code != null) {
          GameState.codeRepository.replaceables[replaceable] = code;
        } else {
          logger.w("No code generated for replaceable $replaceable of node ${node.id}");
        }
        widget.onTaskCompleted();
      });
    }
    
    return tasks;
  }

  List<Future<void> Function()> _createTransitionConditionTasks(GameTransition transition) {
    final tasks = <Future<void> Function()>[];
    
    if (transition.naturalLanguageCondition.isNotEmpty &&
        !GameState.codeRepository.conditions.containsKey(transition.naturalLanguageCondition)) {
      tasks.add(() async {
        final code = await JsCodeGenerator.writeCondition(transition.naturalLanguageCondition);
        if (code != null) {
          GameState.codeRepository.conditions[transition.naturalLanguageCondition] = code;
        } else {
          logger.w("No code generated for conditions of transition ${transition.id}");
        }
        widget.onTaskCompleted();
      });
    }
    
    return tasks;
  }

  List<Future<void> Function()> _createTransitionActionTasks(GameTransition transition) {
    final tasks = <Future<void> Function()>[];
    
    if (transition.naturalLanguageAction.isNotEmpty &&
        !GameState.codeRepository.actions.containsKey(transition.naturalLanguageAction)) {
      tasks.add(() async {
        final code = await JsCodeGenerator.writeAction(transition.naturalLanguageAction);
        if (code != null) {
          GameState.codeRepository.actions[transition.naturalLanguageAction] = code;
        } else {
          logger.w("No code generated for actions of transition ${transition.id}");
        }
        widget.onTaskCompleted();
      });
    }
    
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalTasks > 0 ? _completedTasks / _totalTasks : 0.0;

    return AlertDialog(
      title: const Text('Обработка AI агентом'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Выполнено: $_completedTasks из $_totalTasks'),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: progress),
        ],
      ),
    );
  }
}
