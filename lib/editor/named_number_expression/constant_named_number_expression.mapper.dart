// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'constant_named_number_expression.dart';

class ConstantNamedNumberExpressionMapper
    extends SubClassMapperBase<ConstantNamedNumberExpression> {
  ConstantNamedNumberExpressionMapper._();

  static ConstantNamedNumberExpressionMapper? _instance;
  static ConstantNamedNumberExpressionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ConstantNamedNumberExpressionMapper._(),
      );
      NamedNumberExpressionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ConstantNamedNumberExpression';

  static String _$namedNumbersTypeId(ConstantNamedNumberExpression v) =>
      v.namedNumbersTypeId;
  static const Field<ConstantNamedNumberExpression, String>
  _f$namedNumbersTypeId = Field('namedNumbersTypeId', _$namedNumbersTypeId);
  static String _$value(ConstantNamedNumberExpression v) => v.value;
  static const Field<ConstantNamedNumberExpression, String> _f$value = Field(
    'value',
    _$value,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<ConstantNamedNumberExpression> fields = const {
    #namedNumbersTypeId: _f$namedNumbersTypeId,
    #value: _f$value,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'ConstantNamedNumberExpression';
  @override
  late final ClassMapperBase superMapper =
      NamedNumberExpressionMapper.ensureInitialized();

  static ConstantNamedNumberExpression _instantiate(DecodingData data) {
    return ConstantNamedNumberExpression(
      namedNumbersTypeId: data.dec(_f$namedNumbersTypeId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ConstantNamedNumberExpression fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConstantNamedNumberExpression>(map);
  }

  static ConstantNamedNumberExpression fromJson(String json) {
    return ensureInitialized().decodeJson<ConstantNamedNumberExpression>(json);
  }
}

mixin ConstantNamedNumberExpressionMappable {
  String toJson() {
    return ConstantNamedNumberExpressionMapper.ensureInitialized()
        .encodeJson<ConstantNamedNumberExpression>(
          this as ConstantNamedNumberExpression,
        );
  }

  Map<String, dynamic> toMap() {
    return ConstantNamedNumberExpressionMapper.ensureInitialized()
        .encodeMap<ConstantNamedNumberExpression>(
          this as ConstantNamedNumberExpression,
        );
  }

  ConstantNamedNumberExpressionCopyWith<
    ConstantNamedNumberExpression,
    ConstantNamedNumberExpression,
    ConstantNamedNumberExpression
  >
  get copyWith =>
      _ConstantNamedNumberExpressionCopyWithImpl<
        ConstantNamedNumberExpression,
        ConstantNamedNumberExpression
      >(this as ConstantNamedNumberExpression, $identity, $identity);
  @override
  String toString() {
    return ConstantNamedNumberExpressionMapper.ensureInitialized()
        .stringifyValue(this as ConstantNamedNumberExpression);
  }

  @override
  bool operator ==(Object other) {
    return ConstantNamedNumberExpressionMapper.ensureInitialized().equalsValue(
      this as ConstantNamedNumberExpression,
      other,
    );
  }

  @override
  int get hashCode {
    return ConstantNamedNumberExpressionMapper.ensureInitialized().hashValue(
      this as ConstantNamedNumberExpression,
    );
  }
}

extension ConstantNamedNumberExpressionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ConstantNamedNumberExpression, $Out> {
  ConstantNamedNumberExpressionCopyWith<$R, ConstantNamedNumberExpression, $Out>
  get $asConstantNamedNumberExpression => $base.as(
    (v, t, t2) =>
        _ConstantNamedNumberExpressionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ConstantNamedNumberExpressionCopyWith<
  $R,
  $In extends ConstantNamedNumberExpression,
  $Out
>
    implements NamedNumberExpressionCopyWith<$R, $In, $Out> {
  @override
  $R call({String? namedNumbersTypeId});
  ConstantNamedNumberExpressionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ConstantNamedNumberExpressionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ConstantNamedNumberExpression, $Out>
    implements
        ConstantNamedNumberExpressionCopyWith<
          $R,
          ConstantNamedNumberExpression,
          $Out
        > {
  _ConstantNamedNumberExpressionCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<ConstantNamedNumberExpression> $mapper =
      ConstantNamedNumberExpressionMapper.ensureInitialized();
  @override
  $R call({String? namedNumbersTypeId}) => $apply(
    FieldCopyWithData({
      if (namedNumbersTypeId != null) #namedNumbersTypeId: namedNumbersTypeId,
    }),
  );
  @override
  ConstantNamedNumberExpression $make(CopyWithData data) =>
      ConstantNamedNumberExpression(
        namedNumbersTypeId: data.get(
          #namedNumbersTypeId,
          or: $value.namedNumbersTypeId,
        ),
      );

  @override
  ConstantNamedNumberExpressionCopyWith<
    $R2,
    ConstantNamedNumberExpression,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ConstantNamedNumberExpressionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

