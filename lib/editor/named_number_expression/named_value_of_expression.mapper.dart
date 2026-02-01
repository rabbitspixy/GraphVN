// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'named_value_of_expression.dart';

class NamedValueOfExpressionMapper
    extends SubClassMapperBase<NamedValueOfExpression> {
  NamedValueOfExpressionMapper._();

  static NamedValueOfExpressionMapper? _instance;
  static NamedValueOfExpressionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NamedValueOfExpressionMapper._());
      NamedValueExpressionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'NamedValueOfExpression';

  static String _$namedNumbersTypeId(NamedValueOfExpression v) =>
      v.namedNumbersTypeId;
  static const Field<NamedValueOfExpression, String> _f$namedNumbersTypeId =
      Field('namedNumbersTypeId', _$namedNumbersTypeId);
  static String _$variableId(NamedValueOfExpression v) => v.variableId;
  static const Field<NamedValueOfExpression, String> _f$variableId = Field(
    'variableId',
    _$variableId,
  );

  @override
  final MappableFields<NamedValueOfExpression> fields = const {
    #namedNumbersTypeId: _f$namedNumbersTypeId,
    #variableId: _f$variableId,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'NamedValueOfExpression';
  @override
  late final ClassMapperBase superMapper =
      NamedValueExpressionMapper.ensureInitialized();

  static NamedValueOfExpression _instantiate(DecodingData data) {
    return NamedValueOfExpression.mappableConstructor(
      namedNumbersTypeId: data.dec(_f$namedNumbersTypeId),
      variableId: data.dec(_f$variableId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NamedValueOfExpression fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NamedValueOfExpression>(map);
  }

  static NamedValueOfExpression fromJson(String json) {
    return ensureInitialized().decodeJson<NamedValueOfExpression>(json);
  }
}

mixin NamedValueOfExpressionMappable {
  String toJson() {
    return NamedValueOfExpressionMapper.ensureInitialized()
        .encodeJson<NamedValueOfExpression>(this as NamedValueOfExpression);
  }

  Map<String, dynamic> toMap() {
    return NamedValueOfExpressionMapper.ensureInitialized()
        .encodeMap<NamedValueOfExpression>(this as NamedValueOfExpression);
  }

  NamedValueOfExpressionCopyWith<
    NamedValueOfExpression,
    NamedValueOfExpression,
    NamedValueOfExpression
  >
  get copyWith =>
      _NamedValueOfExpressionCopyWithImpl<
        NamedValueOfExpression,
        NamedValueOfExpression
      >(this as NamedValueOfExpression, $identity, $identity);
  @override
  String toString() {
    return NamedValueOfExpressionMapper.ensureInitialized().stringifyValue(
      this as NamedValueOfExpression,
    );
  }

  @override
  bool operator ==(Object other) {
    return NamedValueOfExpressionMapper.ensureInitialized().equalsValue(
      this as NamedValueOfExpression,
      other,
    );
  }

  @override
  int get hashCode {
    return NamedValueOfExpressionMapper.ensureInitialized().hashValue(
      this as NamedValueOfExpression,
    );
  }
}

extension NamedValueOfExpressionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NamedValueOfExpression, $Out> {
  NamedValueOfExpressionCopyWith<$R, NamedValueOfExpression, $Out>
  get $asNamedValueOfExpression => $base.as(
    (v, t, t2) => _NamedValueOfExpressionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class NamedValueOfExpressionCopyWith<
  $R,
  $In extends NamedValueOfExpression,
  $Out
>
    implements NamedValueExpressionCopyWith<$R, $In, $Out> {
  @override
  $R call({String? namedNumbersTypeId, String? variableId});
  NamedValueOfExpressionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _NamedValueOfExpressionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NamedValueOfExpression, $Out>
    implements
        NamedValueOfExpressionCopyWith<$R, NamedValueOfExpression, $Out> {
  _NamedValueOfExpressionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NamedValueOfExpression> $mapper =
      NamedValueOfExpressionMapper.ensureInitialized();
  @override
  $R call({String? namedNumbersTypeId, String? variableId}) => $apply(
    FieldCopyWithData({
      if (namedNumbersTypeId != null) #namedNumbersTypeId: namedNumbersTypeId,
      if (variableId != null) #variableId: variableId,
    }),
  );
  @override
  NamedValueOfExpression $make(CopyWithData data) =>
      NamedValueOfExpression.mappableConstructor(
        namedNumbersTypeId: data.get(
          #namedNumbersTypeId,
          or: $value.namedNumbersTypeId,
        ),
        variableId: data.get(#variableId, or: $value.variableId),
      );

  @override
  NamedValueOfExpressionCopyWith<$R2, NamedValueOfExpression, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _NamedValueOfExpressionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

