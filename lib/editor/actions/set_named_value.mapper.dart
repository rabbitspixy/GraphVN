// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'set_named_value.dart';

class SetNamedValueMapper extends SubClassMapperBase<SetNamedValue> {
  SetNamedValueMapper._();

  static SetNamedValueMapper? _instance;
  static SetNamedValueMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SetNamedValueMapper._());
      BaseActionMapper.ensureInitialized().addSubMapper(_instance!);
      NamedValueExpressionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SetNamedValue';

  static String _$id(SetNamedValue v) => v.id;
  static const Field<SetNamedValue, String> _f$id = Field('id', _$id);
  static String _$variableId(SetNamedValue v) => v.variableId;
  static const Field<SetNamedValue, String> _f$variableId = Field(
    'variableId',
    _$variableId,
  );
  static NamedValueExpression _$expression(SetNamedValue v) => v.expression;
  static const Field<SetNamedValue, NamedValueExpression> _f$expression = Field(
    'expression',
    _$expression,
  );

  @override
  final MappableFields<SetNamedValue> fields = const {
    #id: _f$id,
    #variableId: _f$variableId,
    #expression: _f$expression,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'SetNamedValue';
  @override
  late final ClassMapperBase superMapper = BaseActionMapper.ensureInitialized();

  static SetNamedValue _instantiate(DecodingData data) {
    return SetNamedValue.mappableConstructor(
      id: data.dec(_f$id),
      variableId: data.dec(_f$variableId),
      expression: data.dec(_f$expression),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SetNamedValue fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SetNamedValue>(map);
  }

  static SetNamedValue fromJson(String json) {
    return ensureInitialized().decodeJson<SetNamedValue>(json);
  }
}

mixin SetNamedValueMappable {
  String toJson() {
    return SetNamedValueMapper.ensureInitialized().encodeJson<SetNamedValue>(
      this as SetNamedValue,
    );
  }

  Map<String, dynamic> toMap() {
    return SetNamedValueMapper.ensureInitialized().encodeMap<SetNamedValue>(
      this as SetNamedValue,
    );
  }

  SetNamedValueCopyWith<SetNamedValue, SetNamedValue, SetNamedValue>
  get copyWith => _SetNamedValueCopyWithImpl<SetNamedValue, SetNamedValue>(
    this as SetNamedValue,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SetNamedValueMapper.ensureInitialized().stringifyValue(
      this as SetNamedValue,
    );
  }

  @override
  bool operator ==(Object other) {
    return SetNamedValueMapper.ensureInitialized().equalsValue(
      this as SetNamedValue,
      other,
    );
  }

  @override
  int get hashCode {
    return SetNamedValueMapper.ensureInitialized().hashValue(
      this as SetNamedValue,
    );
  }
}

extension SetNamedValueValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SetNamedValue, $Out> {
  SetNamedValueCopyWith<$R, SetNamedValue, $Out> get $asSetNamedValue =>
      $base.as((v, t, t2) => _SetNamedValueCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SetNamedValueCopyWith<$R, $In extends SetNamedValue, $Out>
    implements BaseActionCopyWith<$R, $In, $Out> {
  NamedValueExpressionCopyWith<$R, NamedValueExpression, NamedValueExpression>
  get expression;
  @override
  $R call({String? id, String? variableId, NamedValueExpression? expression});
  SetNamedValueCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SetNamedValueCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SetNamedValue, $Out>
    implements SetNamedValueCopyWith<$R, SetNamedValue, $Out> {
  _SetNamedValueCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SetNamedValue> $mapper =
      SetNamedValueMapper.ensureInitialized();
  @override
  NamedValueExpressionCopyWith<$R, NamedValueExpression, NamedValueExpression>
  get expression =>
      $value.expression.copyWith.$chain((v) => call(expression: v));
  @override
  $R call({String? id, String? variableId, NamedValueExpression? expression}) =>
      $apply(
        FieldCopyWithData({
          if (id != null) #id: id,
          if (variableId != null) #variableId: variableId,
          if (expression != null) #expression: expression,
        }),
      );
  @override
  SetNamedValue $make(CopyWithData data) => SetNamedValue.mappableConstructor(
    id: data.get(#id, or: $value.id),
    variableId: data.get(#variableId, or: $value.variableId),
    expression: data.get(#expression, or: $value.expression),
  );

  @override
  SetNamedValueCopyWith<$R2, SetNamedValue, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SetNamedValueCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

