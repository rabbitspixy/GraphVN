import 'package:flutter/material.dart';
import 'package:graph_vn/player/components.dart';
import 'background_image.dart';
import 'transition_buttons.dart';
import '../player.dart';

class GamePlayer extends StatelessWidget {
  const GamePlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Player.useRandomTransitionIfAllowed,
      child: Stack(
        children: [
          const BackgroundImageWidget(),
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
              child: ValueListenableBuilder<String>(
                valueListenable: Player.narrativeText,
                builder: (context, text, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(120, 0, 0, 0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
