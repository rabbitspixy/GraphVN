import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graph_vn/ai/ai_servers.dart';
import 'package:graph_vn/ai/image_generation/generate_image_metadata.dart';
import 'package:graph_vn/ai/image_generation/sd_cpp_client.dart';
import 'package:graph_vn/ai/llm/image_prompt_generator.dart';
import 'package:graph_vn/ai/llm/js_code_generator.dart';
import 'package:graph_vn/app_constants.dart';
import 'package:graph_vn/common/substring_util.dart';
import 'package:graph_vn/common/parallel_util.dart';
import 'package:graph_vn/game/game_node.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/game/game_transition.dart';
import 'package:graph_vn/main.dart';

class EditorAiAgentPage extends StatefulWidget {
  const EditorAiAgentPage({super.key});

  @override
  State<EditorAiAgentPage> createState() => _EditorAiAgentPageState();
}

class _EditorAiAgentPageState extends State<EditorAiAgentPage> {
  final TextEditingController _styleController = TextEditingController();
  StreamSubscription<String>? _subscription;

  @override
  void initState() {
    super.initState();
    _styleController.text = GameState.aiImageStyle;
    _subscription = GameState.stateUpdatedEvents.listen((_) {
      if (_styleController.text != GameState.aiImageStyle) {
        _styleController.text = GameState.aiImageStyle;
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _styleController.dispose();
    super.dispose();
  }

  void _runAiAgent() async {
    final totalTasks = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const _AiAgentProgressDialog(),
    );

    if (totalTasks != null && totalTasks > 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('AI агент завершил работу. Обработано: $totalTasks задач'),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: _styleController,
              decoration: const InputDecoration(
                labelText: 'AI Image Style',
                hintText: 'e.g. anime, realistic, pixel art, ...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                GameState.aiImageStyle = value;
              },
            ),
          ),
          const SizedBox(height: 24),
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
  const _AiAgentProgressDialog();

  @override
  State<_AiAgentProgressDialog> createState() => _AiAgentProgressDialogState();
}

class _AiAgentProgressDialogState extends State<_AiAgentProgressDialog> {
  int _totalTasks = 0;
  int _completedTasks = 0;

  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  void _onTaskCompleted() => setState(() => _completedTasks++);

  List<Future<void> Function()> _wrapWithProgress(
      List<Future<void> Function()> tasks) {
    return [
      for (final task in tasks) () async {
        await task();
        _onTaskCompleted();
      },
    ];
  }

  Future<void> _startProcessing() async {
    try {
      await _processAllTasks();
      if (mounted) {
        Navigator.pop(context, _totalTasks);
      }
    } catch (e) {
      logger.e("AI agent request error", error: e);
      if (mounted) {
        Navigator.pop(context, _totalTasks);
      }
    }
  }

  Future<void> _processAllTasks() async {
    final textGenerationTasks = <Future<void> Function()>[];
    final imageGenerationTasks = <Future<void> Function()>[];
    
    for (final node in GameState.nodes.values) {
      textGenerationTasks.addAll(_createNodeActionTasks(node));
      textGenerationTasks.addAll(_createNodeTriggerTasks(node));
      textGenerationTasks.addAll(_createNodeReplaceableTasks(node));
      textGenerationTasks.addAll(_createNodeImagePromptTasks(node));
    }

    for (final transition in GameState.transitions) {
      textGenerationTasks.addAll(_createTransitionConditionTasks(transition));
      textGenerationTasks.addAll(_createTransitionActionTasks(transition));
    }

    setState(() => _totalTasks = textGenerationTasks.length);
    
    if (textGenerationTasks.isNotEmpty) {
      await AiServers.ensureLlamaCppIsRunning();
      await runInParallel(_wrapWithProgress(textGenerationTasks), 4);
    }

    for (final node in GameState.nodes.values) {
      imageGenerationTasks.addAll(_createNodeImageGenerationTasks(node));
    }

    setState(() => _totalTasks = textGenerationTasks.length + imageGenerationTasks.length);

    if (imageGenerationTasks.isNotEmpty) {
      await AiServers.ensureStableDiffusionCppIsRunning();
      await runInParallel(_wrapWithProgress(imageGenerationTasks), 1);
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
      });
    }
    
    return tasks;
  }

  List<Future<void> Function()> _createNodeImagePromptTasks(GameNode node) {
    final tasks = <Future<void> Function()>[];

    if (node.imagePath.isEmpty && !node.isEmptyNode) {
      if (node.generateImageMetadata.every((m) => File("./${AppConstants.projectsDir}/${GameState.projectDir}/images/ai/${m.id}.jpg").existsSync())) {
        tasks.add(() async {
          final imagePrompt = await ImagePromptGenerator.writePrompt(
              GameState.aiImageStyle,
              node.text,
              GameState.findTransitions(to: node.id).where((t) => t.isButton).map((t) => t.text).toList(),
              GameState.findTransitions(from: node.id).where((t) => t.isButton).map((t) => t.text).toList()
          );
          if (imagePrompt != null) {
            node.generateImageMetadata.add(
                GenerateImageMetadata()
                  ..style = GameState.aiImageStyle
                  ..llmGeneratedPrompt = imagePrompt
            );
          }
        });
      }
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
      });
    }
    
    return tasks;
  }

  List<Future<void> Function()> _createNodeImageGenerationTasks(GameNode node) {
    final tasks = <Future<void> Function()>[];

    for (final generateImageMetadata in node.generateImageMetadata) {
      final imagePath = "ai/${generateImageMetadata.id}.jpg";
      final imageFile = File("./${AppConstants.projectsDir}/${GameState.projectDir}/images/$imagePath");
      if (imageFile.existsSync()) {
        continue;
      }
      tasks.add(() async {
        final imageBytes = await SDCppClient.generate(generateImageMetadata.llmGeneratedPrompt);
        await imageFile.parent.create(recursive: true);
        await imageFile.writeAsBytes(imageBytes);
        node.imagePath = imagePath;
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
