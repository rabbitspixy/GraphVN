// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'variables.dart';

class StructMapper extends ClassMapperBase<Struct> {
  StructMapper._();

  static StructMapper? _instance;
  static StructMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StructMapper._());
      VariableMapper.ensureInitialized();
      StructProcedureMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Struct';

  static String _$id(Struct v) => v.id;
  static const Field<Struct, String> _f$id = Field('id', _$id);
  static String _$name(Struct v) => v.name;
  static const Field<Struct, String> _f$name = Field('name', _$name);
  static List<Variable> _$variables(Struct v) => v.variables;
  static const Field<Struct, List<Variable>> _f$variables = Field(
    'variables',
    _$variables,
  );
  static List<StructProcedure> _$procedures(Struct v) => v.procedures;
  static const Field<Struct, List<StructProcedure>> _f$procedures = Field(
    'procedures',
    _$procedures,
  );

  @override
  final MappableFields<Struct> fields = const {
    #id: _f$id,
    #name: _f$name,
    #variables: _f$variables,
    #procedures: _f$procedures,
  };

  static Struct _instantiate(DecodingData data) {
    return Struct.mappableConstructor(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      variables: data.dec(_f$variables),
      procedures: data.dec(_f$procedures),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Struct fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Struct>(map);
  }

  static Struct fromJson(String json) {
    return ensureInitialized().decodeJson<Struct>(json);
  }
}

mixin StructMappable {
  String toJson() {
    return StructMapper.ensureInitialized().encodeJson<Struct>(this as Struct);
  }

  Map<String, dynamic> toMap() {
    return StructMapper.ensureInitialized().encodeMap<Struct>(this as Struct);
  }

  StructCopyWith<Struct, Struct, Struct> get copyWith =>
      _StructCopyWithImpl<Struct, Struct>(this as Struct, $identity, $identity);
  @override
  String toString() {
    return StructMapper.ensureInitialized().stringifyValue(this as Struct);
  }

  @override
  bool operator ==(Object other) {
    return StructMapper.ensureInitialized().equalsValue(this as Struct, other);
  }

  @override
  int get hashCode {
    return StructMapper.ensureInitialized().hashValue(this as Struct);
  }
}

extension StructValueCopy<$R, $Out> on ObjectCopyWith<$R, Struct, $Out> {
  StructCopyWith<$R, Struct, $Out> get $asStruct =>
      $base.as((v, t, t2) => _StructCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StructCopyWith<$R, $In extends Struct, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Variable, VariableCopyWith<$R, Variable, Variable>>
  get variables;
  ListCopyWith<
    $R,
    StructProcedure,
    StructProcedureCopyWith<$R, StructProcedure, StructProcedure>
  >
  get procedures;
  $R call({
    String? id,
    String? name,
    List<Variable>? variables,
    List<StructProcedure>? procedures,
  });
  StructCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _StructCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Struct, $Out>
    implements StructCopyWith<$R, Struct, $Out> {
  _StructCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Struct> $mapper = StructMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Variable, VariableCopyWith<$R, Variable, Variable>>
  get variables => ListCopyWith(
    $value.variables,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(variables: v),
  );
  @override
  ListCopyWith<
    $R,
    StructProcedure,
    StructProcedureCopyWith<$R, StructProcedure, StructProcedure>
  >
  get procedures => ListCopyWith(
    $value.procedures,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(procedures: v),
  );
  @override
  $R call({
    String? id,
    String? name,
    List<Variable>? variables,
    List<StructProcedure>? procedures,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (variables != null) #variables: variables,
      if (procedures != null) #procedures: procedures,
    }),
  );
  @override
  Struct $make(CopyWithData data) => Struct.mappableConstructor(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    variables: data.get(#variables, or: $value.variables),
    procedures: data.get(#procedures, or: $value.procedures),
  );

  @override
  StructCopyWith<$R2, Struct, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _StructCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VariableMapper extends ClassMapperBase<Variable> {
  VariableMapper._();

  static VariableMapper? _instance;
  static VariableMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VariableMapper._());
      NumberVariableMapper.ensureInitialized();
      NamedNumberVariableMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Variable';

  static String _$id(Variable v) => v.id;
  static const Field<Variable, String> _f$id = Field('id', _$id);
  static String _$name(Variable v) => v.name;
  static const Field<Variable, String> _f$name = Field('name', _$name);

  @override
  final MappableFields<Variable> fields = const {#id: _f$id, #name: _f$name};

  static Variable _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'Variable',
      'subclass',
      '${data.value['subclass']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Variable fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Variable>(map);
  }

  static Variable fromJson(String json) {
    return ensureInitialized().decodeJson<Variable>(json);
  }
}

mixin VariableMappable {
  String toJson();
  Map<String, dynamic> toMap();
  VariableCopyWith<Variable, Variable, Variable> get copyWith;
}

abstract class VariableCopyWith<$R, $In extends Variable, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name});
  VariableCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class StructProcedureMapper extends ClassMapperBase<StructProcedure> {
  StructProcedureMapper._();

  static StructProcedureMapper? _instance;
  static StructProcedureMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StructProcedureMapper._());
      BaseActionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'StructProcedure';

