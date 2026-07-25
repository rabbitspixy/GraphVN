import 'package:flutter/material.dart';
import 'package:graph_vn/player/player.dart';
import 'animated_narrative_text.dart';

class SpeakerNarrativeBlock extends StatelessWidget {
  final VoidCallback? onTextFinished;
  const SpeakerNarrativeBlock({super.key, this.onTextFinished});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Player.speakerName,
      builder: (context, name, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 200),
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 4.0),
            AnimatedNarrativeText(onTextFinished: onTextFinished),
          ],
        );
      },
    );
  }
}
