// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'constant_number_expression.dart';

class ConstantNumberExpressionMapper
    extends SubClassMapperBase<ConstantNumberExpression> {
  ConstantNumberExpressionMapper._();

  static ConstantNumberExpressionMapper? _instance;
  static ConstantNumberExpressionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ConstantNumberExpressionMapper._(),
      );
      NumberExpressionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ConstantNumberExpression';

  static Rational _$value(ConstantNumberExpression v) => v.value;
  static const Field<ConstantNumberExpression, Rational> _f$value = Field(
    'value',
    _$value,
  );

  @override
  final MappableFields<ConstantNumberExpression> fields = const {
    #value: _f$value,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'ConstantNumberExpression';
  @override
  late final ClassMapperBase superMapper =
      NumberExpressionMapper.ensureInitialized();

  static ConstantNumberExpression _instantiate(DecodingData data) {
    return ConstantNumberExpression.mappableConstructor(
      value: data.dec(_f$value),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ConstantNumberExpression fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConstantNumberExpression>(map);
  }

  static ConstantNumberExpression fromJson(String json) {
    return ensureInitialized().decodeJson<ConstantNumberExpression>(json);
  }
}

mixin ConstantNumberExpressionMappable {
  String toJson() {
    return ConstantNumberExpressionMapper.ensureInitialized()
        .encodeJson<ConstantNumberExpression>(this as ConstantNumberExpression);
  }

  Map<String, dynamic> toMap() {
    return ConstantNumberExpressionMapper.ensureInitialized()
        .encodeMap<ConstantNumberExpression>(this as ConstantNumberExpression);
  }

  ConstantNumberExpressionCopyWith<
    ConstantNumberExpression,
    ConstantNumberExpression,
    ConstantNumberExpression
  >
  get copyWith =>
      _ConstantNumberExpressionCopyWithImpl<
        ConstantNumberExpression,
        ConstantNumberExpression
      >(this as ConstantNumberExpression, $identity, $identity);
  @override
  String toString() {
    return ConstantNumberExpressionMapper.ensureInitialized().stringifyValue(
      this as ConstantNumberExpression,
    );
  }

  @override
  bool operator ==(Object other) {
    return ConstantNumberExpressionMapper.ensureInitialized().equalsValue(
      this as ConstantNumberExpression,
      other,
    );
  }

  @override
  int get hashCode {
    return ConstantNumberExpressionMapper.ensureInitialized().hashValue(
      this as ConstantNumberExpression,
    );
  }
}

extension ConstantNumberExpressionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ConstantNumberExpression, $Out> {
  ConstantNumberExpressionCopyWith<$R, ConstantNumberExpression, $Out>
  get $asConstantNumberExpression => $base.as(
    (v, t, t2) => _ConstantNumberExpressionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ConstantNumberExpressionCopyWith<
  $R,
  $In extends ConstantNumberExpression,
  $Out
>
    implements NumberExpressionCopyWith<$R, $In, $Out> {
  @override
  $R call({Rational? value});
  ConstantNumberExpressionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ConstantNumberExpressionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ConstantNumberExpression, $Out>
    implements
        ConstantNumberExpressionCopyWith<$R, ConstantNumberExpression, $Out> {
  _ConstantNumberExpressionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ConstantNumberExpression> $mapper =
      ConstantNumberExpressionMapper.ensureInitialized();
  @override
  $R call({Rational? value}) =>
      $apply(FieldCopyWithData({if (value != null) #value: value}));
  @override
  ConstantNumberExpression $make(CopyWithData data) =>
      ConstantNumberExpression.mappableConstructor(
        value: data.get(#value, or: $value.value),
      );

  @override
  ConstantNumberExpressionCopyWith<$R2, ConstantNumberExpression, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ConstantNumberExpressionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

