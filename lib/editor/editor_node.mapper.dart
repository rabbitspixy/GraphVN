// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'editor_node.dart';

class EditorNodeMapper extends ClassMapperBase<EditorNode> {
  EditorNodeMapper._();

  static EditorNodeMapper? _instance;
  static EditorNodeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EditorNodeMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'EditorNode';

  static String _$id(EditorNode v) => v.id;
  static const Field<EditorNode, String> _f$id = Field('id', _$id);
  static String _$text(EditorNode v) => v.text;
  static const Field<EditorNode, String> _f$text = Field('text', _$text);
  static String _$label(EditorNode v) => v.label;
  static const Field<EditorNode, String> _f$label = Field('label', _$label);
  static int _$x(EditorNode v) => v.x;
  static const Field<EditorNode, int> _f$x = Field('x', _$x);
  static int _$y(EditorNode v) => v.y;
  static const Field<EditorNode, int> _f$y = Field('y', _$y);
  static bool _$isStart(EditorNode v) => v.isStart;
  static const Field<EditorNode, bool> _f$isStart = Field('isStart', _$isStart);

  @override
  final MappableFields<EditorNode> fields = const {
    #id: _f$id,
    #text: _f$text,
    #label: _f$label,
    #x: _f$x,
    #y: _f$y,
    #isStart: _f$isStart,
  };

  static EditorNode _instantiate(DecodingData data) {
    return EditorNode.mappableConstructor(
      id: data.dec(_f$id),
      text: data.dec(_f$text),
      label: data.dec(_f$label),
      x: data.dec(_f$x),
      y: data.dec(_f$y),
      isStart: data.dec(_f$isStart),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EditorNode fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EditorNode>(map);
  }

  static EditorNode fromJson(String json) {
    return ensureInitialized().decodeJson<EditorNode>(json);
  }
}

mixin EditorNodeMappable {
  String toJson() {
    return EditorNodeMapper.ensureInitialized().encodeJson<EditorNode>(
      this as EditorNode,
    );
  }

  Map<String, dynamic> toMap() {
    return EditorNodeMapper.ensureInitialized().encodeMap<EditorNode>(
      this as EditorNode,
    );
  }

  EditorNodeCopyWith<EditorNode, EditorNode, EditorNode> get copyWith =>
      _EditorNodeCopyWithImpl<EditorNode, EditorNode>(
        this as EditorNode,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EditorNodeMapper.ensureInitialized().stringifyValue(
      this as EditorNode,
    );
  }

  @override
  bool operator ==(Object other) {
    return EditorNodeMapper.ensureInitialized().equalsValue(
      this as EditorNode,
      other,
    );
  }

  @override
  int get hashCode {
    return EditorNodeMapper.ensureInitialized().hashValue(this as EditorNode);
  }
}

extension EditorNodeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EditorNode, $Out> {
  EditorNodeCopyWith<$R, EditorNode, $Out> get $asEditorNode =>
      $base.as((v, t, t2) => _EditorNodeCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EditorNodeCopyWith<$R, $In extends EditorNode, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? text,
    String? label,
    int? x,
    int? y,
    bool? isStart,
  });
  EditorNodeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _EditorNodeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EditorNode, $Out>
    implements EditorNodeCopyWith<$R, EditorNode, $Out> {
  _EditorNodeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EditorNode> $mapper =
      EditorNodeMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? text,
    String? label,
    int? x,
    int? y,
    bool? isStart,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (text != null) #text: text,
      if (label != null) #label: label,
      if (x != null) #x: x,
      if (y != null) #y: y,
      if (isStart != null) #isStart: isStart,
    }),
  );
  @override
  EditorNode $make(CopyWithData data) => EditorNode.mappableConstructor(
    id: data.get(#id, or: $value.id),
    text: data.get(#text, or: $value.text),
    label: data.get(#label, or: $value.label),
    x: data.get(#x, or: $value.x),
    y: data.get(#y, or: $value.y),
    isStart: data.get(#isStart, or: $value.isStart),
  );

  @override
  EditorNodeCopyWith<$R2, EditorNode, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EditorNodeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

