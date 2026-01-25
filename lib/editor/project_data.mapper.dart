// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'project_data.dart';

class ProjectDataMapper extends ClassMapperBase<ProjectData> {
  ProjectDataMapper._();

  static ProjectDataMapper? _instance;
  static ProjectDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProjectDataMapper._());
      EditorNodeMapper.ensureInitialized();
      EditorTransitionMapper.ensureInitialized();
      StructMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ProjectData';

  static Map<String, EditorNode> _$nodes(ProjectData v) => v.nodes;
  static const Field<ProjectData, Map<String, EditorNode>> _f$nodes = Field(
    'nodes',
    _$nodes,
  );
  static List<EditorTransition> _$transitions(ProjectData v) => v.transitions;
  static const Field<ProjectData, List<EditorTransition>> _f$transitions =
      Field('transitions', _$transitions);
  static List<Struct> _$structs(ProjectData v) => v.structs;
  static const Field<ProjectData, List<Struct>> _f$structs = Field(
    'structs',
    _$structs,
  );

  @override
  final MappableFields<ProjectData> fields = const {
    #nodes: _f$nodes,
    #transitions: _f$transitions,
    #structs: _f$structs,
  };

  static ProjectData _instantiate(DecodingData data) {
    return ProjectData(
      nodes: data.dec(_f$nodes),
      transitions: data.dec(_f$transitions),
      structs: data.dec(_f$structs),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProjectData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProjectData>(map);
  }

  static ProjectData fromJson(String json) {
    return ensureInitialized().decodeJson<ProjectData>(json);
  }
}

mixin ProjectDataMappable {
  String toJson() {
    return ProjectDataMapper.ensureInitialized().encodeJson<ProjectData>(
      this as ProjectData,
    );
  }

  Map<String, dynamic> toMap() {
    return ProjectDataMapper.ensureInitialized().encodeMap<ProjectData>(
      this as ProjectData,
    );
  }

  ProjectDataCopyWith<ProjectData, ProjectData, ProjectData> get copyWith =>
      _ProjectDataCopyWithImpl<ProjectData, ProjectData>(
        this as ProjectData,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ProjectDataMapper.ensureInitialized().stringifyValue(
      this as ProjectData,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProjectDataMapper.ensureInitialized().equalsValue(
      this as ProjectData,
      other,
    );
  }

  @override
  int get hashCode {
    return ProjectDataMapper.ensureInitialized().hashValue(this as ProjectData);
  }
}

extension ProjectDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProjectData, $Out> {
  ProjectDataCopyWith<$R, ProjectData, $Out> get $asProjectData =>
      $base.as((v, t, t2) => _ProjectDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProjectDataCopyWith<$R, $In extends ProjectData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<
    $R,
    String,
    EditorNode,
    EditorNodeCopyWith<$R, EditorNode, EditorNode>
  >
  get nodes;
  ListCopyWith<
    $R,
    EditorTransition,
    EditorTransitionCopyWith<$R, EditorTransition, EditorTransition>
  >
  get transitions;
  ListCopyWith<$R, Struct, StructCopyWith<$R, Struct, Struct>> get structs;
  $R call({
    Map<String, EditorNode>? nodes,
    List<EditorTransition>? transitions,
    List<Struct>? structs,
  });
  ProjectDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ProjectDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProjectData, $Out>
    implements ProjectDataCopyWith<$R, ProjectData, $Out> {
  _ProjectDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProjectData> $mapper =
      ProjectDataMapper.ensureInitialized();
  @override
  MapCopyWith<
    $R,
    String,
    EditorNode,
    EditorNodeCopyWith<$R, EditorNode, EditorNode>
  >
  get nodes => MapCopyWith(
    $value.nodes,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(nodes: v),
  );
  @override
  ListCopyWith<
    $R,
    EditorTransition,
    EditorTransitionCopyWith<$R, EditorTransition, EditorTransition>
  >
  get transitions => ListCopyWith(
    $value.transitions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(transitions: v),
  );
  @override
  ListCopyWith<$R, Struct, StructCopyWith<$R, Struct, Struct>> get structs =>
      ListCopyWith(
        $value.structs,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(structs: v),
      );
  @override
  $R call({
    Map<String, EditorNode>? nodes,
    List<EditorTransition>? transitions,
    List<Struct>? structs,
  }) => $apply(
    FieldCopyWithData({
      if (nodes != null) #nodes: nodes,
      if (transitions != null) #transitions: transitions,
      if (structs != null) #structs: structs,
    }),
  );
  @override
  ProjectData $make(CopyWithData data) => ProjectData(
    nodes: data.get(#nodes, or: $value.nodes),
    transitions: data.get(#transitions, or: $value.transitions),
    structs: data.get(#structs, or: $value.structs),
  );

  @override
  ProjectDataCopyWith<$R2, ProjectData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ProjectDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

