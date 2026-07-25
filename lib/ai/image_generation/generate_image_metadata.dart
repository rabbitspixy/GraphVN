import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:uuid/uuid.dart';

class GenerateImageMetadata {
  String id = Uuid().v4();
  String style = "";
  String description = "";
  String llmGeneratedPrompt = "";

  GenerateImageMetadata();

  GenerateImageMetadataProto toProto() {
    final result = GenerateImageMetadataProto();
    result.id = id;
    result.style = style;
    result.description = description;
    result.llmGeneratedPrompt = llmGeneratedPrompt;
    return result;
  }

  factory GenerateImageMetadata.fromProto(GenerateImageMetadataProto proto) {
    final result = GenerateImageMetadata();
    result.id = proto.id;
    result.style = proto.style;
    result.description = proto.description;
    result.llmGeneratedPrompt = proto.llmGeneratedPrompt;
    return result;
  }
}