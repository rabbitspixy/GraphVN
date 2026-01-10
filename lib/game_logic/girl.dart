import 'package:touch_of_the_unknown/components.dart';
import 'package:touch_of_the_unknown/game_logic/game_state.dart';

final Node node1 = Node(
  imageInfo: () {
    return NodeImageInfo(path: 'assets/images/${GameState.humanoid!.id}/f/1.png');
  },
  text: () { 
    return 'Начнём?';
  },
  transitions: [
    Transition(
      text: () {
        return 'ЫЫЫЫ';
      },
      nextNode: () => node2
    )
  ],
  onEnter: () {
    GameState.progress = 0.0;
  },
);

final Node node2 = Node(
  imageInfo: () {
    return NodeImageInfo(path: 'assets/images/${GameState.humanoid!.id}/f/1.png');
  },
  text: () { 
    return 'Мяу мяу';
  },
  transitions: [],
  onEnter: () {
    GameState.progress = 0.0;
  },
);