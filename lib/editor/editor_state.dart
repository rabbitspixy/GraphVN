import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:graph_vn/editor/editor_constants.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/editor_transition.dart';
import 'package:graph_vn/editor/project_data.dart';
import 'package:graph_vn/editor/transition_position.dart';
import 'package:graph_vn/editor/variables.dart';
import 'dart:ui';

import 'package:graph_vn/main.dart';

class EditorState {
  static String projectDirName = "";

  static final Map<String, EditorNode> nodes = <String, EditorNode>{};
  static final List<EditorTransition> transitions = List.empty(growable: true);
  static EditorNode? selectedNode;
  static EditorTransition? selectedTransition;
  static final List<Struct> structs = List.empty(growable: true);
  static Offset? storedOffset;
  static String currentNode = "";
  
  static final _stateUpdatedEventsController = StreamController<String>();
  static final stateUpdatedEvents = _stateUpdatedEventsController.stream;

  static void load(String projectDir) {
    projectDirName = "";
    nodes.clear();
    transitions.clear();
    selectedNode = null;
    selectedTransition = null;
    structs.clear();
    storedOffset = null;
    currentNode = "";

    final file = File("./${EditorConstants.projectsDir}/$projectDir/main.json");
    if (!file.existsSync()) {
      projectDirName = projectDir;
      return;
    }
    final projectData = ProjectDataMapper.fromJson(file.readAsStringSync());
    nodes.addAll(projectData.nodes);
    transitions.addAll(projectData.transitions);
    structs.addAll(projectData.structs);

    projectDirName = projectDir;
    updateAllTransitionPositions();
    _stateUpdatedEventsController.add('');
  }

  static Future<void> save() async {
    logger.i('start saving project');

    final projectData = ProjectData(
      nodes: EditorState.nodes,
      transitions:  EditorState.transitions,
      structs: EditorState.structs,
    );
    final file = File("./${EditorConstants.projectsDir}/$projectDirName/main.json");
    final dir = file.parent;
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    final json = const JsonEncoder.withIndent('  ').convert(projectData.toMap());
    ProjectDataMapper.fromJson(json); //deserialize check
    await file.writeAsString(json);
    logger.i('saving project done');
  }

  static void restart() {
    logger.i('restart game');
    currentNode = "";
    for (final struct in structs) {
      for (final variable in struct.variables) {
        variable.reset();
      }
    }
  }

  static void addTransition(EditorTransition transition) {
    transitions.add(transition);
    updateAllTransitionPositions();
    _stateUpdatedEventsController.add('');
  }

  static void deleteTransition(String id) {
    if (EditorState.selectedTransition?.id == id) {
      EditorState.selectedTransition = null;
    }
    final idx = EditorState.transitions.indexWhere((t) => t.id == id);
    if (idx != -1) {
      EditorState.transitions.removeAt(idx);
    }
    _stateUpdatedEventsController.add('');
  }

  static void addNode(EditorNode node) {
    EditorState.nodes[node.id] = node;
    _stateUpdatedEventsController.add('');
  }

  static void deleteNode(String id) {
    if (EditorState.selectedNode?.id == id) {
      EditorState.selectedNode = null;
    }
    final node = EditorState.nodes[id];
    if (node != null) {
      EditorState.nodes.remove(node.id);
      EditorState.transitions.removeWhere((t) => t.from == node.id || t.to == node.id);
    }
    _stateUpdatedEventsController.add('');
  }

  static bool hasNodeInPosition(int x, int y) {
    return nodes.values.where((n) => n.x == x && n.y == y).firstOrNull != null;
  }

  static bool trySetNodePositionById(String nodeId, int x, int y) {
    final node = EditorState.nodes[nodeId];
    if (node != null) {
      return trySetNodePosition(node, x, y);
    }
    return false;
  }
  
  static bool trySetNodePosition(EditorNode node, int x, int y) {
    final newX = (x.toDouble() / 25).round() * 25;
    final newY = (y.toDouble() / 25).round() * 25;
    if (!hasNodeInPosition(newX, newY)) {
      node.x = newX;
      node.y = newY;
      updateAllTransitionPositions();
      _stateUpdatedEventsController.add('');
      return true;
    }
    return false;
  }

  static Struct? structById(String id) {
    return structs.where((s) => s.id == id).firstOrNull;
  }

  static Struct? structByVariableId(String variableId) {
    return EditorState.structs.where((s) => s.variables.any((v) => v.id == variableId)).firstOrNull;
  }

  static Struct? structByProcedureId(String procedureId) {
    return EditorState.structs.where((s) => s.procedures.any((x) => x.id == procedureId)).firstOrNull;
  }
  
  static Variable? variableById(String variableId) {
    return EditorState.structByVariableId(variableId)?.variableById(variableId);
  }

  static StructProcedure? procedureById(String procedureId) {
    return EditorState.structByProcedureId(procedureId)?.procedureById(procedureId);
  }

  static String variableName(String variableId) {
    final struct = EditorState.structByVariableId(variableId);
    if (struct == null) {
      return "variable";
    }
    final variable = struct.variableById(variableId);
    if (variable == null) {
      return "variable";
    }
    return "${struct.name}->${variable.name}";
  }

  static NamedValue? namedValue(String typeId, String valueId) {
    return namedVariableTypes.where((type) => type.id == typeId).firstOrNull?.list.where((v) => v.id == valueId).firstOrNull;
  }

  static void updateAllTransitionPositions() {
    final Map<String, int> precalculatedPairCount = {};
    for (final transition in EditorState.transitions) {
      final key = '${transition.from}->${transition.to}';
      precalculatedPairCount.update(key, (v) => v + 1, ifAbsent: () => 1);
    }

    final Map<String, int> pairCount = {};

    for (final transition in EditorState.transitions) {
      final fromNode = EditorState.nodes[transition.from];
      final toNode = EditorState.nodes[transition.to];
      if (fromNode == null || toNode == null) continue;

      final start = Offset(
        fromNode.x.toDouble(),
        fromNode.y.toDouble(),
      );
      
      final end = Offset(
        toNode.x.toDouble(),
        toNode.y.toDouble(),
      );

      final key = '${transition.from}->${transition.to}';
      final index = pairCount.update(key, (v) => v + 1, ifAbsent: () => 1);
      final totalTransitionsCount = precalculatedPairCount[key] ?? 0;

      final oppositeKey = '${transition.to}->${transition.from}';
      final hasOppositeDirectionTransitions = precalculatedPairCount.containsKey(oppositeKey);

      double t;
      if (hasOppositeDirectionTransitions) {
        t = index.toDouble();
      } else {
        t = index.toDouble() - (totalTransitionsCount + 1).toDouble() / 2.0;
      }

      final mid = Offset(
        (start.dx + end.dx) / 2,
        (start.dy + end.dy) / 2,
      );
      final Offset d = end - start;
      final Offset perp = Offset(-d.dy, d.dx);
      final double perpLength = perp.distance;
      final double magnitude = EditorConstants.transitionDeviationMagnitude * t;
      final Offset unitPerp = perpLength == 0 ? Offset.zero : Offset(perp.dx / perpLength, perp.dy / perpLength);
      final Offset control = mid + unitPerp * magnitude;

      final center = Offset(
        0.25 * start.dx + 0.5 * control.dx + 0.25 * end.dx,
        0.25 * start.dy + 0.5 * control.dy + 0.25 * end.dy,
      );

      transition.pos = TransitionPosition(
        start: start,
        end: end,
        control: control,
        center: center,
        direction: d.direction,
      );
    }
  }
  
}
