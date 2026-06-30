import 'package:graph_vn/game/game_node.dart';
import 'package:graph_vn/game/game_transition.dart';
import 'package:graph_vn/game/struct.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';

class ProjectData {
  final Map<String, GameNode> nodes;
  final List<GameTransition> transitions;
  final List<Struct> structs;

  ProjectData({
    required this.nodes,
    required this.transitions,
    required this.structs,
  });

  ProjectProto toProto() {
    final result = ProjectProto();
    result.nodes.addAll(nodes.values.map((x) => x.toProto()));
    result.transitions.addAll(transitions.map((x) => x.toProto()));
    result.structs.addAll(structs.map((x) => x.toProto()));
    return result;
  }

  factory ProjectData.fromProto(ProjectProto proto) {


    return ProjectData(
        nodes: { for (var node in proto.nodes) node.id: GameNode.fromProto(node) },
        transitions: [ for (var t in proto.transitions) GameTransition.fromProto(t) ],
        structs: [ for (var s in proto.structs) Struct.fromProto(s) ],
    );
  }
}