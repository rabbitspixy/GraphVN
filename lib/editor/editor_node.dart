import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:graph_vn/image_generation/generate_image_metadata.dart';
import 'package:uuid/uuid.dart';
import 'package:fixnum/fixnum.dart';

class EditorNode {
  String id = Uuid().v4();
  String text = '';
  String label = '';
  int x = 0;
  int y = 0;
  bool isStart = false;
  String imagePath = "";
  List<GenerateImageMetadata> generateImageMetadata = [];
  List<BaseAction> actions = [];
  String speaker = "";

  bool get isEmpty => text.isEmpty;

  EditorNode();

  EditorNodeProto toProto() {
    final result = EditorNodeProto();
    result.id = id;
    result.text = text;
    result.label = label;
    result.x = Int64(x);
    result.y = Int64(y);
    result.isStart = isStart;
    result.imagePath = imagePath;
    result.generatedImages.addAll(generateImageMetadata.map((x) => x.toProto()));
    result.actions.addAll(actions.map((x) => x.toProto()));
    result.speaker = speaker;
    return result;
  }

  factory EditorNode.fromProto(EditorNodeProto proto) {
    final result = EditorNode();
    result.id = proto.id;
    result.text = proto.text;
    result.label = proto.label;
    result.x = proto.x.toInt();
    result.y = proto.y.toInt();
    result.isStart = proto.isStart;
    result.imagePath = proto.imagePath;
    result.generateImageMetadata.addAll(proto.generatedImages.map((x) => GenerateImageMetadata.fromProto(x)));
    result.actions.addAll(proto.actions.map((x) => BaseAction.fromProto(x)));
    result.speaker = proto.speaker;
    return result;
  }
}
