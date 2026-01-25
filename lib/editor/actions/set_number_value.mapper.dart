// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'set_number_value.dart';

class SetNumberValueMapper extends SubClassMapperBase<SetNumberValue> {
  SetNumberValueMapper._();

  static SetNumberValueMapper? _instance;
  static SetNumberValueMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SetNumberValueMapper._());
      BaseActionMapper.ensureInitialized().addSubMapper(_instance!);
      NumberExpressionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SetNumberValue';

  static String _$id(SetNumberValue v) => v.id;
  static const Field<SetNumberValue, String> _f$id = Field('id', _$id);
  static String _$variableId(SetNumberValue v) => v.variableId;
  static const Field<SetNumberValue, String> _f$variableId = Field(
    'variableId',
    _$variableId,
  );
  static NumberExpression _$numberExpression(SetNumberValue v) =>
      v.numberExpression;
  static const Field<SetNumberValue, NumberExpression> _f$numberExpression =
      Field('numberExpression', _$numberExpression);

  @override
  final MappableFields<SetNumberValue> fields = const {
    #id: _f$id,
    #variableId: _f$variableId,
    #numberExpression: _f$numberExpression,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'SetNumberValue';
  @override
  late final ClassMapperBase superMapper = BaseActionMapper.ensureInitialized();

  static SetNumberValue _instantiate(DecodingData data) {
    return SetNumberValue.mappableConstructor(
      id: data.dec(_f$id),
      variableId: data.dec(_f$variableId),
      numberExpression: data.dec(_f$numberExpression),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SetNumberValue fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SetNumberValue>(map);
  }

  static SetNumberValue fromJson(String json) {
    return ensureInitialized().decodeJson<SetNumberValue>(json);
  }
}

mixin SetNumberValueMappable {
  String toJson() {
    return SetNumberValueMapper.ensureInitialized().encodeJson<SetNumberValue>(
      this as SetNumberValue,
    );
  }

  Map<String, dynamic> toMap() {
    return SetNumberValueMapper.ensureInitialized().encodeMap<SetNumberValue>(
      this as SetNumberValue,
    );
  }

  SetNumberValueCopyWith<SetNumberValue, SetNumberValue, SetNumberValue>
  get copyWith => _SetNumberValueCopyWithImpl<SetNumberValue, SetNumberValue>(
    this as SetNumberValue,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SetNumberValueMapper.ensureInitialized().stringifyValue(
      this as SetNumberValue,
    );
  }

  @override
  bool operator ==(Object other) {
    return SetNumberValueMapper.ensureInitialized().equalsValue(
      this as SetNumberValue,
      other,
    );
  }

  @override
  int get hashCode {
    return SetNumberValueMapper.ensureInitialized().hashValue(
      this as SetNumberValue,
    );
  }
}

extension SetNumberValueValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SetNumberValue, $Out> {
  SetNumberValueCopyWith<$R, SetNumberValue, $Out> get $asSetNumberValue =>
      $base.as((v, t, t2) => _SetNumberValueCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SetNumberValueCopyWith<$R, $In extends SetNumberValue, $Out>
    implements BaseActionCopyWith<$R, $In, $Out> {
  NumberExpressionCopyWith<$R, NumberExpression, NumberExpression>
  get numberExpression;
  @override
  $R call({String? id, String? variableId, NumberExpression? numberExpression});
  SetNumberValueCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SetNumberValueCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SetNumberValue, $Out>
    implements SetNumberValueCopyWith<$R, SetNumberValue, $Out> {
  _SetNumberValueCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SetNumberValue> $mapper =
      SetNumberValueMapper.ensureInitialized();
  @override
  NumberExpressionCopyWith<$R, NumberExpression, NumberExpression>
  get numberExpression =>
      $value.numberExpression.copyWith.$chain((v) => call(numberExpression: v));
  @override
  $R call({
    String? id,
    String? variableId,
    NumberExpression? numberExpression,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (variableId != null) #variableId: variableId,
      if (numberExpression != null) #numberExpression: numberExpression,
    }),
  );
  @override
  SetNumberValue $make(CopyWithData data) => SetNumberValue.mappableConstructor(
    id: data.get(#id, or: $value.id),
    variableId: data.get(#variableId, or: $value.variableId),
    numberExpression: data.get(#numberExpression, or: $value.numberExpression),
  );

  @override
  SetNumberValueCopyWith<$R2, SetNumberValue, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SetNumberValueCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

