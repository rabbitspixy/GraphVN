// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'increase_number_value.dart';

class IncreaseNumberValueMapper
    extends SubClassMapperBase<IncreaseNumberValue> {
  IncreaseNumberValueMapper._();

  static IncreaseNumberValueMapper? _instance;
  static IncreaseNumberValueMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = IncreaseNumberValueMapper._());
      BaseActionMapper.ensureInitialized().addSubMapper(_instance!);
      NumberExpressionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'IncreaseNumberValue';

  static String _$id(IncreaseNumberValue v) => v.id;
  static const Field<IncreaseNumberValue, String> _f$id = Field('id', _$id);
  static String _$variableId(IncreaseNumberValue v) => v.variableId;
  static const Field<IncreaseNumberValue, String> _f$variableId = Field(
    'variableId',
    _$variableId,
  );
  static NumberExpression _$numberExpression(IncreaseNumberValue v) =>
      v.numberExpression;
  static const Field<IncreaseNumberValue, NumberExpression>
  _f$numberExpression = Field('numberExpression', _$numberExpression);

  @override
  final MappableFields<IncreaseNumberValue> fields = const {
    #id: _f$id,
    #variableId: _f$variableId,
    #numberExpression: _f$numberExpression,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'IncreaseNumberValue';
  @override
  late final ClassMapperBase superMapper = BaseActionMapper.ensureInitialized();

  static IncreaseNumberValue _instantiate(DecodingData data) {
    return IncreaseNumberValue.mappableConstructor(
      id: data.dec(_f$id),
      variableId: data.dec(_f$variableId),
      numberExpression: data.dec(_f$numberExpression),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static IncreaseNumberValue fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<IncreaseNumberValue>(map);
  }

  static IncreaseNumberValue fromJson(String json) {
    return ensureInitialized().decodeJson<IncreaseNumberValue>(json);
  }
}

mixin IncreaseNumberValueMappable {
  String toJson() {
    return IncreaseNumberValueMapper.ensureInitialized()
        .encodeJson<IncreaseNumberValue>(this as IncreaseNumberValue);
  }

  Map<String, dynamic> toMap() {
    return IncreaseNumberValueMapper.ensureInitialized()
        .encodeMap<IncreaseNumberValue>(this as IncreaseNumberValue);
  }

  IncreaseNumberValueCopyWith<
    IncreaseNumberValue,
    IncreaseNumberValue,
    IncreaseNumberValue
  >
  get copyWith =>
      _IncreaseNumberValueCopyWithImpl<
        IncreaseNumberValue,
        IncreaseNumberValue
      >(this as IncreaseNumberValue, $identity, $identity);
  @override
  String toString() {
    return IncreaseNumberValueMapper.ensureInitialized().stringifyValue(
      this as IncreaseNumberValue,
    );
  }

  @override
  bool operator ==(Object other) {
    return IncreaseNumberValueMapper.ensureInitialized().equalsValue(
      this as IncreaseNumberValue,
      other,
    );
  }

  @override
  int get hashCode {
    return IncreaseNumberValueMapper.ensureInitialized().hashValue(
      this as IncreaseNumberValue,
    );
  }
}

extension IncreaseNumberValueValueCopy<$R, $Out>
    on ObjectCopyWith<$R, IncreaseNumberValue, $Out> {
  IncreaseNumberValueCopyWith<$R, IncreaseNumberValue, $Out>
  get $asIncreaseNumberValue => $base.as(
    (v, t, t2) => _IncreaseNumberValueCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class IncreaseNumberValueCopyWith<
  $R,
  $In extends IncreaseNumberValue,
  $Out
>
    implements BaseActionCopyWith<$R, $In, $Out> {
  NumberExpressionCopyWith<$R, NumberExpression, NumberExpression>
  get numberExpression;
  @override
  $R call({String? id, String? variableId, NumberExpression? numberExpression});
  IncreaseNumberValueCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _IncreaseNumberValueCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, IncreaseNumberValue, $Out>
    implements IncreaseNumberValueCopyWith<$R, IncreaseNumberValue, $Out> {
  _IncreaseNumberValueCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<IncreaseNumberValue> $mapper =
      IncreaseNumberValueMapper.ensureInitialized();
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
  IncreaseNumberValue $make(CopyWithData data) =>
      IncreaseNumberValue.mappableConstructor(
        id: data.get(#id, or: $value.id),
        variableId: data.get(#variableId, or: $value.variableId),
        numberExpression: data.get(
          #numberExpression,
          or: $value.numberExpression,
        ),
      );

  @override
  IncreaseNumberValueCopyWith<$R2, IncreaseNumberValue, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _IncreaseNumberValueCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

