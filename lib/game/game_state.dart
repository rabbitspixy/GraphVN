import 'dart:async';
import 'dart:io';

import 'package:flutter_js/flutter_js.dart';
import 'package:graph_vn/common/js_util.dart';
import 'package:graph_vn/game/code_repository.dart';
import 'package:graph_vn/game/named_value_type_repository.dart';
import 'package:graph_vn/game/project_files.dart';
import 'package:graph_vn/game/struct.dart';
import 'package:graph_vn/game/transition_position.dart';
import 'package:graph_vn/player/player.dart';
import 'package:graph_vn/settings/app_settings.dart';
import 'package:graph_vn/app_constants.dart';
import 'package:graph_vn/app_version.dart';
import 'package:graph_vn/game/game_node.dart';
import 'package:graph_vn/game/game_transition.dart';
import 'package:graph_vn/game/project_data.dart';
import 'package:graph_vn/game/variables.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:graph_vn/main.dart';

class GameState {
  static ValueNotifier<bool> showEditor = ValueNotifier<bool>(true);
  static String? projectDir;
  static ProjectFiles? projectFiles;

  static final Map<String, GameNode> nodes = <String, GameNode>{};
  static final List<GameTransition> transitions = List.empty(growable: true);
  static GameNode? selectedNode;
  static GameTransition? selectedTransition;
  static final List<Struct> structs = List.empty(growable: true);
  static NamedValueTypeRepository namedValueTypes = NamedValueTypeRepository();
  static String currentNode = "";
  static CodeRepository codeRepository = CodeRepository();
  static String aiImageStyle = '';
  static String gameDescriptionForAI = '';
  static JavascriptRuntime jsRuntime = getJavascriptRuntime();

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

  static List<String> getGameFiles() {
    final dir = Directory("./${AppConstants.gamesDir}");
    if (!dir.existsSync()) {
      return [];
    }
    return dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.zip'))
        .map((f) => f.path)
        .toList();
  }

  static void loadGameForPlaying(String zipPath) {
    logger.i('load game from zip: $zipPath');
    _loadGameForPlaying(zipPath);
  }
  
  static final _stateUpdatedEventsController = StreamController<String>.broadcast();
  static final stateUpdatedEvents = _stateUpdatedEventsController.stream;

  static void closeProject() {
    showEditor.value = false;
    GameState.projectDir = "";
    projectFiles = null;
    nodes.clear();
    transitions.clear();
    selectedNode = null;
    selectedTransition = null;
    structs.clear();
    codeRepository = CodeRepository();
    aiImageStyle = '';
    gameDescriptionForAI = '';
    namedValueTypes = NamedValueTypeRepository();
    restart();

    if (appSettings.lastOpenedProjectDir != GameState.projectDir) {
      appSettings = appSettings.copyWith(lastOpenedProjectDir: GameState.projectDir);
    }

    _stateUpdatedEventsController.add('');
  }

  static void loadProjectForEditing(String projectDir) async {
    logger.i("loading project $projectDir");
    closeProject();

    try {
      await _loadProjectForEditing(projectDir);
    } catch (e, st) {
      logger.e("Error loading project $projectDir", error: e, stackTrace: st);
      closeProject();
      appSettings = appSettings.copyWith(lastOpenedProjectDir: null);
    }
    logger.i("project $projectDir loaded");
  }

  static Future<void> _loadProjectForEditing(String dir) async {
    final files = await ProjectFiles.create("${AppConstants.projectsDir}/$dir");
    _loadGameState(files);

    GameState.projectDir = dir;
    GameState.projectFiles = files;
    showEditor.value = true;
    _stateUpdatedEventsController.add('');
    if (appSettings.lastOpenedProjectDir != GameState.projectDir) {
      appSettings = appSettings.copyWith(lastOpenedProjectDir: GameState.projectDir);
    }
  }

  static Future<void> _loadGameForPlaying(String zipPath) async {
    final files = await ProjectFiles.create(zipPath);
    _loadGameState(files);

    GameState.projectDir = null;
    GameState.projectFiles = files;
    showEditor.value = false;
    _stateUpdatedEventsController.add('');
    appSettings = appSettings.copyWith(lastOpenedProjectDir: null);
    Player.progressState();
  }

  static void _loadGameState(ProjectFiles files) {
    final mainBin = files.readFile("main.bin");
    if (mainBin == null) {
      return;
    }
    ProjectProto proto = ProjectProto.fromBuffer(mainBin);
    ProjectData projectData = ProjectData.fromProto(proto);
    AppVersion.checkIsSupportedVersion(projectData.appVersion);

    nodes.addAll(projectData.nodes);
    transitions.addAll(projectData.transitions);
    structs.addAll(projectData.structs);
    codeRepository = projectData.codeRepository;
    aiImageStyle = projectData.aiImageStyle;
    gameDescriptionForAI = projectData.gameDescriptionForAI;
    namedValueTypes = NamedValueTypeRepository();
    namedValueTypes.addAll(projectData.namedValueTypes);
    updateAllTransitionPositions();
  }

  static void loadLastSavedProject() {
    final proj = appSettings.lastOpenedProjectDir;
    if (proj == null || proj.isEmpty) {
      return;
    }
    loadProjectForEditing(proj);
  }

  static void createAndLoadNewProject(String projectDir) {
    final dir = Directory("./${AppConstants.projectsDir}/$projectDir");
    if (dir.existsSync()) {
      throw Exception('Project directory already exists: $projectDir');
    }
    dir.createSync(recursive: true);
    loadProjectForEditing(projectDir);
  }

