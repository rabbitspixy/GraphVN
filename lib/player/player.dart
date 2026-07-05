import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:graph_vn/common/find_block_util.dart';
import 'package:graph_vn/common/random_util.dart';
import 'package:graph_vn/game/game_node.dart';
import 'package:graph_vn/game/game_transition.dart';
import 'package:graph_vn/main.dart';
import 'package:graph_vn/player/components.dart';
import 'package:graph_vn/game/game_state.dart';

class Player {
  static final ValueNotifier<PlayerImageInfo> imageInfoNotifier = ValueNotifier<PlayerImageInfo>(PlayerImageInfo(path: ''));
  static final ValueNotifier<String> speakerName = ValueNotifier<String>('');
  static final ValueNotifier<String> narrativeText = ValueNotifier<String>('');
  static final ValueNotifier<String> statusText = ValueNotifier('');
  static final ValueNotifier<List<ChoiseButton>> buttons = ValueNotifier<List<ChoiseButton>>([]);
  static final ValueNotifier<VariablesDiffDebug> variablesDiffDebug = ValueNotifier(VariablesDiffDebug(previous: {}, current: {}));

  static void onScreenClick() {
    useRandomTransitionIfAllowed();
  }

  static void useRandomTransitionIfAllowed() {
    final allowedTransitions = allowedTransitionsForCurrentState();
    if (allowedTransitions.any((x) => x.isButton)) {
      return;
    }
    final allowedEmptyTransitions = allowedTransitions.where((x) => !x.isButton).toList();
    final randomTransition = selectRandomTransition(allowedEmptyTransitions);
    if (randomTransition != null) {
      progressState(useTransition: randomTransition.id);
    }
  }

  /// Updates the player's state by following transitions starting from the current node.
  ///
  /// If [useTransition] is provided, the method will start from the transition
  /// with that ID. It then walks through the graph, following transitions
  /// until it reaches a node that has no outgoing transitions or until a
  /// maximum number of iterations is reached. The method also handles
  /// empty transitions (those without a button) by automatically selecting
  /// a random one when no button transitions are available.
  ///
  /// The method updates the global [GameState.currentNode] and
  /// triggers a UI update via [_updateStill].
  static void progressState({String? useTransition, String? goToNode}) {
    GameTransition? transition;
    if (useTransition != null) {
      transition = GameState.transitions.where((x) => x.id == useTransition).firstOrNull;
    }

    GameNode? node;
    if (goToNode != null) {
      node = GameState.nodes[goToNode];
    }
    
    int iterations = 0;
    int maxIterations = 10000;
    while (transition != null || node != null) {
      if (transition != null) {
        _runActions(transition.naturalLanguageAction);
        node = GameState.nodes[transition.to];
        transition = null;
      }
      if (node != null) {
        _runActions(node.naturalLanguageAction);
        GameState.currentNode = node.id;
        if (node.isEmpty) {
          final allowedTransitions = Player.allowedTransitionsForCurrentState();
          if (allowedTransitions.every((x) => !x.isButton)){
            transition = selectRandomTransition(allowedTransitions);
          }
        }
        if (node.gotoLabel.isNotEmpty) {
          node = GameState.findNodeByLabel(node.gotoLabel);
        } else {
          node = null;
        }
      }

      iterations++;
      if (iterations == maxIterations) {
        throw Exception('reached max iterations count');
      }
    }

    _updateStill();
  }

  static void _runActions(String naturalLanguageAction) {
    final emptyFunc = "function doActions() {}";
    final js = GameState.codeRepository.actions[naturalLanguageAction] ?? '';
    final result = GameState.jsRuntime.evaluate("$emptyFunc\n$js\ndoActions();");
    if (result.isError) {
      logger.w("Javascript error:\n$js\n\n${result.rawResult}");
    }
  }

  static List<GameTransition> allowedTransitionsForCurrentState() {
    return GameState.transitions
      .where((t) => t.from == GameState.currentNode)
      .where((t) => _resolveTransitionConditions(t.naturalLanguageCondition))
      .toList();
  }