  static String _$id(StructProcedure v) => v.id;
  static const Field<StructProcedure, String> _f$id = Field('id', _$id);
  static String _$name(StructProcedure v) => v.name;
  static const Field<StructProcedure, String> _f$name = Field('name', _$name);
  static List<BaseAction> _$actions(StructProcedure v) => v.actions;
  static const Field<StructProcedure, List<BaseAction>> _f$actions = Field(
    'actions',
    _$actions,
  );

  @override
  final MappableFields<StructProcedure> fields = const {
    #id: _f$id,
    #name: _f$name,
    #actions: _f$actions,
  };

  static StructProcedure _instantiate(DecodingData data) {
    return StructProcedure.mappableConstructor(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      actions: data.dec(_f$actions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static StructProcedure fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StructProcedure>(map);
  }

  static StructProcedure fromJson(String json) {
    return ensureInitialized().decodeJson<StructProcedure>(json);
  }
}

mixin StructProcedureMappable {
  String toJson() {
    return StructProcedureMapper.ensureInitialized()
        .encodeJson<StructProcedure>(this as StructProcedure);
  }

  Map<String, dynamic> toMap() {
    return StructProcedureMapper.ensureInitialized().encodeMap<StructProcedure>(
      this as StructProcedure,
    );
  }

  StructProcedureCopyWith<StructProcedure, StructProcedure, StructProcedure>
  get copyWith =>
      _StructProcedureCopyWithImpl<StructProcedure, StructProcedure>(
        this as StructProcedure,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return StructProcedureMapper.ensureInitialized().stringifyValue(
      this as StructProcedure,
    );
  }

  @override
  bool operator ==(Object other) {
    return StructProcedureMapper.ensureInitialized().equalsValue(
      this as StructProcedure,
      other,
    );
  }

  @override
  int get hashCode {
    return StructProcedureMapper.ensureInitialized().hashValue(
      this as StructProcedure,
    );
  }
}

extension StructProcedureValueCopy<$R, $Out>
    on ObjectCopyWith<$R, StructProcedure, $Out> {
  StructProcedureCopyWith<$R, StructProcedure, $Out> get $asStructProcedure =>
      $base.as((v, t, t2) => _StructProcedureCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StructProcedureCopyWith<$R, $In extends StructProcedure, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, BaseAction, BaseActionCopyWith<$R, BaseAction, BaseAction>>
  get actions;
  $R call({String? id, String? name, List<BaseAction>? actions});
  StructProcedureCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _StructProcedureCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, StructProcedure, $Out>
    implements StructProcedureCopyWith<$R, StructProcedure, $Out> {
  _StructProcedureCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<StructProcedure> $mapper =
      StructProcedureMapper.ensureInitialized();
  @override
  ListCopyWith<$R, BaseAction, BaseActionCopyWith<$R, BaseAction, BaseAction>>
  get actions => ListCopyWith(
    $value.actions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(actions: v),
  );
  @override
  $R call({String? id, String? name, List<BaseAction>? actions}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (actions != null) #actions: actions,
    }),
  );
  @override
  StructProcedure $make(CopyWithData data) =>
      StructProcedure.mappableConstructor(
        id: data.get(#id, or: $value.id),
        name: data.get(#name, or: $value.name),
        actions: data.get(#actions, or: $value.actions),
      );

  @override
  StructProcedureCopyWith<$R2, StructProcedure, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _StructProcedureCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NumberVariableMapper extends SubClassMapperBase<NumberVariable> {
  NumberVariableMapper._();

  static NumberVariableMapper? _instance;
  static NumberVariableMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NumberVariableMapper._());
      VariableMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'NumberVariable';

  static String _$id(NumberVariable v) => v.id;
  static const Field<NumberVariable, String> _f$id = Field('id', _$id);
  static String _$name(NumberVariable v) => v.name;
  static const Field<NumberVariable, String> _f$name = Field('name', _$name);
  static Rational _$startValue(NumberVariable v) => v.startValue;
  static const Field<NumberVariable, Rational> _f$startValue = Field(
    'startValue',
    _$startValue,
  );
  static Rational _$value(NumberVariable v) => v.value;
  static const Field<NumberVariable, Rational> _f$value = Field(
    'value',
    _$value,
  );

  @override
  final MappableFields<NumberVariable> fields = const {
    #id: _f$id,
    #name: _f$name,
    #startValue: _f$startValue,
    #value: _f$value,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'NumberVariable';
  @override
  late final ClassMapperBase superMapper = VariableMapper.ensureInitialized();

  static NumberVariable _instantiate(DecodingData data) {
    return NumberVariable.mappableConstructor(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      startValue: data.dec(_f$startValue),
      value: data.dec(_f$value),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NumberVariable fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NumberVariable>(map);
  }

  static NumberVariable fromJson(String json) {
    return ensureInitialized().decodeJson<NumberVariable>(json);
  }
}

mixin NumberVariableMappable {
  String toJson() {
    return NumberVariableMapper.ensureInitialized().encodeJson<NumberVariable>(
      this as NumberVariable,
    );
  }

  Map<String, dynamic> toMap() {
    return NumberVariableMapper.ensureInitialized().encodeMap<NumberVariable>(
      this as NumberVariable,
    );
  }

  NumberVariableCopyWith<NumberVariable, NumberVariable, NumberVariable>
  get copyWith => _NumberVariableCopyWithImpl<NumberVariable, NumberVariable>(
    this as NumberVariable,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return NumberVariableMapper.ensureInitialized().stringifyValue(
      this as NumberVariable,
    );
  }

  @override
  bool operator ==(Object other) {
    return NumberVariableMapper.ensureInitialized().equalsValue(
      this as NumberVariable,
      other,
    );
  }

  @override
  int get hashCode {
    return NumberVariableMapper.ensureInitialized().hashValue(
      this as NumberVariable,
    );
  }
}

extension NumberVariableValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NumberVariable, $Out> {
  NumberVariableCopyWith<$R, NumberVariable, $Out> get $asNumberVariable =>
      $base.as((v, t, t2) => _NumberVariableCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NumberVariableCopyWith<$R, $In extends NumberVariable, $Out>
    implements VariableCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? name, Rational? startValue, Rational? value});
  NumberVariableCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _NumberVariableCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NumberVariable, $Out>
    implements NumberVariableCopyWith<$R, NumberVariable, $Out> {
  _NumberVariableCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NumberVariable> $mapper =
      NumberVariableMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, Rational? startValue, Rational? value}) =>
      $apply(
        FieldCopyWithData({
          if (id != null) #id: id,
          if (name != null) #name: name,
          if (startValue != null) #startValue: startValue,
          if (value != null) #value: value,
        }),
      );
  @override
  NumberVariable $make(CopyWithData data) => NumberVariable.mappableConstructor(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    startValue: data.get(#startValue, or: $value.startValue),
    value: data.get(#value, or: $value.value),
  );

  @override
  NumberVariableCopyWith<$R2, NumberVariable, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NumberVariableCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NamedNumberVariableMapper
    extends SubClassMapperBase<NamedNumberVariable> {
  NamedNumberVariableMapper._();

  static NamedNumberVariableMapper? _instance;
  static NamedNumberVariableMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NamedNumberVariableMapper._());
      VariableMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'NamedNumberVariable';

  static String _$id(NamedNumberVariable v) => v.id;
  static const Field<NamedNumberVariable, String> _f$id = Field('id', _$id);
  static String _$name(NamedNumberVariable v) => v.name;
  static const Field<NamedNumberVariable, String> _f$name = Field(
    'name',
    _$name,
  );
  static String _$typeId(NamedNumberVariable v) => v.typeId;
  static const Field<NamedNumberVariable, String> _f$typeId = Field(
    'typeId',
    _$typeId,
  );
  static String _$startValue(NamedNumberVariable v) => v.startValue;
  static const Field<NamedNumberVariable, String> _f$startValue = Field(
    'startValue',
    _$startValue,
  );
  static String _$value(NamedNumberVariable v) => v.value;
  static const Field<NamedNumberVariable, String> _f$value = Field(
    'value',
    _$value,
  );

  @override
  final MappableFields<NamedNumberVariable> fields = const {
    #id: _f$id,
    #name: _f$name,
    #typeId: _f$typeId,
    #startValue: _f$startValue,
    #value: _f$value,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'NamedNumberVariable';
  @override
  late final ClassMapperBase superMapper = VariableMapper.ensureInitialized();

  static NamedNumberVariable _instantiate(DecodingData data) {
    return NamedNumberVariable.mappableConstructor(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      typeId: data.dec(_f$typeId),
      startValue: data.dec(_f$startValue),
      value: data.dec(_f$value),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NamedNumberVariable fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NamedNumberVariable>(map);
  }

  static NamedNumberVariable fromJson(String json) {
    return ensureInitialized().decodeJson<NamedNumberVariable>(json);
  }
}

mixin NamedNumberVariableMappable {
  String toJson() {
    return NamedNumberVariableMapper.ensureInitialized()
        .encodeJson<NamedNumberVariable>(this as NamedNumberVariable);
  }

  Map<String, dynamic> toMap() {
    return NamedNumberVariableMapper.ensureInitialized()
        .encodeMap<NamedNumberVariable>(this as NamedNumberVariable);
  }

  NamedNumberVariableCopyWith<
    NamedNumberVariable,
    NamedNumberVariable,
    NamedNumberVariable
  >
  get copyWith =>
      _NamedNumberVariableCopyWithImpl<
        NamedNumberVariable,
        NamedNumberVariable
      >(this as NamedNumberVariable, $identity, $identity);
  @override
  String toString() {
    return NamedNumberVariableMapper.ensureInitialized().stringifyValue(
      this as NamedNumberVariable,
    );
  }

  @override
  bool operator ==(Object other) {
    return NamedNumberVariableMapper.ensureInitialized().equalsValue(
      this as NamedNumberVariable,
      other,
    );
  }

  @override
  int get hashCode {
    return NamedNumberVariableMapper.ensureInitialized().hashValue(
      this as NamedNumberVariable,
    );
  }
}

extension NamedNumberVariableValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NamedNumberVariable, $Out> {
  NamedNumberVariableCopyWith<$R, NamedNumberVariable, $Out>
  get $asNamedNumberVariable => $base.as(
    (v, t, t2) => _NamedNumberVariableCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class NamedNumberVariableCopyWith<
  $R,
  $In extends NamedNumberVariable,
  $Out
>
    implements VariableCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? id,
    String? name,
    String? typeId,
    String? startValue,
    String? value,
  });
  NamedNumberVariableCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _NamedNumberVariableCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NamedNumberVariable, $Out>
    implements NamedNumberVariableCopyWith<$R, NamedNumberVariable, $Out> {
  _NamedNumberVariableCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NamedNumberVariable> $mapper =
      NamedNumberVariableMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? name,
    String? typeId,
    String? startValue,
    String? value,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (typeId != null) #typeId: typeId,
      if (startValue != null) #startValue: startValue,
      if (value != null) #value: value,
    }),
  );
  @override
  NamedNumberVariable $make(CopyWithData data) =>
      NamedNumberVariable.mappableConstructor(
        id: data.get(#id, or: $value.id),
        name: data.get(#name, or: $value.name),
        typeId: data.get(#typeId, or: $value.typeId),
        startValue: data.get(#startValue, or: $value.startValue),
        value: data.get(#value, or: $value.value),
      );

  @override
  NamedNumberVariableCopyWith<$R2, NamedNumberVariable, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _NamedNumberVariableCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