  static void save() {
    if (!isProjectLoaded()) {
      return;
    }
    if (projectFiles?.isReadOnly() == true) {
      return;
    }
    logger.i('start saving project');

    final projectData = ProjectData(
      nodes: GameState.nodes,
      transitions:  GameState.transitions,
      structs: GameState.structs,
      codeRepository: codeRepository,
      namedValueTypes: namedValueTypes.all(),
      aiImageStyle: aiImageStyle,
      gameDescriptionForAI: gameDescriptionForAI,
      appVersion: AppVersion.current.toString(),
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
    jsRuntime.dispose();
    jsRuntime = getJavascriptRuntime();
    jsRuntime.evaluate("let variables = {}");
    for (final struct in structs) {
      for (final variable in struct.variables) {
        jsRuntime.evaluate("variables[${toJsString("${struct.name}->${variable.name}")}] = ${variable.initialValueAsJsCode()}");
      }
    }
  }

  static String valueOfVariable(Variable variable) {
    final struct = structByVariableId(variable.id);
    if (struct == null) return "JS_ERROR_1";
    final result = jsRuntime.evaluate("variables[${toJsString("${struct.name}->${variable.name}")}];");
    return result.stringResult;
  }

  static bool isProjectLoaded() {
    return projectFiles != null;
  }

  static bool isEditorEnabled() {
    return projectFiles?.isReadOnly() != true;
  }

  static void addTransition(GameTransition transition) {
    transitions.add(transition);
    updateAllTransitionPositions();
    _stateUpdatedEventsController.add('');
  }
  
  static List<GameTransition> findTransitions({String? from, String? to}) {
    return transitions.where((t) {
      if (from != null && t.from != from) return false;
      if (to != null && t.to != to) return false;
      return true;
    }).toList();
  }

  static void deleteTransition(String id) {
    if (GameState.selectedTransition?.id == id) {
      GameState.selectedTransition = null;
    }
    final idx = GameState.transitions.indexWhere((t) => t.id == id);
    if (idx != -1) {
      GameState.transitions.removeAt(idx);
    }
    _stateUpdatedEventsController.add('');
  }

  static void addNode(GameNode node) {
    GameState.nodes[node.id] = node;
    _stateUpdatedEventsController.add('');
  }

  static void deleteNode(String id) {
    if (GameState.selectedNode?.id == id) {
      GameState.selectedNode = null;
    }
    final node = GameState.nodes[id];
    if (node != null) {
      GameState.nodes.remove(node.id);
      GameState.transitions.removeWhere((t) => t.from == node.id || t.to == node.id);
    }
    _stateUpdatedEventsController.add('');
  }

  static bool hasNodeInPosition(int x, int y) {
    return nodes.values.where((n) => n.x == x && n.y == y).firstOrNull != null;
  }

  static bool trySetNodePositionById(String nodeId, int x, int y) {
    final node = GameState.nodes[nodeId];
    if (node != null) {
      return trySetNodePosition(node, x, y);
    }
    return false;
  }
  
  static bool trySetNodePosition(GameNode node, int x, int y) {
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
    return GameState.structs.where((s) => s.variables.any((v) => v.id == variableId)).firstOrNull;
  }
  
  static Variable? variableById(String variableId) {
    return GameState.structByVariableId(variableId)?.variableById(variableId);
  }

  static String variableName(String variableId) {
    final struct = GameState.structByVariableId(variableId);
    if (struct == null) {
      return "variable";
    }
    final variable = struct.variableById(variableId);
    if (variable == null) {
      return "variable";
    }
    return "${struct.name} - ${variable.name}";
  }

  static GameNode? findNodeById(String id) {
    return nodes.values.where((x) => x.id == id).firstOrNull;
  }

  static GameNode? findNodeByLabel(String label) {
    return nodes.values.where((x) => x.label == label).firstOrNull;
  }

  static void renameVariable(String id, String newName) {
    var variable = variableById(id);
    if (variable == null) {
      return;
    }
    var struct = structByVariableId(id);
    if (struct == null) {
      return;
    }
    var oldJsName = toJsString("${struct.name}->${variable.name}");
    variable.name = newName;
    var newJsName = toJsString("${struct.name}->${variable.name}");
    codeRepository.replaceInCode(oldJsName, newJsName);
    jsRuntime.evaluate("variables[$newJsName] = variables[$oldJsName]; delete variables[$oldJsName];");
  }

  static void renameStruct(String id, String newName) {
    var struct = structById(id);
    if (struct == null) {
      return;
    }
    var oldStructName = struct.name;
    struct.name = newName;
    for (final variable in struct.variables) {
      var oldJsName = toJsString("$oldStructName->${variable.name}");
      var newJsName = toJsString("${struct.name}->${variable.name}");
      codeRepository.replaceInCode(oldJsName, newJsName);
      jsRuntime.evaluate("variables[$newJsName] = variables[$oldJsName]; delete variables[$oldJsName];");
    }
  }

  static void toggleEditorMode() {
    if (!isEditorEnabled()) {
      showEditor.value = false;
    }
    GameState.showEditor.value = !GameState.showEditor.value;
  }

  static void updateAllTransitionPositions() {
    final Map<String, int> precalculatedPairCount = {};
    for (final transition in GameState.transitions) {
      final key = '${transition.from}->${transition.to}';
      precalculatedPairCount.update(key, (v) => v + 1, ifAbsent: () => 1);
    }

    final Map<String, int> pairCount = {};

    for (final transition in GameState.transitions) {
      final fromNode = GameState.nodes[transition.from];
      final toNode = GameState.nodes[transition.to];
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
