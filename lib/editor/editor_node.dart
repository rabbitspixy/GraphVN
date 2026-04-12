import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:uuid/uuid.dart';
import 'package:fixnum/fixnum.dart';

class EditorNode {
  String id = Uuid().v4();
  String text = '';
  String label = '';
  int x = 0;
  int y = 0;
  bool isStart = false;
  List<String> procedureIds = [];
  String imagePath = "";

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
    result.procedureIds.addAll(procedureIds);
    result.imagePath = imagePath;
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
    result.procedureIds.addAll(proto.procedureIds);
    result.imagePath = proto.imagePath;
    return result;
  }
}
