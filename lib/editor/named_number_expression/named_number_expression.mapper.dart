// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'named_number_expression.dart';

class NamedNumberExpressionMapper
    extends ClassMapperBase<NamedNumberExpression> {
  NamedNumberExpressionMapper._();

  static NamedNumberExpressionMapper? _instance;
  static NamedNumberExpressionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NamedNumberExpressionMapper._());
      ConstantNamedNumberExpressionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NamedNumberExpression';

  static String _$namedNumbersTypeId(NamedNumberExpression v) =>
      v.namedNumbersTypeId;
  static const Field<NamedNumberExpression, String> _f$namedNumbersTypeId =
      Field('namedNumbersTypeId', _$namedNumbersTypeId);

  @override
  final MappableFields<NamedNumberExpression> fields = const {
    #namedNumbersTypeId: _f$namedNumbersTypeId,
  };

  static NamedNumberExpression _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'NamedNumberExpression',
      'subclass',
      '${data.value['subclass']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NamedNumberExpression fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NamedNumberExpression>(map);
  }

  static NamedNumberExpression fromJson(String json) {
    return ensureInitialized().decodeJson<NamedNumberExpression>(json);
  }
}

mixin NamedNumberExpressionMappable {
  String toJson();
  Map<String, dynamic> toMap();
  NamedNumberExpressionCopyWith<
    NamedNumberExpression,
    NamedNumberExpression,
    NamedNumberExpression
  >
  get copyWith;
}

abstract class NamedNumberExpressionCopyWith<
  $R,
  $In extends NamedNumberExpression,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? namedNumbersTypeId});
  NamedNumberExpressionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

