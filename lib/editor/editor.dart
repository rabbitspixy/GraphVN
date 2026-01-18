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
    return Row(
      children: [
        Expanded(
          child: Stack(
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
          ),
        ),
        Container(
          width: 50,
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _page = EditorPage.graph;
                    });
                  },
                  child: const Text('📊', style: TextStyle(fontSize: 24)),
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _page = EditorPage.variables;
                    });
                  },
                  child: const Text('🧪', style: TextStyle(fontSize: 24)),
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _page = EditorPage.settings;
                    });
                  },
                  child: const Text('⚙️', style: TextStyle(fontSize: 24)),
                ),
              ),
            ],
          ),
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
