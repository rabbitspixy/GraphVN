// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'compare_named_value_expression.dart';

class CompareNamedValueOperatorMapper
    extends EnumMapper<CompareNamedValueOperator> {
  CompareNamedValueOperatorMapper._();

  static CompareNamedValueOperatorMapper? _instance;
  static CompareNamedValueOperatorMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = CompareNamedValueOperatorMapper._(),
      );
    }
    return _instance!;
  }

  static CompareNamedValueOperator fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  CompareNamedValueOperator decode(dynamic value) {
    switch (value) {
      case r'equal':
        return CompareNamedValueOperator.equal;
      case r'notEqual':
        return CompareNamedValueOperator.notEqual;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(CompareNamedValueOperator self) {
    switch (self) {
      case CompareNamedValueOperator.equal:
        return r'equal';
      case CompareNamedValueOperator.notEqual:
        return r'notEqual';
    }
  }
}

extension CompareNamedValueOperatorMapperExtension
    on CompareNamedValueOperator {
  String toValue() {
    CompareNamedValueOperatorMapper.ensureInitialized();
    return MapperContainer.globals.toValue<CompareNamedValueOperator>(this)
        as String;
  }
}

class CompareNamedValueExpressionMapper
    extends SubClassMapperBase<CompareNamedValueExpression> {
  CompareNamedValueExpressionMapper._();

  static CompareNamedValueExpressionMapper? _instance;
  static CompareNamedValueExpressionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = CompareNamedValueExpressionMapper._(),
      );
      NamedValueExpressionMapper.ensureInitialized().addSubMapper(_instance!);
      NamedValueExpressionMapper.ensureInitialized();
      CompareNamedValueOperatorMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CompareNamedValueExpression';

  static String _$namedNumbersTypeId(CompareNamedValueExpression v) =>
      v.namedNumbersTypeId;
  static const Field<CompareNamedValueExpression, String>
  _f$namedNumbersTypeId = Field('namedNumbersTypeId', _$namedNumbersTypeId);
  static NamedValueExpression _$left(CompareNamedValueExpression v) => v.left;
  static const Field<CompareNamedValueExpression, NamedValueExpression>
  _f$left = Field('left', _$left);
  static CompareNamedValueOperator _$operator(CompareNamedValueExpression v) =>
      v.operator;
  static const Field<CompareNamedValueExpression, CompareNamedValueOperator>
  _f$operator = Field('operator', _$operator);
  static NamedValueExpression _$right(CompareNamedValueExpression v) => v.right;
  static const Field<CompareNamedValueExpression, NamedValueExpression>
  _f$right = Field('right', _$right);

  @override
  final MappableFields<CompareNamedValueExpression> fields = const {
    #namedNumbersTypeId: _f$namedNumbersTypeId,
    #left: _f$left,
    #operator: _f$operator,
    #right: _f$right,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'CompareNamedValueExpression';
  @override
  late final ClassMapperBase superMapper =
      NamedValueExpressionMapper.ensureInitialized();

  static CompareNamedValueExpression _instantiate(DecodingData data) {
    return CompareNamedValueExpression.mappableConstructor(
      namedNumbersTypeId: data.dec(_f$namedNumbersTypeId),
      left: data.dec(_f$left),
      operator: data.dec(_f$operator),
      right: data.dec(_f$right),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CompareNamedValueExpression fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CompareNamedValueExpression>(map);
  }

  static CompareNamedValueExpression fromJson(String json) {
    return ensureInitialized().decodeJson<CompareNamedValueExpression>(json);
  }
}

mixin CompareNamedValueExpressionMappable {
  String toJson() {
    return CompareNamedValueExpressionMapper.ensureInitialized()
        .encodeJson<CompareNamedValueExpression>(
          this as CompareNamedValueExpression,
        );
  }

  Map<String, dynamic> toMap() {
    return CompareNamedValueExpressionMapper.ensureInitialized()
        .encodeMap<CompareNamedValueExpression>(
          this as CompareNamedValueExpression,
        );
  }

  CompareNamedValueExpressionCopyWith<
    CompareNamedValueExpression,
    CompareNamedValueExpression,
    CompareNamedValueExpression
  >
  get copyWith =>
      _CompareNamedValueExpressionCopyWithImpl<
        CompareNamedValueExpression,
        CompareNamedValueExpression
      >(this as CompareNamedValueExpression, $identity, $identity);
  @override
  String toString() {
    return CompareNamedValueExpressionMapper.ensureInitialized().stringifyValue(
      this as CompareNamedValueExpression,
    );
  }

  @override
  bool operator ==(Object other) {
    return CompareNamedValueExpressionMapper.ensureInitialized().equalsValue(
      this as CompareNamedValueExpression,
      other,
    );
  }

  @override
  int get hashCode {
    return CompareNamedValueExpressionMapper.ensureInitialized().hashValue(
      this as CompareNamedValueExpression,
    );
  }
}

extension CompareNamedValueExpressionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CompareNamedValueExpression, $Out> {
  CompareNamedValueExpressionCopyWith<$R, CompareNamedValueExpression, $Out>
  get $asCompareNamedValueExpression => $base.as(
    (v, t, t2) => _CompareNamedValueExpressionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CompareNamedValueExpressionCopyWith<
  $R,
  $In extends CompareNamedValueExpression,
  $Out
>
    implements NamedValueExpressionCopyWith<$R, $In, $Out> {
  NamedValueExpressionCopyWith<$R, NamedValueExpression, NamedValueExpression>
  get left;
  NamedValueExpressionCopyWith<$R, NamedValueExpression, NamedValueExpression>
  get right;
  @override
  $R call({
    String? namedNumbersTypeId,
    NamedValueExpression? left,
    CompareNamedValueOperator? operator,
    NamedValueExpression? right,
  });
  CompareNamedValueExpressionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CompareNamedValueExpressionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CompareNamedValueExpression, $Out>
    implements
        CompareNamedValueExpressionCopyWith<
          $R,
          CompareNamedValueExpression,
          $Out
        > {
  _CompareNamedValueExpressionCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<CompareNamedValueExpression> $mapper =
      CompareNamedValueExpressionMapper.ensureInitialized();
  @override
  NamedValueExpressionCopyWith<$R, NamedValueExpression, NamedValueExpression>
  get left => $value.left.copyWith.$chain((v) => call(left: v));
  @override
  NamedValueExpressionCopyWith<$R, NamedValueExpression, NamedValueExpression>
  get right => $value.right.copyWith.$chain((v) => call(right: v));
  @override
  $R call({
    String? namedNumbersTypeId,
    NamedValueExpression? left,
    CompareNamedValueOperator? operator,
    NamedValueExpression? right,
  }) => $apply(
    FieldCopyWithData({
      if (namedNumbersTypeId != null) #namedNumbersTypeId: namedNumbersTypeId,
      if (left != null) #left: left,
      if (operator != null) #operator: operator,
      if (right != null) #right: right,
    }),
  );
  @override
  CompareNamedValueExpression $make(CopyWithData data) =>
      CompareNamedValueExpression.mappableConstructor(
        namedNumbersTypeId: data.get(
          #namedNumbersTypeId,
          or: $value.namedNumbersTypeId,
        ),
        left: data.get(#left, or: $value.left),
        operator: data.get(#operator, or: $value.operator),
        right: data.get(#right, or: $value.right),
      );

  @override
  CompareNamedValueExpressionCopyWith<$R2, CompareNamedValueExpression, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CompareNamedValueExpressionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

