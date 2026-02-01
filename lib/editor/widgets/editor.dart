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
  EditorPage _page = EditorPage.project;

  Widget buildPageButton(EditorPage page, IconData iconData) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextButton(
        onPressed: () {
          setState(() {
            _page = page;
          });
        },
        style: TextButton.styleFrom(
          backgroundColor: _page == page ? Colors.black12 : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero
          ),
        ),
        child: Icon(iconData),
      ),
    );
  }

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
              buildPageButton(EditorPage.project, Icons.folder_open),
              buildPageButton(EditorPage.graph, Icons.hub),
              buildPageButton(EditorPage.variables, Icons.data_object),
              buildPageButton(EditorPage.settings, Icons.settings),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Visibility(
                visible: _page == EditorPage.project,
                maintainState: true,
                child: const Placeholder(),
              ),
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
  project,
  graph,
  variables,
  settings,
}
