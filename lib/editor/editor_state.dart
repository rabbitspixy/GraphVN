import 'dart:async';
import 'dart:io';

import 'package:graph_vn/editor/struct.dart';
import 'package:graph_vn/settings/app_settings.dart';
import 'package:graph_vn/app_constants.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/editor_transition.dart';
import 'package:graph_vn/editor/project_data.dart';
import 'package:graph_vn/editor/transition_position.dart';
import 'package:graph_vn/editor/variables.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'dart:ui';

import 'package:graph_vn/main.dart';

class EditorState {
  static String projectDir = "";

  static final Map<String, EditorNode> nodes = <String, EditorNode>{};
  static final List<EditorTransition> transitions = List.empty(growable: true);
  static EditorNode? selectedNode;
  static EditorTransition? selectedTransition;
  static final List<Struct> structs = List.empty(growable: true);
  static Offset? storedOffset;
  static String currentNode = "";

  static List<String> getProjectFolders() {
    final dir = Directory("./${AppConstants.projectsDir}");
    if (!dir.existsSync()) {
      return [];
    }
    return dir
        .listSync()
        .whereType<Directory>()
        .map((d) => d.path.split(Platform.pathSeparator).last)
        .toList();
  }
  
  static final _stateUpdatedEventsController = StreamController<String>.broadcast();
  static final stateUpdatedEvents = _stateUpdatedEventsController.stream;

  static void closeProject() {
    EditorState.projectDir = "";
    nodes.clear();
    transitions.clear();
    selectedNode = null;
    selectedTransition = null;
    structs.clear();
    storedOffset = null;
    currentNode = "";

    if (appSettings.lastOpenedProjectDir != EditorState.projectDir) {
      appSettings = appSettings.copyWith(lastOpenedProjectDir: EditorState.projectDir);
    }

    _stateUpdatedEventsController.add('');
  }

  static void load(String projectDir) {
    logger.i("loading project $projectDir");
    _load(projectDir);
    logger.i("project $projectDir loaded");
  }

  static void _load(String projectDir) {
    closeProject();

    final file = File("./${AppConstants.projectsDir}/$projectDir/main.bin");
    if (!file.existsSync()) {
      EditorState.projectDir = projectDir;
      _stateUpdatedEventsController.add('');
      return;
    }
    ProjectProto proto;
    try {
      proto = ProjectProto.fromBuffer(file.readAsBytesSync());
    } catch (e) {
      logger.e("Error loading project $projectDir", error: e);
      return;
    }
    ProjectData projectData;
    try {
      projectData = ProjectData.fromProto(proto);
    } catch (e) {
      logger.e("Error loading project $projectDir", error: e);
      _stateUpdatedEventsController.add('');
      return;
    }
    nodes.addAll(projectData.nodes);
    transitions.addAll(projectData.transitions);
    structs.addAll(projectData.structs);
    updateAllTransitionPositions();

    //this should be done last
    EditorState.projectDir = projectDir;
    _stateUpdatedEventsController.add('');
    if (appSettings.lastOpenedProjectDir != EditorState.projectDir) {
      appSettings = appSettings.copyWith(lastOpenedProjectDir: EditorState.projectDir);
    }
  }

  static void loadLastSavedProject() {
    final proj = appSettings.lastOpenedProjectDir;
    if (proj == null) {
      return;
    }
    load(proj);
  }

  static void createAndLoadNewProject(String projectDir) {
    final dir = Directory("./${AppConstants.projectsDir}/$projectDir");
    if (dir.existsSync()) {
      throw Exception('Project directory already exists: $projectDir');
    }
    dir.createSync(recursive: true);
    load(projectDir);
  }

  static void save() {
    if (!isProjectLoaded()) {
      return;
    }
    logger.i('start saving project');

    final projectData = ProjectData(
      nodes: EditorState.nodes,
      transitions:  EditorState.transitions,
      structs: EditorState.structs,
    );
    final file = File("./${AppConstants.projectsDir}/$projectDir/main.bin");
    final dir = file.parent;
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    var projectDataProto = projectData.toProto();
    file.writeAsBytesSync(projectDataProto.writeToBuffer());
    logger.i('saving project done');
  }

  static void saveAndCloseProject() {
    save();
    closeProject();
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

  static bool isProjectLoaded() {
    return projectDir.isNotEmpty;
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
  
  static Variable? variableById(String variableId) {
    return EditorState.structByVariableId(variableId)?.variableById(variableId);
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
    return "${struct.name} - ${variable.name}";
  }

  static NamedValue? namedValue(String valueId) {
    return namedVariableTypes.expand((t) => t.list).where((v) => v.id == valueId).firstOrNull;
  }

  static NamedValuesType? namedValuesType(String typeId) {
    return namedVariableTypes.where((t) => t.id == typeId).firstOrNull;
  }

  static NamedValuesType? namedValueTypeByValueId(String valueId) {
    return namedVariableTypes.where((t) => t.list.where((v) => v.id == valueId).isNotEmpty).firstOrNull;
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
      final double magnitude = AppConstants.transitionDeviationMagnitude * t;
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
