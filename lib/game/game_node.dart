import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:graph_vn/image_generation/generate_image_metadata.dart';
import 'package:uuid/uuid.dart';
import 'package:fixnum/fixnum.dart';

class GameNode {
  String id = Uuid().v4();
  String text = '';
  String label = '';
  int x = 0;
  int y = 0;
  bool isStart = false;
  String imagePath = "";
  List<GenerateImageMetadata> generateImageMetadata = [];
  String speaker = "";
  String naturalLanguageTrigger = "";
  String naturalLanguageAction = "";
  String gotoLabel = "";

  bool get isTrigger => naturalLanguageTrigger.isNotEmpty;
  bool get isEmptyNode => text.isEmpty;

  GameNode();

  GameNodeProto toProto() {
    final result = GameNodeProto();
    result.id = id;
    result.text = text;
    result.label = label;
    result.x = Int64(x);
    result.y = Int64(y);
    result.isStart = isStart;
    result.imagePath = imagePath;
    result.generatedImages.addAll(generateImageMetadata.map((x) => x.toProto()));
    result.speaker = speaker;
    result.naturalLanguageTrigger = naturalLanguageTrigger;
    result.naturalLanguageAction = naturalLanguageAction;
    result.gotoLabel = gotoLabel;
    return result;
  }

  factory GameNode.fromProto(GameNodeProto proto) {
    final result = GameNode();
    result.id = proto.id;
    result.text = proto.text;
    result.label = proto.label;
    result.x = proto.x.toInt();
    result.y = proto.y.toInt();
    result.isStart = proto.isStart;
    result.imagePath = proto.imagePath;
    result.generateImageMetadata.addAll(proto.generatedImages.map((x) => GenerateImageMetadata.fromProto(x)));
    result.speaker = proto.speaker;
    result.naturalLanguageTrigger = proto.naturalLanguageTrigger;
    result.naturalLanguageAction = proto.naturalLanguageAction;
    result.gotoLabel = proto.gotoLabel;
    return result;
  }
}
