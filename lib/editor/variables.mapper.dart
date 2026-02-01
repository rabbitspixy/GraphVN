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
      NamedVariableMapper.ensureInitialized();
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

class NamedValueMapper extends ClassMapperBase<NamedValue> {
  NamedValueMapper._();

  static NamedValueMapper? _instance;
  static NamedValueMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NamedValueMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'NamedValue';

  static String _$id(NamedValue v) => v.id;
  static const Field<NamedValue, String> _f$id = Field('id', _$id);
  static String _$name(NamedValue v) => v.name;
  static const Field<NamedValue, String> _f$name = Field('name', _$name);

  @override
  final MappableFields<NamedValue> fields = const {#id: _f$id, #name: _f$name};

  static NamedValue _instantiate(DecodingData data) {
    return NamedValue(id: data.dec(_f$id), name: data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static NamedValue fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NamedValue>(map);
  }

  static NamedValue fromJson(String json) {
    return ensureInitialized().decodeJson<NamedValue>(json);
  }
}

mixin NamedValueMappable {
  String toJson() {
    return NamedValueMapper.ensureInitialized().encodeJson<NamedValue>(
      this as NamedValue,
    );
  }

  Map<String, dynamic> toMap() {
    return NamedValueMapper.ensureInitialized().encodeMap<NamedValue>(
      this as NamedValue,
    );
  }

  NamedValueCopyWith<NamedValue, NamedValue, NamedValue> get copyWith =>
      _NamedValueCopyWithImpl<NamedValue, NamedValue>(
        this as NamedValue,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return NamedValueMapper.ensureInitialized().stringifyValue(
      this as NamedValue,
    );
  }

  @override
  bool operator ==(Object other) {
    return NamedValueMapper.ensureInitialized().equalsValue(
      this as NamedValue,
      other,
    );
  }

  @override
  int get hashCode {
    return NamedValueMapper.ensureInitialized().hashValue(this as NamedValue);
  }
}

extension NamedValueValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NamedValue, $Out> {
  NamedValueCopyWith<$R, NamedValue, $Out> get $asNamedValue =>
      $base.as((v, t, t2) => _NamedValueCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NamedValueCopyWith<$R, $In extends NamedValue, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name});
  NamedValueCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _NamedValueCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NamedValue, $Out>
    implements NamedValueCopyWith<$R, NamedValue, $Out> {
  _NamedValueCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NamedValue> $mapper =
      NamedValueMapper.ensureInitialized();
  @override
  $R call({Object? id = $none, String? name}) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (name != null) #name: name,
    }),
  );
  @override
  NamedValue $make(CopyWithData data) => NamedValue(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
  );

  @override
  NamedValueCopyWith<$R2, NamedValue, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NamedValueCopyWithImpl<$R2, $Out2>($value, $cast, t);
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
  static Rational _$initialValue(NumberVariable v) => v.initialValue;
  static const Field<NumberVariable, Rational> _f$initialValue = Field(
    'initialValue',
    _$initialValue,
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
    #initialValue: _f$initialValue,
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
      initialValue: data.dec(_f$initialValue),
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
  $R call({String? id, String? name, Rational? initialValue, Rational? value});
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
  $R call({
    String? id,
    String? name,
    Rational? initialValue,
    Rational? value,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (initialValue != null) #initialValue: initialValue,
      if (value != null) #value: value,
    }),
  );
  @override
  NumberVariable $make(CopyWithData data) => NumberVariable.mappableConstructor(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    initialValue: data.get(#initialValue, or: $value.initialValue),
    value: data.get(#value, or: $value.value),
  );

  @override
  NumberVariableCopyWith<$R2, NumberVariable, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NumberVariableCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NamedVariableMapper extends SubClassMapperBase<NamedVariable> {
  NamedVariableMapper._();

  static NamedVariableMapper? _instance;
  static NamedVariableMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NamedVariableMapper._());
      VariableMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'NamedVariable';

  static String _$id(NamedVariable v) => v.id;
  static const Field<NamedVariable, String> _f$id = Field('id', _$id);
  static String _$name(NamedVariable v) => v.name;
  static const Field<NamedVariable, String> _f$name = Field('name', _$name);
  static String _$typeId(NamedVariable v) => v.typeId;
  static const Field<NamedVariable, String> _f$typeId = Field(
    'typeId',
    _$typeId,
  );
  static String _$initialValue(NamedVariable v) => v.initialValue;
  static const Field<NamedVariable, String> _f$initialValue = Field(
    'initialValue',
    _$initialValue,
  );
  static String _$value(NamedVariable v) => v.value;
  static const Field<NamedVariable, String> _f$value = Field('value', _$value);

  @override
  final MappableFields<NamedVariable> fields = const {
    #id: _f$id,
    #name: _f$name,
    #typeId: _f$typeId,
    #initialValue: _f$initialValue,
    #value: _f$value,
  };

  @override
  final String discriminatorKey = 'subclass';
  @override
  final dynamic discriminatorValue = 'NamedVariable';
  @override
  late final ClassMapperBase superMapper = VariableMapper.ensureInitialized();

  static NamedVariable _instantiate(DecodingData data) {
    return NamedVariable.mappableConstructor(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      typeId: data.dec(_f$typeId),
      initialValue: data.dec(_f$initialValue),
      value: data.dec(_f$value),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NamedVariable fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NamedVariable>(map);
  }

  static NamedVariable fromJson(String json) {
    return ensureInitialized().decodeJson<NamedVariable>(json);
  }
}

mixin NamedVariableMappable {
  String toJson() {
    return NamedVariableMapper.ensureInitialized().encodeJson<NamedVariable>(
      this as NamedVariable,
    );
  }

  Map<String, dynamic> toMap() {
    return NamedVariableMapper.ensureInitialized().encodeMap<NamedVariable>(
      this as NamedVariable,
    );
  }

  NamedVariableCopyWith<NamedVariable, NamedVariable, NamedVariable>
  get copyWith => _NamedVariableCopyWithImpl<NamedVariable, NamedVariable>(
    this as NamedVariable,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return NamedVariableMapper.ensureInitialized().stringifyValue(
      this as NamedVariable,
    );
  }

  @override
  bool operator ==(Object other) {
    return NamedVariableMapper.ensureInitialized().equalsValue(
      this as NamedVariable,
      other,
    );
  }

  @override
  int get hashCode {
    return NamedVariableMapper.ensureInitialized().hashValue(
      this as NamedVariable,
    );
  }
}

extension NamedVariableValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NamedVariable, $Out> {
  NamedVariableCopyWith<$R, NamedVariable, $Out> get $asNamedVariable =>
      $base.as((v, t, t2) => _NamedVariableCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NamedVariableCopyWith<$R, $In extends NamedVariable, $Out>
    implements VariableCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? id,
    String? name,
    String? typeId,
    String? initialValue,
    String? value,
  });
  NamedVariableCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _NamedVariableCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NamedVariable, $Out>
    implements NamedVariableCopyWith<$R, NamedVariable, $Out> {
  _NamedVariableCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NamedVariable> $mapper =
      NamedVariableMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? name,
    String? typeId,
    String? initialValue,
    String? value,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (typeId != null) #typeId: typeId,
      if (initialValue != null) #initialValue: initialValue,
      if (value != null) #value: value,
    }),
  );
  @override
  NamedVariable $make(CopyWithData data) => NamedVariable.mappableConstructor(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    typeId: data.get(#typeId, or: $value.typeId),
    initialValue: data.get(#initialValue, or: $value.initialValue),
    value: data.get(#value, or: $value.value),
  );

  @override
  NamedVariableCopyWith<$R2, NamedVariable, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NamedVariableCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

