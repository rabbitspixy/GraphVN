// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'boolean_number_expression.dart';

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

class BooleanNumberExpressionMapper
    extends SubClassMapperBase<BooleanNumberExpression> {
  BooleanNumberExpressionMapper._();

  static BooleanNumberExpressionMapper? _instance;
  static BooleanNumberExpressionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = BooleanNumberExpressionMapper._(),
      );
      NamedNumberExpressionMapper.ensureInitialized().addSubMapper(_instance!);
      NumberExpressionMapper.ensureInitialized();
      BooleanOperatorMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BooleanNumberExpression';

  static String _$namedNumbersTypeId(BooleanNumberExpression v) =>
      v.namedNumbersTypeId;
  static const Field<BooleanNumberExpression, String> _f$namedNumbersTypeId =
      Field('namedNumbersTypeId', _$namedNumbersTypeId);
  static NumberExpression _$left(BooleanNumberExpression v) => v.left;
  static const Field<BooleanNumberExpression, NumberExpression> _f$left = Field(
    'left',
    _$left,
  );
  static BooleanOperator _$operator(BooleanNumberExpression v) => v.operator;
  static const Field<BooleanNumberExpression, BooleanOperator> _f$operator =
      Field('operator', _$operator);
  static NumberExpression _$right(BooleanNumberExpression v) => v.right;
  static const Field<BooleanNumberExpression, NumberExpression> _f$right =
      Field('right', _$right);

  @override
  final MappableFields<BooleanNumberExpression> fields = const {
    #namedNumbersTypeId: _f$namedNumbersTypeId,
    #left: _f$left,
    #operator: _f$operator,
    #right: _f$right,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'BooleanExpression';
  @override
  late final ClassMapperBase superMapper =
      NamedNumberExpressionMapper.ensureInitialized();

  static BooleanNumberExpression _instantiate(DecodingData data) {
    return BooleanNumberExpression.mappableConstructor(
      namedNumbersTypeId: data.dec(_f$namedNumbersTypeId),
      left: data.dec(_f$left),
      operator: data.dec(_f$operator),
      right: data.dec(_f$right),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BooleanNumberExpression fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BooleanNumberExpression>(map);
  }

  static BooleanNumberExpression fromJson(String json) {
    return ensureInitialized().decodeJson<BooleanNumberExpression>(json);
  }
}

mixin BooleanNumberExpressionMappable {
  String toJson() {
    return BooleanNumberExpressionMapper.ensureInitialized()
        .encodeJson<BooleanNumberExpression>(this as BooleanNumberExpression);
  }

  Map<String, dynamic> toMap() {
    return BooleanNumberExpressionMapper.ensureInitialized()
        .encodeMap<BooleanNumberExpression>(this as BooleanNumberExpression);
  }

  BooleanNumberExpressionCopyWith<
    BooleanNumberExpression,
    BooleanNumberExpression,
    BooleanNumberExpression
  >
  get copyWith =>
      _BooleanNumberExpressionCopyWithImpl<
        BooleanNumberExpression,
        BooleanNumberExpression
      >(this as BooleanNumberExpression, $identity, $identity);
  @override
  String toString() {
    return BooleanNumberExpressionMapper.ensureInitialized().stringifyValue(
      this as BooleanNumberExpression,
    );
  }

  @override
  bool operator ==(Object other) {
    return BooleanNumberExpressionMapper.ensureInitialized().equalsValue(
      this as BooleanNumberExpression,
      other,
    );
  }

  @override
  int get hashCode {
    return BooleanNumberExpressionMapper.ensureInitialized().hashValue(
      this as BooleanNumberExpression,
    );
  }
}

extension BooleanNumberExpressionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BooleanNumberExpression, $Out> {
  BooleanNumberExpressionCopyWith<$R, BooleanNumberExpression, $Out>
  get $asBooleanNumberExpression => $base.as(
    (v, t, t2) => _BooleanNumberExpressionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class BooleanNumberExpressionCopyWith<
  $R,
  $In extends BooleanNumberExpression,
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
  BooleanNumberExpressionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _BooleanNumberExpressionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BooleanNumberExpression, $Out>
    implements
        BooleanNumberExpressionCopyWith<$R, BooleanNumberExpression, $Out> {
  _BooleanNumberExpressionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BooleanNumberExpression> $mapper =
      BooleanNumberExpressionMapper.ensureInitialized();
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
  BooleanNumberExpression $make(CopyWithData data) =>
      BooleanNumberExpression.mappableConstructor(
        namedNumbersTypeId: data.get(
          #namedNumbersTypeId,
          or: $value.namedNumbersTypeId,
        ),
        left: data.get(#left, or: $value.left),
        operator: data.get(#operator, or: $value.operator),
        right: data.get(#right, or: $value.right),
      );

  @override
  BooleanNumberExpressionCopyWith<$R2, BooleanNumberExpression, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _BooleanNumberExpressionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

