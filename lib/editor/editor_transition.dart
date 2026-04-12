import 'package:flutter/services.dart';
import 'package:graph_vn/editor/named_value_expression/named_value_expression.dart';
import 'package:graph_vn/editor/transition_position.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:graph_vn/image_generation/generate_image_metadata.dart';
import 'package:uuid/uuid.dart';

class EditorTransition {
  String id = Uuid().v4();
  String text = "";
  String from = "";
  String to = "";
  //must be greater than 0
  int weight = 1;
  List<String> procedureIds = [];
  List<NamedValueExpression> conditions = [];
  List<GenerateImageMetadata> generateImageMetadata = [];

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
    result.procedureIds.addAll(procedureIds);
    result.conditions.addAll(conditions.map((x) => x.toProto()));
    result.generatedImages.addAll(generateImageMetadata.map((x) => x.toProto()));
    return result;
  }

  factory EditorTransition.fromProto(EditorTransitionProto proto) {
    final result = EditorTransition();
    result.id = proto.id;
    result.text = proto.text;
    result.from = proto.from;
    result.to = proto.to;
    result.weight = proto.weight;
    result.procedureIds.addAll(proto.procedureIds);
    result.conditions.addAll(proto.conditions.map((x) => NamedValueExpression.fromProto(x)));
    result.generateImageMetadata.addAll(proto.generatedImages.map((x) => GenerateImageMetadata.fromProto(x)));
    return result;
  }
}