import 'package:dart_mappable/dart_mappable.dart';
import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:rational/rational.dart';
import 'package:uuid/uuid.dart';

part 'variables.mapper.dart';

@MappableClass()
class Struct with StructMappable {
  String id = Uuid().v4();
  String name = "";
  List<Variable> variables = List.empty(growable: true);
  List<StructProcedure> procedures = List.empty(growable: true);

  Struct();

  @MappableConstructor()
  Struct.mappableConstructor({
    required this.id,
    required this.name,
    required this.variables,
    required this.procedures,
  });

  Variable? variableById(String id) {
    return variables.where((v) => v.id == id).firstOrNull;
  }

  StructProcedure? procedureById(String id) {
    return procedures.where((x) => x.id == id).firstOrNull;
  }
}

class PredefinedNamedTypes {
  static const booleanTypeId = 'a16100bc-5afb-4e8c-b2c1-eb14e523e0d0';
  static final booleanFalse = NamedValue(id: '8e3cc0d8-dd9d-4062-951c-158c62b32e35', name: 'False');
  static final booleanTrue = NamedValue(id: '12bb0e0d-674f-4ce8-b03c-38cfe66f3040', name: 'True');
}

final namedVariableTypes = [
  NamedValuesType()
    ..id = PredefinedNamedTypes.booleanTypeId
    ..name = 'Boolean'
    ..list = [
      PredefinedNamedTypes.booleanFalse,
      PredefinedNamedTypes.booleanTrue,
    ]
];

class NamedValuesType {
  String id = Uuid().v4();
  String name = '';
  List<NamedValue> list = List.empty();
}

@MappableClass()
class NamedValue with NamedValueMappable {
  String id;
  String name;

  NamedValue({
    required String? id,
    required this.name,
  }) : id = id ?? Uuid().v4();
}

@MappableClass()
abstract class Variable with VariableMappable {
  String id = Uuid().v4();
  String name = "";

  Variable();

  @MappableConstructor()
  Variable.mappableConstructor({
    required this.id,
    required this.name,
  });

  void reset();
  String initialValueAsText();
  String currentValueAsText();
}

@MappableClass()
class NumberVariable extends Variable with NumberVariableMappable {
  Rational initialValue = Rational.zero;
  Rational value = Rational.zero;

  NumberVariable();

  @MappableConstructor()
  NumberVariable.mappableConstructor({
    required super.id,
    required super.name,
    required this.initialValue,
    required this.value,
  }) : super.mappableConstructor();

  @override
  void reset() {
    value = initialValue;
  }

  @override
  String initialValueAsText() {
    return initialValue.toString();
  }

  @override
  String currentValueAsText() {
    return value.toString();
  }
}

@MappableClass()
class NamedVariable extends Variable with NamedVariableMappable {
  String typeId;
  String initialValue = '';
  String value = '';

  @override
  void reset() {
    value = initialValue;
  }

  NamedVariable({required this.typeId}) {
    final type = namedVariableTypes.where((v) => v.id == typeId).firstOrNull;
    if (type != null) {
      initialValue = type.list.first.id;
      value = initialValue;
    }
  }

  @MappableConstructor()
  NamedVariable.mappableConstructor({
    required super.id,
    required super.name,
    required this.typeId,
    required this.initialValue,
    required this.value,
  }) : super.mappableConstructor();

  @override
  String initialValueAsText() {
    return EditorState.namedValue(typeId, initialValue)?.name ?? "?";
  }

  @override
  String currentValueAsText() {
    return EditorState.namedValue(typeId, value)?.name ?? "?";
  }
}

enum VariableType {
  number(type: NumberVariable),
  namedNumber(type: NamedVariable)
  ;

  const VariableType({required this.type});

  final Type type;
}

@MappableClass()
class StructProcedure with StructProcedureMappable {
  String id = Uuid().v4();
  String name = "Unnamed procedure";
  List<BaseAction> actions = List.empty(growable: true);

  StructProcedure();

  @MappableConstructor()
  StructProcedure.mappableConstructor({
    required this.id,
    required this.name,
    required this.actions,
  });

  void exec() {
    for (final action in actions) {
      action.exec();
    }
  }
}