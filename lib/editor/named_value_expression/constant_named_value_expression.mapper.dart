// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'constant_named_value_expression.dart';

class ConstantNamedValueExpressionMapper
    extends SubClassMapperBase<ConstantNamedValueExpression> {
  ConstantNamedValueExpressionMapper._();

  static ConstantNamedValueExpressionMapper? _instance;
  static ConstantNamedValueExpressionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ConstantNamedValueExpressionMapper._(),
      );
      NamedValueExpressionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ConstantNamedValueExpression';

  static String _$valueId(ConstantNamedValueExpression v) => v.valueId;
  static const Field<ConstantNamedValueExpression, String> _f$valueId = Field(
    'valueId',
    _$valueId,
  );

  @override
  final MappableFields<ConstantNamedValueExpression> fields = const {
    #valueId: _f$valueId,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'ConstantNamedValueExpression';
  @override
  late final ClassMapperBase superMapper =
      NamedValueExpressionMapper.ensureInitialized();

  static ConstantNamedValueExpression _instantiate(DecodingData data) {
    return ConstantNamedValueExpression.mappableConstructor(
      valueId: data.dec(_f$valueId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ConstantNamedValueExpression fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConstantNamedValueExpression>(map);
  }

  static ConstantNamedValueExpression fromJson(String json) {
    return ensureInitialized().decodeJson<ConstantNamedValueExpression>(json);
  }
}

mixin ConstantNamedValueExpressionMappable {
  String toJson() {
    return ConstantNamedValueExpressionMapper.ensureInitialized()
        .encodeJson<ConstantNamedValueExpression>(
          this as ConstantNamedValueExpression,
        );
  }

  Map<String, dynamic> toMap() {
    return ConstantNamedValueExpressionMapper.ensureInitialized()
        .encodeMap<ConstantNamedValueExpression>(
          this as ConstantNamedValueExpression,
        );
  }

  ConstantNamedValueExpressionCopyWith<
    ConstantNamedValueExpression,
    ConstantNamedValueExpression,
    ConstantNamedValueExpression
  >
  get copyWith =>
      _ConstantNamedValueExpressionCopyWithImpl<
        ConstantNamedValueExpression,
        ConstantNamedValueExpression
      >(this as ConstantNamedValueExpression, $identity, $identity);
  @override
  String toString() {
    return ConstantNamedValueExpressionMapper.ensureInitialized()
        .stringifyValue(this as ConstantNamedValueExpression);
  }

  @override
  bool operator ==(Object other) {
    return ConstantNamedValueExpressionMapper.ensureInitialized().equalsValue(
      this as ConstantNamedValueExpression,
      other,
    );
  }

  @override
  int get hashCode {
    return ConstantNamedValueExpressionMapper.ensureInitialized().hashValue(
      this as ConstantNamedValueExpression,
    );
  }
}

extension ConstantNamedValueExpressionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ConstantNamedValueExpression, $Out> {
  ConstantNamedValueExpressionCopyWith<$R, ConstantNamedValueExpression, $Out>
  get $asConstantNamedValueExpression => $base.as(
    (v, t, t2) => _ConstantNamedValueExpressionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ConstantNamedValueExpressionCopyWith<
  $R,
  $In extends ConstantNamedValueExpression,
  $Out
>
    implements NamedValueExpressionCopyWith<$R, $In, $Out> {
  @override
  $R call({String? valueId});
  ConstantNamedValueExpressionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ConstantNamedValueExpressionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ConstantNamedValueExpression, $Out>
    implements
        ConstantNamedValueExpressionCopyWith<
          $R,
          ConstantNamedValueExpression,
          $Out
        > {
  _ConstantNamedValueExpressionCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<ConstantNamedValueExpression> $mapper =
      ConstantNamedValueExpressionMapper.ensureInitialized();
  @override
  $R call({String? valueId}) =>
      $apply(FieldCopyWithData({if (valueId != null) #valueId: valueId}));
  @override
  ConstantNamedValueExpression $make(CopyWithData data) =>
      ConstantNamedValueExpression.mappableConstructor(
        valueId: data.get(#valueId, or: $value.valueId),
      );

  @override
  ConstantNamedValueExpressionCopyWith<$R2, ConstantNamedValueExpression, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ConstantNamedValueExpressionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

