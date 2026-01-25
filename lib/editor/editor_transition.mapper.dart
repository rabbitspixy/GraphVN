// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'editor_transition.dart';

class EditorTransitionMapper extends ClassMapperBase<EditorTransition> {
  EditorTransitionMapper._();

  static EditorTransitionMapper? _instance;
  static EditorTransitionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EditorTransitionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'EditorTransition';

  static String _$id(EditorTransition v) => v.id;
  static const Field<EditorTransition, String> _f$id = Field('id', _$id);
  static String _$text(EditorTransition v) => v.text;
  static const Field<EditorTransition, String> _f$text = Field('text', _$text);
  static String _$from(EditorTransition v) => v.from;
  static const Field<EditorTransition, String> _f$from = Field('from', _$from);
  static String _$to(EditorTransition v) => v.to;
  static const Field<EditorTransition, String> _f$to = Field('to', _$to);

  @override
  final MappableFields<EditorTransition> fields = const {
    #id: _f$id,
    #text: _f$text,
    #from: _f$from,
    #to: _f$to,
  };

  static EditorTransition _instantiate(DecodingData data) {
    return EditorTransition.mappableConstructor(
      id: data.dec(_f$id),
      text: data.dec(_f$text),
      from: data.dec(_f$from),
      to: data.dec(_f$to),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EditorTransition fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EditorTransition>(map);
  }

  static EditorTransition fromJson(String json) {
    return ensureInitialized().decodeJson<EditorTransition>(json);
  }
}

mixin EditorTransitionMappable {
  String toJson() {
    return EditorTransitionMapper.ensureInitialized()
        .encodeJson<EditorTransition>(this as EditorTransition);
  }

  Map<String, dynamic> toMap() {
    return EditorTransitionMapper.ensureInitialized()
        .encodeMap<EditorTransition>(this as EditorTransition);
  }

  EditorTransitionCopyWith<EditorTransition, EditorTransition, EditorTransition>
  get copyWith =>
      _EditorTransitionCopyWithImpl<EditorTransition, EditorTransition>(
        this as EditorTransition,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EditorTransitionMapper.ensureInitialized().stringifyValue(
      this as EditorTransition,
    );
  }

  @override
  bool operator ==(Object other) {
    return EditorTransitionMapper.ensureInitialized().equalsValue(
      this as EditorTransition,
      other,
    );
  }

  @override
  int get hashCode {
    return EditorTransitionMapper.ensureInitialized().hashValue(
      this as EditorTransition,
    );
  }
}

extension EditorTransitionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EditorTransition, $Out> {
  EditorTransitionCopyWith<$R, EditorTransition, $Out>
  get $asEditorTransition =>
      $base.as((v, t, t2) => _EditorTransitionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EditorTransitionCopyWith<$R, $In extends EditorTransition, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? text, String? from, String? to});
  EditorTransitionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EditorTransitionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EditorTransition, $Out>
    implements EditorTransitionCopyWith<$R, EditorTransition, $Out> {
  _EditorTransitionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EditorTransition> $mapper =
      EditorTransitionMapper.ensureInitialized();
  @override
  $R call({String? id, String? text, String? from, String? to}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (text != null) #text: text,
      if (from != null) #from: from,
      if (to != null) #to: to,
    }),
  );
  @override
  EditorTransition $make(CopyWithData data) =>
      EditorTransition.mappableConstructor(
        id: data.get(#id, or: $value.id),
        text: data.get(#text, or: $value.text),
        from: data.get(#from, or: $value.from),
        to: data.get(#to, or: $value.to),
      );

  @override
  EditorTransitionCopyWith<$R2, EditorTransition, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EditorTransitionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

