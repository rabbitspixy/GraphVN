// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'compare_numbers_expression.dart';

class BooleanOperatorMapper extends EnumMapper<BooleanOperator> {
  BooleanOperatorMapper._();

  static BooleanOperatorMapper? _instance;
  static BooleanOperatorMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BooleanOperatorMapper._());
    }
    return _instance!;
  }

  static BooleanOperator fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  BooleanOperator decode(dynamic value) {
    switch (value) {
      case r'equal':
        return BooleanOperator.equal;
      case r'notEqual':
        return BooleanOperator.notEqual;
      case r'greater':
        return BooleanOperator.greater;
      case r'greaterOrEqual':
        return BooleanOperator.greaterOrEqual;
      case r'less':
        return BooleanOperator.less;
      case r'lessOrEqual':
        return BooleanOperator.lessOrEqual;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(BooleanOperator self) {
    switch (self) {
      case BooleanOperator.equal:
        return r'equal';
      case BooleanOperator.notEqual:
        return r'notEqual';
      case BooleanOperator.greater:
        return r'greater';
      case BooleanOperator.greaterOrEqual:
        return r'greaterOrEqual';
      case BooleanOperator.less:
        return r'less';
      case BooleanOperator.lessOrEqual:
        return r'lessOrEqual';
    }
  }
}

extension BooleanOperatorMapperExtension on BooleanOperator {
  String toValue() {
    BooleanOperatorMapper.ensureInitialized();
    return MapperContainer.globals.toValue<BooleanOperator>(this) as String;
  }
}

class CompareNumbersExpressionMapper
    extends SubClassMapperBase<CompareNumbersExpression> {
  CompareNumbersExpressionMapper._();

  static CompareNumbersExpressionMapper? _instance;
  static CompareNumbersExpressionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = CompareNumbersExpressionMapper._(),
      );
      NamedNumberExpressionMapper.ensureInitialized().addSubMapper(_instance!);
      NumberExpressionMapper.ensureInitialized();
      BooleanOperatorMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CompareNumbersExpression';

  static String _$namedNumbersTypeId(CompareNumbersExpression v) =>
      v.namedNumbersTypeId;
  static const Field<CompareNumbersExpression, String> _f$namedNumbersTypeId =
      Field('namedNumbersTypeId', _$namedNumbersTypeId);
  static NumberExpression _$left(CompareNumbersExpression v) => v.left;
  static const Field<CompareNumbersExpression, NumberExpression> _f$left =
      Field('left', _$left);
  static BooleanOperator _$operator(CompareNumbersExpression v) => v.operator;
  static const Field<CompareNumbersExpression, BooleanOperator> _f$operator =
      Field('operator', _$operator);
  static NumberExpression _$right(CompareNumbersExpression v) => v.right;
  static const Field<CompareNumbersExpression, NumberExpression> _f$right =
      Field('right', _$right);

  @override
  final MappableFields<CompareNumbersExpression> fields = const {
    #namedNumbersTypeId: _f$namedNumbersTypeId,
    #left: _f$left,
    #operator: _f$operator,
    #right: _f$right,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'CompareNumbersExpression';
  @override
  late final ClassMapperBase superMapper =
      NamedNumberExpressionMapper.ensureInitialized();

  static CompareNumbersExpression _instantiate(DecodingData data) {
    return CompareNumbersExpression.mappableConstructor(
      namedNumbersTypeId: data.dec(_f$namedNumbersTypeId),
      left: data.dec(_f$left),
      operator: data.dec(_f$operator),
      right: data.dec(_f$right),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CompareNumbersExpression fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CompareNumbersExpression>(map);
  }

  static CompareNumbersExpression fromJson(String json) {
    return ensureInitialized().decodeJson<CompareNumbersExpression>(json);
  }
}

mixin CompareNumbersExpressionMappable {
  String toJson() {
    return CompareNumbersExpressionMapper.ensureInitialized()
        .encodeJson<CompareNumbersExpression>(this as CompareNumbersExpression);
  }

  Map<String, dynamic> toMap() {
    return CompareNumbersExpressionMapper.ensureInitialized()
        .encodeMap<CompareNumbersExpression>(this as CompareNumbersExpression);
  }

  CompareNumbersExpressionCopyWith<
    CompareNumbersExpression,
    CompareNumbersExpression,
    CompareNumbersExpression
  >
  get copyWith =>
      _CompareNumbersExpressionCopyWithImpl<
        CompareNumbersExpression,
        CompareNumbersExpression
      >(this as CompareNumbersExpression, $identity, $identity);
  @override
  String toString() {
    return CompareNumbersExpressionMapper.ensureInitialized().stringifyValue(
      this as CompareNumbersExpression,
    );
  }

  @override
  bool operator ==(Object other) {
    return CompareNumbersExpressionMapper.ensureInitialized().equalsValue(
      this as CompareNumbersExpression,
      other,
    );
  }

  @override
  int get hashCode {
    return CompareNumbersExpressionMapper.ensureInitialized().hashValue(
      this as CompareNumbersExpression,
    );
  }
}

extension CompareNumbersExpressionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CompareNumbersExpression, $Out> {
  CompareNumbersExpressionCopyWith<$R, CompareNumbersExpression, $Out>
  get $asCompareNumbersExpression => $base.as(
    (v, t, t2) => _CompareNumbersExpressionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CompareNumbersExpressionCopyWith<
  $R,
  $In extends CompareNumbersExpression,
  $Out
>
    implements NamedNumberExpressionCopyWith<$R, $In, $Out> {
  NumberExpressionCopyWith<$R, NumberExpression, NumberExpression> get left;
  NumberExpressionCopyWith<$R, NumberExpression, NumberExpression> get right;
  @override
  $R call({
    String? namedNumbersTypeId,
    NumberExpression? left,
    BooleanOperator? operator,
    NumberExpression? right,
  });
  CompareNumbersExpressionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CompareNumbersExpressionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CompareNumbersExpression, $Out>
    implements
        CompareNumbersExpressionCopyWith<$R, CompareNumbersExpression, $Out> {
  _CompareNumbersExpressionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CompareNumbersExpression> $mapper =
      CompareNumbersExpressionMapper.ensureInitialized();
  @override
  NumberExpressionCopyWith<$R, NumberExpression, NumberExpression> get left =>
      $value.left.copyWith.$chain((v) => call(left: v));
  @override
  NumberExpressionCopyWith<$R, NumberExpression, NumberExpression> get right =>
      $value.right.copyWith.$chain((v) => call(right: v));
  @override
  $R call({
    String? namedNumbersTypeId,
    NumberExpression? left,
    BooleanOperator? operator,
    NumberExpression? right,
  }) => $apply(
    FieldCopyWithData({
      if (namedNumbersTypeId != null) #namedNumbersTypeId: namedNumbersTypeId,
      if (left != null) #left: left,
      if (operator != null) #operator: operator,
      if (right != null) #right: right,
    }),
  );
  @override
  CompareNumbersExpression $make(CopyWithData data) =>
      CompareNumbersExpression.mappableConstructor(
        namedNumbersTypeId: data.get(
          #namedNumbersTypeId,
          or: $value.namedNumbersTypeId,
        ),
        left: data.get(#left, or: $value.left),
        operator: data.get(#operator, or: $value.operator),
        right: data.get(#right, or: $value.right),
      );

  @override
  CompareNumbersExpressionCopyWith<$R2, CompareNumbersExpression, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CompareNumbersExpressionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

