import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:uuid/uuid.dart';

class StructProcedure {
  String id = Uuid().v4();
  String name = "Unnamed procedure";
  List<BaseAction> actions = List.empty(growable: true);

  StructProcedure();

  void exec() {
    for (final action in actions) {
      action.exec();
    }
  }

  StructProcedureProto toProto() {
    final result = StructProcedureProto();
    result.id = id;
    result.name = name;
    result.actions.addAll(actions.map((x) => x.toProto()));
    return result;
  }

  factory StructProcedure.fromProto(StructProcedureProto proto) {
    final result = StructProcedure();
    result.id = proto.id;
    result.name = proto.name;
    result.actions = [ for (var a in proto.actions) BaseAction.fromProto(a) ];
    return result;
  }
}