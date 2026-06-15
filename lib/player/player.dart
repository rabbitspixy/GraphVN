import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:graph_vn/common/random_util.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/editor_transition.dart';
import 'package:graph_vn/player/components.dart';
import 'package:graph_vn/editor/editor_state.dart';

class Player {
  static final ValueNotifier<PlayerImageInfo> imageInfoNotifier = ValueNotifier<PlayerImageInfo>(PlayerImageInfo(path: ''));
  static final ValueNotifier<String> speakerName = ValueNotifier<String>('');
  static final ValueNotifier<String> narrativeText = ValueNotifier<String>('');
  static final ValueNotifier<String> statusText = ValueNotifier('');
  static final ValueNotifier<List<ChoiseButton>> buttons = ValueNotifier<List<ChoiseButton>>([]);

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
      updateState(useTransition: randomTransition.id);
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
  /// The method updates the global [EditorState.currentNode] and
  /// triggers a UI update via [_updateStill].
  static void updateState({String? useTransition, String? goToNode}) {
    EditorTransition? transition;
    if (useTransition != null) {
      transition = EditorState.transitions.where((x) => x.id == useTransition).firstOrNull;
    }

    EditorNode? node;
    if (goToNode != null) {
      node = EditorState.nodes[goToNode];
    }
    
    int iterations = 0;
    int maxIterations = 10000;
    while (transition != null || node != null) {
      if (transition != null) {
        _runActions(transition.jsAction);
        node = EditorState.nodes[transition.to];
        transition = null;
      }
      if (node != null) {
        _runActions(node.jsAction);
        EditorState.currentNode = node.id;
        if (node.isEmpty) {
          final allowedTransitions = Player.allowedTransitionsForCurrentState();
          if (allowedTransitions.every((x) => !x.isButton)){
            transition = selectRandomTransition(allowedTransitions);
          }
        }
        node = null;
      }

      iterations++;
      if (iterations == maxIterations) {
        throw Exception('reached max iterations count');
      }
    }

    _updateStill();
  }

  static void _runActions(String jsAction) {

  }

  static List<EditorTransition> allowedTransitionsForCurrentState() {
    return EditorState.transitions
      .where((t) => t.from == EditorState.currentNode)
      .where((t) => _resolveTransitionConditions(t.jsCondition))
      .toList();
  }

  static bool _resolveTransitionConditions(String jsCondition) {
    return true;
  }

  static void _updateStill() {
    buttons.value.clear();
    if (EditorState.currentNode == "") {
      final initResult = initStartGame();
      if (!initResult) {
        return;
      }
    }
    final node = EditorState.nodes[EditorState.currentNode];
    if (node == null) {
      return;
    }
    String nt = node.text;
    for (final struct in EditorState.structs) {
      for (final variable in struct.variables) {
        nt = nt.replaceAll("[${struct.name}->${variable.name}]", variable.currentValueAsText());
      }
    }
    speakerName.value = node.speaker;
    narrativeText.value = nt;

    final st = StringBuffer();
    for (final struct in EditorState.structs) {
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
      final file = File("projects/${EditorState.projectDir}/images/${node.imagePath}");
      if (file.existsSync()) {
        imageInfoNotifier.value = PlayerImageInfo(
          path: file.path,
        );
      }
    }
  }

  static bool initStartGame() {
    EditorState.restart();
    final startNode = EditorState.nodes.values.where((node) => node.isStart).firstOrNull;
    if (startNode != null) {
      updateState(goToNode: startNode.id);
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
