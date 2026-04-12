import 'package:graph_vn/editor/struct_procedure.dart';
import 'package:graph_vn/editor/variables.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:uuid/uuid.dart';

class Struct {
  String id = Uuid().v4();
  String name = "";
  List<Variable> variables = List.empty(growable: true);
  List<StructProcedure> procedures = List.empty(growable: true);

  Struct();

  Variable? variableById(String id) {
    return variables.where((v) => v.id == id).firstOrNull;
  }

  StructProcedure? procedureById(String id) {
    return procedures.where((x) => x.id == id).firstOrNull;
  }

  StructProto toProto() {
    final result = StructProto();
    result.id = id;
    result.name = name;
    result.variables.addAll(variables.map((x) => x.toProto()));
    result.procedures.addAll(procedures.map((x) => x.toProto()));
    return result;
  }

  factory Struct.fromProto(StructProto proto) {
    final result = Struct();
    result.id = proto.id;
    result.name = proto.name;
    result.variables.addAll(proto.variables.map((x) => Variable.fromProto(x)));
    result.procedures.addAll(proto.procedures.map((x) => StructProcedure.fromProto(x)));
    return result;
  }
}