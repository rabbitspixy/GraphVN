import 'package:touch_of_the_unknown/components.dart';
import 'package:touch_of_the_unknown/humanoid.dart';

class GameState {
  static Node currentNode = Node(
    imageInfo: () => NodeImageInfo(path: ''),
    text: () => '',
    transitions: [],
  );

  static double progress = 0.0;
  static Humanoid? humanoid;
}