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
  static int _$weight(EditorTransition v) => v.weight;
  static const Field<EditorTransition, int> _f$weight = Field(
    'weight',
    _$weight,
    opt: true,
    def: 1,
  );
  static List<String> _$procedureIds(EditorTransition v) => v.procedureIds;
  static const Field<EditorTransition, List<String>> _f$procedureIds = Field(
    'procedureIds',
    _$procedureIds,
    opt: true,
  );
  static TransitionPosition _$pos(EditorTransition v) => v.pos;
  static const Field<EditorTransition, TransitionPosition> _f$pos = Field(
    'pos',
    _$pos,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<EditorTransition> fields = const {
    #id: _f$id,
    #text: _f$text,
    #from: _f$from,
    #to: _f$to,
    #weight: _f$weight,
    #procedureIds: _f$procedureIds,
    #pos: _f$pos,
  };

  static EditorTransition _instantiate(DecodingData data) {
    return EditorTransition.mappableConstructor(
      id: data.dec(_f$id),
      text: data.dec(_f$text),
      from: data.dec(_f$from),
      to: data.dec(_f$to),
      weight: data.dec(_f$weight),
      procedureIds: data.dec(_f$procedureIds),
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
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get procedureIds;
  $R call({
    String? id,
    String? text,
    String? from,
    String? to,
    int? weight,
    List<String>? procedureIds,
  });
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
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get procedureIds => ListCopyWith(
    $value.procedureIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(procedureIds: v),
  );
  @override
  $R call({
    String? id,
    String? text,
    String? from,
    String? to,
    int? weight,
    Object? procedureIds = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (text != null) #text: text,
      if (from != null) #from: from,
      if (to != null) #to: to,
      if (weight != null) #weight: weight,
      if (procedureIds != $none) #procedureIds: procedureIds,
    }),
  );
  @override
  EditorTransition $make(CopyWithData data) =>
      EditorTransition.mappableConstructor(
        id: data.get(#id, or: $value.id),
        text: data.get(#text, or: $value.text),
        from: data.get(#from, or: $value.from),
        to: data.get(#to, or: $value.to),
        weight: data.get(#weight, or: $value.weight),
        procedureIds: data.get(#procedureIds, or: $value.procedureIds),
      );

  @override
  EditorTransitionCopyWith<$R2, EditorTransition, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EditorTransitionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

