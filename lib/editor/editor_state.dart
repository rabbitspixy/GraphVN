import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:graph_vn/editor/editor_constants.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/editor_transition.dart';
import 'package:graph_vn/editor/project_data.dart';
import 'package:graph_vn/editor/variables.dart';
import 'dart:ui';

class EditorState {
  static String projectDirName = "";

  static final Map<String, EditorNode> nodes = <String, EditorNode>{};
  static final List<EditorTransition> transitions = List.empty(growable: true);
  static final ValueNotifier<List<EditorTransition>> transitionsNotifier = ValueNotifier<List<EditorTransition>>([]);
  static EditorNode? selectedNode;
  static EditorTransition? selectedTransition;
  static final List<Struct> structs = List.empty(growable: true);
  static Offset? storedOffset;
  static String currentNode = "";

  static void load(String projectDir) {
    projectDirName = "";
    nodes.clear();
    transitions.clear();
    transitionsNotifier.value = [];
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
  }

  static Future<void> save() async {
    print("saving project...");

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
  }

  static void deleteTransition(String id) {
    if (EditorState.selectedTransition?.id == id) {
      EditorState.selectedTransition = null;
    }
    final idx = EditorState.transitions.indexWhere((t) => t.id == id);
    if (idx != -1) {
      EditorState.transitions.removeAt(idx);
      EditorState.transitionsNotifier.value = List.from(EditorState.transitions);
    }
  }

  static void deleteNode(String id) {
    if (EditorState.selectedNode?.id == id) {
      EditorState.selectedNode = null;
    }
    final node = EditorState.nodes[id];
    if (node != null) {
      EditorState.nodes.remove(node.id);
      EditorState.transitions.removeWhere((t) => t.from == node.id || t.to == node.id);
      EditorState.transitionsNotifier.value = List.from(EditorState.transitions);
    }
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

  static String variableAsString(String variableId) {
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
  
}
