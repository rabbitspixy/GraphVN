import 'package:graph_vn/generated-proto/data.pb.dart';

class CodeRepository {
  final Map<String, String> actions = {};
  final Map<String, String> conditions = {};
  final Map<String, String> replaceables = {};


  CodeRepository();

  void clear() {
    actions.clear();
    conditions.clear();
    replaceables.clear();
  }

  CodeRepositoryProto toProto() {
    final result = CodeRepositoryProto();
    result.actions.addAll(actions);
    result.conditions.addAll(conditions);
    result.replaceables.addAll(replaceables);
    return result;
  }

  factory CodeRepository.fromProto(CodeRepositoryProto proto) {
    final result = CodeRepository();
    result.actions.addAll(proto.actions);
    result.conditions.addAll(proto.conditions);
    result.replaceables.addAll(proto.replaceables);
    return result;
  }
}