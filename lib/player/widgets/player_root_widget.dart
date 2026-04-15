import 'package:flutter/material.dart';
import 'package:graph_vn/player/components.dart';
import 'background_image.dart';
import 'transition_buttons.dart';
import '../player.dart';
import 'speaker_narrative_block.dart';

class PlayerRootWidget extends StatelessWidget {
  const PlayerRootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Player.useRandomTransitionIfAllowed,
      child: Stack(
        children: [
          const BackgroundImageWidget(),
          Align(
            alignment: Alignment.centerLeft,
            child: ValueListenableBuilder<String>(
              valueListenable: Player.statusText,
              builder: (context, text, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(120, 0, 0, 0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.left,
                    softWrap: true,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 80.0),
            child: ValueListenableBuilder<List<ChoiseButton>>(
              valueListenable: Player.buttons,
              builder: (context, transitionList, child) {
                return TransitionButtons(transitions: transitionList);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: const SpeakerNarrativeBlock(),
            ),
          ),
        ],
      ),
    );
  }
}
