// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'named_value_expression.dart';

class NamedValueExpressionMapper extends ClassMapperBase<NamedValueExpression> {
  NamedValueExpressionMapper._();

  static NamedValueExpressionMapper? _instance;
  static NamedValueExpressionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NamedValueExpressionMapper._());
      ConstantNamedValueExpressionMapper.ensureInitialized();
      CompareNumbersExpressionMapper.ensureInitialized();
      CompareNamedValueExpressionMapper.ensureInitialized();
      NamedValueOfExpressionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NamedValueExpression';

  @override
  final MappableFields<NamedValueExpression> fields = const {};

  static NamedValueExpression _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'NamedValueExpression',
      'subclass',
      '${data.value['subclass']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NamedValueExpression fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NamedValueExpression>(map);
  }

  static NamedValueExpression fromJson(String json) {
    return ensureInitialized().decodeJson<NamedValueExpression>(json);
  }
}

mixin NamedValueExpressionMappable {
  String toJson();
  Map<String, dynamic> toMap();
  NamedValueExpressionCopyWith<
    NamedValueExpression,
    NamedValueExpression,
    NamedValueExpression
  >
  get copyWith;
}

abstract class NamedValueExpressionCopyWith<
  $R,
  $In extends NamedValueExpression,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  NamedValueExpressionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

