import 'package:flutter/material.dart';
import 'package:graph_vn/app_constants.dart';
import 'package:graph_vn/editor/modals/status_dialog.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/main.dart';

class EditorProjectPage extends StatelessWidget {
  const EditorProjectPage({super.key});

  void _saveAsZip(BuildContext context) {
    final files = GameState.projectFiles;
    final dir = GameState.projectDir;
    if (files == null || dir == null) return;
    GameState.save();
    final filesToSave = List<String>.empty(growable: true);
    filesToSave.add("main.bin");
    filesToSave.addAll(
        GameState.nodes.values
            .map((x) => x.imagePath)
            .where((x) => x.isNotEmpty)
            .map((x) => "images/$x")
            .where((x) => files.exists(x))
            .toList()
    );
    final zipPath = "${AppConstants.gamesDir}/$dir.zip";
    files.saveAsZip(filesToSave, zipPath);
    showStatusDialog(context, "Сохранено в $zipPath", StatusDialogType.done);
  }

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
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _saveAsZip(context),
            child: const Text("Экспорт в zip"),
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