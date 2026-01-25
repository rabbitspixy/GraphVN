import 'package:dart_mappable/dart_mappable.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/editor_transition.dart';
import 'package:graph_vn/editor/variables.dart';

part 'project_data.mapper.dart';

@MappableClass()
class ProjectData with ProjectDataMappable {
  final Map<String, EditorNode> nodes;
  final List<EditorTransition> transitions;
  final List<Struct> structs;

  ProjectData({
    required this.nodes,
    required this.transitions,
    required this.structs,
  });
}