import 'package:flutter/material.dart';
import 'package:graph_vn/player/components.dart';
import 'background_image.dart';
import 'transition_buttons.dart';
import '../player.dart';
import 'animated_narrative_text.dart';

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
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: ValueListenableBuilder<List<ChoiseButton>>(
                valueListenable: Player.buttons,
                builder: (context, transitionList, child) {
                  return TransitionButtons(transitions: transitionList);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: Player.speakerName,
                    builder: (context, name, child) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 200),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: AnimatedNarrativeText(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
