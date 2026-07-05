import 'package:flutter/services.dart' as game_transition;
import 'package:graph_vn/game/transition_position.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:graph_vn/image_generation/generate_image_metadata.dart';
import 'package:uuid/uuid.dart';

class GameTransition {
  String id = Uuid().v4();
  String text = "";
  String from = "";
  String to = "";
  //must be greater than 0
  int weight = 1;
  List<GenerateImageMetadata> generateImageMetadata = [];
  String naturalLanguageCondition = "";
  String naturalLanguageAction = "";

  bool get isButton => text.isNotEmpty;

  TransitionPosition pos = TransitionPosition(
    start: game_transition.Offset(0, 0),
    end: game_transition.Offset(0, 0),
    control: game_transition.Offset(0, 0),
    center: game_transition.Offset(0, 0),
    direction: 0,
  );

  GameTransition();

  GameTransitionProto toProto() {
    final result = GameTransitionProto();
    result.id = id;
    result.text = text;
    result.from = from;
    result.to = to;
    result.weight = weight;
    result.generatedImages.addAll(generateImageMetadata.map((x) => x.toProto()));
    result.naturalLanguageCondition = naturalLanguageCondition;
    result.naturalLanguageAction = naturalLanguageAction;
    return result;
  }

  factory GameTransition.fromProto(GameTransitionProto proto) {
    final result = GameTransition();
    result.id = proto.id;
    result.text = proto.text;
    result.from = proto.from;
    result.to = proto.to;
    result.weight = proto.weight;
    result.generateImageMetadata.addAll(proto.generatedImages.map((x) => GenerateImageMetadata.fromProto(x)));
    result.naturalLanguageCondition = proto.naturalLanguageCondition;
    result.naturalLanguageAction = proto.naturalLanguageAction;
    return result;
  }
}