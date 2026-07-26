import 'package:flutter/material.dart';
import 'package:graph_vn/game/game_state.dart';

class EditorProjectPage extends StatelessWidget {
  const EditorProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Проект: ${GameState.projectDir}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: GameState.saveAndCloseProject,
            child: const Text("Save and close project"),
          ),
        ],
      ),
    );
  }
}