import 'package:graph_vn/game/variables.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:uuid/uuid.dart';

class Struct {
  String id = Uuid().v4();
  String name = "";
  List<Variable> variables = List.empty(growable: true);

  Struct();

  Variable? variableById(String id) {
    return variables.where((v) => v.id == id).firstOrNull;
  }

  StructProto toProto() {
    final result = StructProto();
    result.id = id;
    result.name = name;
    result.variables.addAll(variables.map((x) => x.toProto()));
    return result;
  }

  factory Struct.fromProto(StructProto proto) {
    final result = Struct();
    result.id = proto.id;
    result.name = proto.name;
    result.variables.addAll(proto.variables.map((x) => Variable.fromProto(x)));
    return result;
  }
}