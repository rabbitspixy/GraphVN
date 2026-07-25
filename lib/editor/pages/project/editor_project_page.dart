import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graph_vn/game/game_state.dart';

class EditorProjectPage extends StatefulWidget {
  const EditorProjectPage({super.key});

  @override
  State<EditorProjectPage> createState() => _EditorProjectPageState();
}

class _EditorProjectPageState extends State<EditorProjectPage> {
  final TextEditingController _controller = TextEditingController();
  StreamSubscription<String>? _subscription;

  @override
  void initState() {
    super.initState();
    _controller.text = GameState.aiImageStyle;
    _subscription = GameState.stateUpdatedEvents.listen((_) {
      if (_controller.text != GameState.aiImageStyle) {
        _controller.text = GameState.aiImageStyle;
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'AI Image Style',
              hintText: 'e.g. anime, realistic, pixel art, ...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onChanged: (value) {
              GameState.aiImageStyle = value;
            },
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