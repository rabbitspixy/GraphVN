import 'package:touch_of_the_unknown/components.dart';
import 'package:touch_of_the_unknown/game_logic/game_state.dart';
import 'package:touch_of_the_unknown/game_logic/girl.dart';
import 'package:touch_of_the_unknown/humanoid.dart';

final Node startNode = Node(
  imageInfo: () {
    return NodeImageInfo();
  },
  text: () { 
    return '';
  },
  transitions: [
    Transition(
      text: () {
        return 'Мяу';
      },
      nextNode: () => node1,
      onTransition: () {
        GameState.progress = 0.0;
        GameState.humanoid = ann;
      }
    )
  ],
);