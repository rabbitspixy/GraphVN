import 'package:flutter/material.dart';
import 'package:graph_vn/game/game_state.dart';

class EditorProjectPage extends StatefulWidget {
  const EditorProjectPage({super.key});

  @override
  State<EditorProjectPage> createState() => _EditorProjectPageState();
}

class _EditorProjectPageState extends State<EditorProjectPage> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: GameState.saveAndCloseProject,
      child: const Text("Save and close project")
    );
  }
}