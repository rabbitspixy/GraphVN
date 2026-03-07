// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'value_of_named_value_variable_expression.dart';

class ValueOfNamedValueVariableExpressionMapper
    extends SubClassMapperBase<ValueOfNamedValueVariableExpression> {
  ValueOfNamedValueVariableExpressionMapper._();

  static ValueOfNamedValueVariableExpressionMapper? _instance;
  static ValueOfNamedValueVariableExpressionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ValueOfNamedValueVariableExpressionMapper._(),
      );
      NamedValueExpressionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ValueOfNamedValueVariableExpression';

  static String _$variableId(ValueOfNamedValueVariableExpression v) =>
      v.variableId;
  static const Field<ValueOfNamedValueVariableExpression, String>
  _f$variableId = Field('variableId', _$variableId);

  @override
  final MappableFields<ValueOfNamedValueVariableExpression> fields = const {
    #variableId: _f$variableId,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'ValueOfNamedValueVariableExpression';
  @override
  late final ClassMapperBase superMapper =
      NamedValueExpressionMapper.ensureInitialized();

  static ValueOfNamedValueVariableExpression _instantiate(DecodingData data) {
    return ValueOfNamedValueVariableExpression.mappableConstructor(
      variableId: data.dec(_f$variableId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ValueOfNamedValueVariableExpression fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ValueOfNamedValueVariableExpression>(
      map,
    );
  }

  static ValueOfNamedValueVariableExpression fromJson(String json) {
    return ensureInitialized().decodeJson<ValueOfNamedValueVariableExpression>(
      json,
    );
  }
}

mixin ValueOfNamedValueVariableExpressionMappable {
  String toJson() {
    return ValueOfNamedValueVariableExpressionMapper.ensureInitialized()
        .encodeJson<ValueOfNamedValueVariableExpression>(
          this as ValueOfNamedValueVariableExpression,
        );
  }

  Map<String, dynamic> toMap() {
    return ValueOfNamedValueVariableExpressionMapper.ensureInitialized()
        .encodeMap<ValueOfNamedValueVariableExpression>(
          this as ValueOfNamedValueVariableExpression,
        );
  }

  ValueOfNamedValueVariableExpressionCopyWith<
    ValueOfNamedValueVariableExpression,
    ValueOfNamedValueVariableExpression,
    ValueOfNamedValueVariableExpression
  >
  get copyWith =>
      _ValueOfNamedValueVariableExpressionCopyWithImpl<
        ValueOfNamedValueVariableExpression,
        ValueOfNamedValueVariableExpression
      >(this as ValueOfNamedValueVariableExpression, $identity, $identity);
  @override
  String toString() {
    return ValueOfNamedValueVariableExpressionMapper.ensureInitialized()
        .stringifyValue(this as ValueOfNamedValueVariableExpression);
  }

  @override
  bool operator ==(Object other) {
    return ValueOfNamedValueVariableExpressionMapper.ensureInitialized()
        .equalsValue(this as ValueOfNamedValueVariableExpression, other);
  }

  @override
  int get hashCode {
    return ValueOfNamedValueVariableExpressionMapper.ensureInitialized()
        .hashValue(this as ValueOfNamedValueVariableExpression);
  }
}

extension ValueOfNamedValueVariableExpressionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ValueOfNamedValueVariableExpression, $Out> {
  ValueOfNamedValueVariableExpressionCopyWith<
    $R,
    ValueOfNamedValueVariableExpression,
    $Out
  >
  get $asValueOfNamedValueVariableExpression => $base.as(
    (v, t, t2) =>
        _ValueOfNamedValueVariableExpressionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ValueOfNamedValueVariableExpressionCopyWith<
  $R,
  $In extends ValueOfNamedValueVariableExpression,
  $Out
>
    implements NamedValueExpressionCopyWith<$R, $In, $Out> {
  @override
  $R call({String? variableId});
  ValueOfNamedValueVariableExpressionCopyWith<$R2, $In, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ValueOfNamedValueVariableExpressionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ValueOfNamedValueVariableExpression, $Out>
    implements
        ValueOfNamedValueVariableExpressionCopyWith<
          $R,
          ValueOfNamedValueVariableExpression,
          $Out
        > {
  _ValueOfNamedValueVariableExpressionCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<ValueOfNamedValueVariableExpression> $mapper =
      ValueOfNamedValueVariableExpressionMapper.ensureInitialized();
  @override
  $R call({String? variableId}) => $apply(
    FieldCopyWithData({if (variableId != null) #variableId: variableId}),
  );
  @override
  ValueOfNamedValueVariableExpression $make(CopyWithData data) =>
      ValueOfNamedValueVariableExpression.mappableConstructor(
        variableId: data.get(#variableId, or: $value.variableId),
      );

  @override
  ValueOfNamedValueVariableExpressionCopyWith<
    $R2,
    ValueOfNamedValueVariableExpression,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ValueOfNamedValueVariableExpressionCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