  static bool _resolveTransitionConditions(String naturalLanguageCondition) {
    final emptyFunc = "function testConditions() { return true; }";
    final js = GameState.codeRepository.conditions[naturalLanguageCondition] ?? '';
    final result = GameState.jsRuntime.evaluate("$emptyFunc\n$js\ntestConditions();");
    if (result.isError) {
      logger.w("Javascript error:\n$js\n\n${result.rawResult}");
      return true;
    }
    if (result.rawResult == true && result.rawResult.runtimeType == bool) {
      return true;
    }
    if (result.rawResult == false && result.rawResult.runtimeType == bool) {
      return false;
    }
    throw Exception("JS condition invalid:\n$js\n\nrawResult=(${result.rawResult.runtimeType})${result.rawResult}");
  }

  static String _resolveGetTextValue(String js) {
    final emptyFunc = "function getText() { return \"\"; }";
    final result = GameState.jsRuntime.evaluate("$emptyFunc\n$js\ngetText();");
    if (result.isError) {
      logger.w("Javascript error:\n$js\n\n${result.rawResult}");
      return "JS_ERROR_2";
    }
    if (result.rawResult.runtimeType == String) {
      return result.rawResult;
    }
    throw Exception("JS getText() invalid:\n$js\n\nrawResult=(${result.rawResult.runtimeType})${result.rawResult}");
  }

  static void _updateStill() {
    buttons.value.clear();
    if (GameState.currentNode == "") {
      final initResult = initStartGame();
      if (!initResult) {
        return;
      }
    }
    final node = GameState.nodes[GameState.currentNode];
    if (node == null) {
      return;
    }
    String nt = node.text;
    for (final struct in GameState.structs) {
      for (final variable in struct.variables) {
        nt = nt.replaceAll("[${struct.name}->${variable.name}]", variable.currentValueAsText());
        final replaceables = findBlockDoubleCurlyBraces(node.text);
        for (final replaceable in replaceables) {
          final jsCode = GameState.codeRepository.replaceables[replaceable] ?? '';
          nt = nt.replaceAll(replaceable, _resolveGetTextValue(jsCode));
        }
      }
    }
    speakerName.value = node.speaker;
    narrativeText.value = nt;

    final st = StringBuffer();
    for (final struct in GameState.structs) {
      for (final variable in struct.variables) {
        var currentValueAsTextForPlayer = variable.currentValueAsTextForPlayer();
        if (currentValueAsTextForPlayer != null) {
          if (currentValueAsTextForPlayer.isNotEmpty) {
            st.writeln(currentValueAsTextForPlayer);
          }
        } else {
          st.writeln("${struct.name}-${variable.name}: ${variable.currentValueAsText()}");
        }
      }
    }
    statusText.value = st.toString();

    buttons.value = allowedTransitionsForCurrentState()
        .where((t) => t.isButton)
        .map((t) => ChoiseButton(text: t.text, transitionId: t.id))
        .toList();
    
    if (node.imagePath.isNotEmpty) {
      final file = File("projects/${GameState.projectDir}/images/${node.imagePath}");
      if (file.existsSync()) {
        imageInfoNotifier.value = PlayerImageInfo(
          path: file.path,
        );
      }
    }

    variablesDiffDebug.value = VariablesDiffDebug(
      previous: variablesDiffDebug.value.current,
      current: _collectVariablesForDebug(),
    );
  }

  static Map<String, String> _collectVariablesForDebug() {
    final Map<String, String> result = {};
    for (final struct in GameState.structs) {
      for (final variable in struct.variables) {
        final key = "${struct.name}->${variable.name}";
        result[key] = variable.currentValueAsText();
      }
    }
    return result;
  }

  static bool initStartGame() {
    GameState.restart();
    final startNode = GameState.nodes.values.where((node) => node.isStart).firstOrNull;
    if (startNode != null) {
      progressState(goToNode: startNode.id);
      return true;
    } else {
      clearState();
      return false;
    }
  }

  static void clearState() {
    imageInfoNotifier.value = PlayerImageInfo();
    speakerName.value = "";
    narrativeText.value = "";
    statusText.value = "";
    buttons.value = [];
  }
}
