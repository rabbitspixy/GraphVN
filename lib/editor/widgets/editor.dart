import 'package:flutter/material.dart';
import 'package:graph_vn/editor/pages/graph/editor_graph_page.dart';
import 'package:graph_vn/editor/pages/settings/editor_settings_page.dart';
import 'package:graph_vn/editor/pages/variables/editor_variables_page.dart';

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
        Container(
          width: 50,
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                  style: TextButton.styleFrom(
                    backgroundColor: _page == EditorPage.graph ? Colors.black12 : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero
                    ),
                  ),
                  child: const Icon(Icons.hub),
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
                  style: TextButton.styleFrom(
                    backgroundColor: _page == EditorPage.variables ? Colors.black12 : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero
                    ),
                  ),
                  child: const Icon(Icons.data_object),
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
                  style: TextButton.styleFrom(
                    backgroundColor: _page == EditorPage.settings ? Colors.black12 : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero
                    ),
                  ),
                  child: const Icon(Icons.settings),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Visibility(
                visible: _page == EditorPage.graph,
                maintainState: true,
                child: const EditorGraphPage(),
              ),
              Visibility(
                visible: _page == EditorPage.variables,
                maintainState: true,
                child: const EditorVariablesPage(),
              ),
              Visibility(
                visible: _page == EditorPage.settings,
                maintainState: true,
                child: const EditorSettingsPage(),
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
