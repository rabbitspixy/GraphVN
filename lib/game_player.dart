import 'package:flutter/material.dart';
import 'package:touch_of_the_unknown/components.dart';
import 'background_image.dart';
import 'transition_buttons.dart';
import 'engine.dart';

class GamePlayer extends StatelessWidget {
  const GamePlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImageWidget(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ValueListenableBuilder<List<Transition>>(
              valueListenable: transitions,
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
              valueListenable: narrativeText,
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
    );
  }
}
