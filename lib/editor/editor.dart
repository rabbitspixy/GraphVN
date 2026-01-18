import 'package:flutter/material.dart';
import 'package:graph_vn/editor/editor_graph.dart';
import 'package:graph_vn/editor/editor_settings.dart';
import 'package:graph_vn/editor/editor_variables.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  EditorPage _page = EditorPage.graph;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: _page == EditorPage.graph,
          maintainState: true,
          child: const EditorGraph(),
        ),
        Visibility(
          visible: _page == EditorPage.variables,
          maintainState: true,
          child: const EditorVariables(),
        ),
        Visibility(
          visible: _page == EditorPage.settings,
          maintainState: true,
          child: const EditorSettings(),
        ),
      ],
    );
  }
}


enum EditorPage {
  graph,
  variables,
  settings,
}