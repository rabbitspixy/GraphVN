import 'package:flutter/services.dart';
import 'package:graph_vn/editor/transition_position.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:graph_vn/image_generation/generate_image_metadata.dart';
import 'package:uuid/uuid.dart';

import 'actions/base.dart';
import 'first_match_condition_item.dart';

class EditorTransition {
  String id = Uuid().v4();
  String text = "";
  String from = "";
  String to = "";
  //must be greater than 0
  int weight = 1;
  List<FirstMatchConditionItem> conditions = [];
  List<GenerateImageMetadata> generateImageMetadata = [];
  List<BaseAction> actions = [];

  bool get isButton => text.isNotEmpty;

  TransitionPosition pos = TransitionPosition(
    start: Offset(0, 0),
    end: Offset(0, 0),
    control: Offset(0, 0),
    center: Offset(0, 0),
    direction: 0,
  );

  EditorTransition();

  EditorTransitionProto toProto() {
    final result = EditorTransitionProto();
    result.id = id;
    result.text = text;
    result.from = from;
    result.to = to;
    result.weight = weight;
    // result.conditions.addAll(conditions.map((x) => x.toProto()));
    result.generatedImages.addAll(generateImageMetadata.map((x) => x.toProto()));
    result.actions.addAll(actions.map((x) => x.toProto()));
    return result;
  }

  factory EditorTransition.fromProto(EditorTransitionProto proto) {
    final result = EditorTransition();
    result.id = proto.id;
    result.text = proto.text;
    result.from = proto.from;
    result.to = proto.to;
    result.weight = proto.weight;
    // result.conditions.addAll(proto.conditions.map((x) => NamedValueExpression.fromProto(x)));
    result.generateImageMetadata.addAll(proto.generatedImages.map((x) => GenerateImageMetadata.fromProto(x)));
    result.actions.addAll(proto.actions.map((x) => BaseAction.fromProto(x)));
    return result;
  }
}