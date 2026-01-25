// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'number_expression.dart';

class NumberExpressionMapper extends ClassMapperBase<NumberExpression> {
  NumberExpressionMapper._();

  static NumberExpressionMapper? _instance;
  static NumberExpressionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NumberExpressionMapper._());
      ConstantNumberExpressionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NumberExpression';

  @override
  final MappableFields<NumberExpression> fields = const {};

  static NumberExpression _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'NumberExpression',
      'subclass',
      '${data.value['subclass']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NumberExpression fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NumberExpression>(map);
  }

  static NumberExpression fromJson(String json) {
    return ensureInitialized().decodeJson<NumberExpression>(json);
  }
}

mixin NumberExpressionMappable {
  String toJson();
  Map<String, dynamic> toMap();
  NumberExpressionCopyWith<NumberExpression, NumberExpression, NumberExpression>
  get copyWith;
}

abstract class NumberExpressionCopyWith<$R, $In extends NumberExpression, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  NumberExpressionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

