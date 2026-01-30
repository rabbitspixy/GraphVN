// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'number_variable_value.dart';

class NumberVariableValueMapper
    extends SubClassMapperBase<NumberVariableValue> {
  NumberVariableValueMapper._();

  static NumberVariableValueMapper? _instance;
  static NumberVariableValueMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NumberVariableValueMapper._());
      NumberExpressionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'NumberVariableValue';

  static String _$variableId(NumberVariableValue v) => v.variableId;
  static const Field<NumberVariableValue, String> _f$variableId = Field(
    'variableId',
    _$variableId,
  );

  @override
  final MappableFields<NumberVariableValue> fields = const {
    #variableId: _f$variableId,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'NumberVariableValue';
  @override
  late final ClassMapperBase superMapper =
      NumberExpressionMapper.ensureInitialized();

  static NumberVariableValue _instantiate(DecodingData data) {
    return NumberVariableValue.mappableConstructor(
      variableId: data.dec(_f$variableId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NumberVariableValue fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NumberVariableValue>(map);
  }

  static NumberVariableValue fromJson(String json) {
    return ensureInitialized().decodeJson<NumberVariableValue>(json);
  }
}

mixin NumberVariableValueMappable {
  String toJson() {
    return NumberVariableValueMapper.ensureInitialized()
        .encodeJson<NumberVariableValue>(this as NumberVariableValue);
  }

  Map<String, dynamic> toMap() {
    return NumberVariableValueMapper.ensureInitialized()
        .encodeMap<NumberVariableValue>(this as NumberVariableValue);
  }

  NumberVariableValueCopyWith<
    NumberVariableValue,
    NumberVariableValue,
    NumberVariableValue
  >
  get copyWith =>
      _NumberVariableValueCopyWithImpl<
        NumberVariableValue,
        NumberVariableValue
      >(this as NumberVariableValue, $identity, $identity);
  @override
  String toString() {
    return NumberVariableValueMapper.ensureInitialized().stringifyValue(
      this as NumberVariableValue,
    );
  }

  @override
  bool operator ==(Object other) {
    return NumberVariableValueMapper.ensureInitialized().equalsValue(
      this as NumberVariableValue,
      other,
    );
  }

  @override
  int get hashCode {
    return NumberVariableValueMapper.ensureInitialized().hashValue(
      this as NumberVariableValue,
    );
  }
}

extension NumberVariableValueValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NumberVariableValue, $Out> {
  NumberVariableValueCopyWith<$R, NumberVariableValue, $Out>
  get $asNumberVariableValue => $base.as(
    (v, t, t2) => _NumberVariableValueCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class NumberVariableValueCopyWith<
  $R,
  $In extends NumberVariableValue,
  $Out
>
    implements NumberExpressionCopyWith<$R, $In, $Out> {
  @override
  $R call({String? variableId});
  NumberVariableValueCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _NumberVariableValueCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NumberVariableValue, $Out>
    implements NumberVariableValueCopyWith<$R, NumberVariableValue, $Out> {
  _NumberVariableValueCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NumberVariableValue> $mapper =
      NumberVariableValueMapper.ensureInitialized();
  @override
  $R call({String? variableId}) => $apply(
    FieldCopyWithData({if (variableId != null) #variableId: variableId}),
  );
  @override
  NumberVariableValue $make(CopyWithData data) =>
      NumberVariableValue.mappableConstructor(
        variableId: data.get(#variableId, or: $value.variableId),
      );

  @override
  NumberVariableValueCopyWith<$R2, NumberVariableValue, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _NumberVariableValueCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

