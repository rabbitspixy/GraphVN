import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:graph_vn/common/substring_util.dart';
import 'package:graph_vn/common/random_util.dart';
import 'package:graph_vn/game/game_node.dart';
import 'package:graph_vn/game/game_transition.dart';
import 'package:graph_vn/main.dart';
import 'package:graph_vn/player/player_models.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:universal_gamepad/universal_gamepad.dart';

class Player {
  static final ValueNotifier<PlayerBackgroundImage> backgroundImageNotifier = ValueNotifier<PlayerBackgroundImage>(PlayerBackgroundImage());
  static final ValueNotifier<String> speakerName = ValueNotifier<String>('');
  static final ValueNotifier<String> narrativeText = ValueNotifier<String>('');
  static final ValueNotifier<List<ChoiceButton>> buttons = ValueNotifier<List<ChoiceButton>>([]);
  static final ValueNotifier<VariablesDiffDebug> variablesDiffDebug = ValueNotifier(VariablesDiffDebug(previous: {}, current: {}));
  static final ValueNotifier<int> narrativeVersion = ValueNotifier<int>(0);

  static bool animationInProgress = false;

  static bool onScreenClick() {
    if (animationInProgress) {
      animationInProgress = false;
      return true;
    } else {
      final randomTransitionUsed = useRandomTransitionIfAllowed();
      return randomTransitionUsed;
    }
  }

  static bool useRandomTransitionIfAllowed() {
    final allowedTransitions = allowedTransitionsForCurrentState();
    if (allowedTransitions.any((x) => x.isButton)) {
      return false;
    }
    final allowedEmptyTransitions = allowedTransitions.where((x) => !x.isButton).toList();
    final randomTransition = selectRandomTransition(allowedEmptyTransitions);
    if (randomTransition != null) {
      progressState(useTransition: randomTransition.id);
      return true;
    } else {
      return false;
    }
  }

  static void progressState({String? useTransition, String? goToNode}) {
    //TODO: сейчас всё слишком сильно сломается, если во время выполнения метода _unsafeProgressState вылетит Exception. Для этого нужно добавить функционал транзакций
    //TODO: final checkpoint = GameState.createCheckpoint();
    try {
      _unsafeProgressState(
        useTransition: useTransition,
        goToNode: goToNode,
      );
    } catch (e, st) {
      logger.e("Progress state error", error: e, stackTrace: st);
      //TODO: GameState.rollbackTo(checkpoint);
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
  static void _unsafeProgressState({String? useTransition, String? goToNode}) {
    GameTransition? transition;
    if (useTransition != null) {
      transition = GameState.transitions.where((x) => x.id == useTransition).firstOrNull;
    }

    GameNode? node;
    if (goToNode != null) {
      node = GameState.nodes[goToNode];
    }
    
    int iterations = 0;
    int maxIterations = 1000;
    while (transition != null || node != null) {
      if (transition != null) {
        _runActions(transition.naturalLanguageAction);
        node = _checkTriggers() ?? GameState.nodes[transition.to];
        transition = null;
        GameState.currentNode = '';
      }
      if (node != null) {
        _runActions(node.naturalLanguageAction);
        GameState.currentNode = node.id;
        if (node.isEmptyNode) {
          final allowedTransitions = Player.allowedTransitionsForCurrentState();
          allowedTransitions.shuffle();
          allowedTransitions.sort((a, b) => a.order - b.order);
          if (allowedTransitions.every((x) => !x.isButton)){
            transition = selectRandomTransition(allowedTransitions);
          }
        }
        final triggeredNode = _checkTriggers();
        if (triggeredNode != null) {
          node = triggeredNode;
          transition = null;
        } else if (node.gotoLabel.isNotEmpty) {
          node = GameState.findNodeByLabel(node.gotoLabel);
          transition = null;
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

  static GameNode? _checkTriggers() {
    for (final node in GameState.nodes.values) {
      if (GameState.currentNode == node.id) {
        continue;
      }
      final naturalLanguageTrigger = node.naturalLanguageTrigger;
      if (naturalLanguageTrigger.isEmpty) {
        continue;
      }
      if (_calculateConditions(naturalLanguageTrigger, false)) {
        return node;
      }
    }
    return null;
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
      .where((t) => _calculateConditions(t.naturalLanguageCondition, true))
      .toList();
  }

  static bool _calculateConditions(String naturalLanguageCondition, bool valueIfNoCondition) {
    final emptyFunc = "function testConditions() { return $valueIfNoCondition; }";
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

  static String _calculateGetText(String js) {
    final emptyFunc = "function getText() { return \"\"; }";
    final result = GameState.jsRuntime.evaluate("$emptyFunc\n$js\ngetText();");
    if (result.isError) {
      logger.w("Javascript error:\n$js\n\n${result.rawResult}");
      return "JS_ERROR_2";
    }
    if (result.rawResult.runtimeType == String) {
      return result.rawResult;
    }
    if (result.rawResult.runtimeType == int) {
      return result.rawResult.toString();
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
          nt = nt.replaceAll(replaceable, _calculateGetText(jsCode));
        }
      }
    }
    speakerName.value = node.speaker;
    narrativeText.value = removeDoubleParenthesesBlocks(nt);

    buttons.value = allowedTransitionsForCurrentState()
        .where((t) => t.isButton)
        .map((t) => ChoiceButton(text: t.text, transitionId: t.id))
        .toList();
    
    if (node.imagePath.isNotEmpty) {
      var imageBytes = GameState.projectFiles?.readFile("images/${node.imagePath}");
      if (imageBytes != null) {
        backgroundImageNotifier.value = PlayerBackgroundImage(
          imageBytes: imageBytes
        );
      } else {
        backgroundImageNotifier.value = PlayerBackgroundImage(
          imageBytes: null
        );
      }
    }

    variablesDiffDebug.value = VariablesDiffDebug(
      previous: variablesDiffDebug.value.current,
      current: _collectVariablesForDebug(),
    );

    narrativeVersion.value++;
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
    backgroundImageNotifier.value = PlayerBackgroundImage();
    speakerName.value = "";
    narrativeText.value = "";
    buttons.value = [];
  }
}
