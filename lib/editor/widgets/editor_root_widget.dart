import 'package:flutter/material.dart';
import 'package:graph_vn/editor/pages/ai_agent/editor_ai_agent_page.dart';
import 'package:graph_vn/editor/pages/graph/editor_graph_page.dart';
import 'package:graph_vn/editor/pages/project/editor_project_page.dart';
import 'package:graph_vn/editor/pages/settings/editor_settings_page.dart';
import 'package:graph_vn/editor/pages/variables/editor_variables_page.dart';

class EditorRootWidget extends StatefulWidget {
  const EditorRootWidget({super.key});

  @override
  State<EditorRootWidget> createState() => _EditorRootWidgetState();
}

class _EditorRootWidgetState extends State<EditorRootWidget> {
  EditorPage _page = EditorPage.graph;

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
        ExcludeFocus(
          child: Container(
            width: 50,
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildPageButton(EditorPage.project, Icons.folder_open),
                buildPageButton(EditorPage.graph, Icons.hub),
                buildPageButton(EditorPage.variables, Icons.data_object),
                buildPageButton(EditorPage.aiAgent, Icons.auto_awesome),
                buildPageButton(EditorPage.settings, Icons.settings),
              ],
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Visibility(
                visible: _page == EditorPage.project,
                maintainState: true,
                child: const EditorProjectPage(),
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
                visible: _page == EditorPage.aiAgent,
                maintainState: true,
                child: const EditorAiAgentPage(),
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
  aiAgent,
  settings,
}
