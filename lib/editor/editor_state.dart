

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:graph_vn/editor/editor_constants.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/editor_transition.dart';
import 'package:graph_vn/editor/struct.dart';
import 'dart:ui';

import 'package:xml/xml.dart';

class EditorState {
  static final Map<String, EditorNode> nodes = <String, EditorNode>{};
  static final List<EditorTransition> transitions = List.empty(growable: true);
  static final ValueNotifier<List<EditorTransition>> transitionsNotifier = ValueNotifier<List<EditorTransition>>([]);
  static EditorNode? selectedNode;
  static EditorTransition? selectedTransition;
  static final List<Struct> structs = List.empty();
  static Offset? storedOffset;

  static String projectDirName = "test";

  static void load() {
    nodes.clear();
    transitions.clear();
    transitionsNotifier.value = [];
    selectedNode = null;
    selectedTransition = null;
    storedOffset = null;

    final file = File("./${EditorConstants.projectsDir}/$projectDirName/main.xml");
    if (!file.existsSync()) {
      return;
    }
    final document = XmlDocument.parse(file.readAsStringSync());
    final root = document.getElement('project');
    if (root == null) throw Exception("No project node");
    nodes.addEntries(
      root.findAllElements('node')
        .map((n) => EditorNode()..loadFromXml(n))
        .map((n) => MapEntry(n.id, n))
    );
    transitions.addAll(
      root.findAllElements('transition')
        .map((t) => EditorTransition()..loadFromXml(t))
    );
  }

  static Future<void> save() async {
    print("saving project...");
    final builder = XmlBuilder();
    builder.element('project', nest: () {
      for (final node in nodes.values) {
        node.writeToXml(builder);
      }
      for (final transition in transitions) {
        transition.writeToXml(builder);
      }
    });
    final document = builder.buildDocument();
    final file = File("./${EditorConstants.projectsDir}/$projectDirName/main.xml");
    final dir = file.parent;
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    await file.writeAsString(document.toXmlString(pretty: true));
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
  
}
