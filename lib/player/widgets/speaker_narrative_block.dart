import 'package:flutter/material.dart';
import 'package:graph_vn/player/components.dart';
import 'package:graph_vn/player/player.dart';
import 'animated_narrative_text.dart';

class SpeakerNarrativeBlock extends StatelessWidget {
  const SpeakerNarrativeBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Player.speakerName,
      builder: (context, name, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                name,
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 200),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 4.0),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: AnimatedNarrativeText(),
            ),
          ],
        );
      },
    );
  }
}
