import 'package:flutter/material.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/editor/modals/rename_dialog.dart';

class ProjectSelector extends StatefulWidget {
  const ProjectSelector({super.key});

  @override
  State<ProjectSelector> createState() => _ProjectSelectorState();
}

class _ProjectSelectorState extends State<ProjectSelector> {
  List<String> _projects = [];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  void _loadProjects() {
    _projects = GameState.getProjectFolders();
  }

  Future<void> _createNewProject() async {
    final name = await showRenameDialog(context, 'New Project', '');
    if (name != null && name.isNotEmpty) {
      GameState.createAndLoadNewProject(name);
      setState(() {
        _loadProjects();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._projects.map((p) => ElevatedButton(
              onPressed: () => GameState.load(p),
              child: Text(p),
            )),
        ElevatedButton(
          onPressed: _createNewProject,
          child: const Text('Create New Project'),
        ),
      ],
    );
  }
}
