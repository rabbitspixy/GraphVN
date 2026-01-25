// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'rotate_named_value.dart';

class RotateNamedValueMapper extends SubClassMapperBase<RotateNamedValue> {
  RotateNamedValueMapper._();

  static RotateNamedValueMapper? _instance;
  static RotateNamedValueMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RotateNamedValueMapper._());
      BaseActionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'RotateNamedValue';

  static String _$id(RotateNamedValue v) => v.id;
  static const Field<RotateNamedValue, String> _f$id = Field('id', _$id);
  static String _$variableId(RotateNamedValue v) => v.variableId;
  static const Field<RotateNamedValue, String> _f$variableId = Field(
    'variableId',
    _$variableId,
  );

  @override
  final MappableFields<RotateNamedValue> fields = const {
    #id: _f$id,
    #variableId: _f$variableId,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'RotateNamedValue';
  @override
  late final ClassMapperBase superMapper = BaseActionMapper.ensureInitialized();

  static RotateNamedValue _instantiate(DecodingData data) {
    return RotateNamedValue.mappableConstructor(
      id: data.dec(_f$id),
      variableId: data.dec(_f$variableId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RotateNamedValue fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RotateNamedValue>(map);
  }

  static RotateNamedValue fromJson(String json) {
    return ensureInitialized().decodeJson<RotateNamedValue>(json);
  }
}

mixin RotateNamedValueMappable {
  String toJson() {
    return RotateNamedValueMapper.ensureInitialized()
        .encodeJson<RotateNamedValue>(this as RotateNamedValue);
  }

  Map<String, dynamic> toMap() {
    return RotateNamedValueMapper.ensureInitialized()
        .encodeMap<RotateNamedValue>(this as RotateNamedValue);
  }

  RotateNamedValueCopyWith<RotateNamedValue, RotateNamedValue, RotateNamedValue>
  get copyWith =>
      _RotateNamedValueCopyWithImpl<RotateNamedValue, RotateNamedValue>(
        this as RotateNamedValue,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RotateNamedValueMapper.ensureInitialized().stringifyValue(
      this as RotateNamedValue,
    );
  }

  @override
  bool operator ==(Object other) {
    return RotateNamedValueMapper.ensureInitialized().equalsValue(
      this as RotateNamedValue,
      other,
    );
  }

  @override
  int get hashCode {
    return RotateNamedValueMapper.ensureInitialized().hashValue(
      this as RotateNamedValue,
    );
  }
}

extension RotateNamedValueValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RotateNamedValue, $Out> {
  RotateNamedValueCopyWith<$R, RotateNamedValue, $Out>
  get $asRotateNamedValue =>
      $base.as((v, t, t2) => _RotateNamedValueCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RotateNamedValueCopyWith<$R, $In extends RotateNamedValue, $Out>
    implements BaseActionCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? variableId});
  RotateNamedValueCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RotateNamedValueCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RotateNamedValue, $Out>
    implements RotateNamedValueCopyWith<$R, RotateNamedValue, $Out> {
  _RotateNamedValueCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RotateNamedValue> $mapper =
      RotateNamedValueMapper.ensureInitialized();
  @override
  $R call({String? id, String? variableId}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (variableId != null) #variableId: variableId,
    }),
  );
  @override
  RotateNamedValue $make(CopyWithData data) =>
      RotateNamedValue.mappableConstructor(
        id: data.get(#id, or: $value.id),
        variableId: data.get(#variableId, or: $value.variableId),
      );

  @override
  RotateNamedValueCopyWith<$R2, RotateNamedValue, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RotateNamedValueCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

