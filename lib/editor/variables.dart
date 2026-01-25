import 'package:dart_mappable/dart_mappable.dart';
import 'package:graph_vn/editor/actions/base.dart';
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
}

final namedNumbersTypes = [
  NamedNumbersType()
    ..id = 'a16100bc-5afb-4e8c-b2c1-eb14e523e0d0'
    ..name = 'Boolean'
    ..list = [MapEntry('False', Rational.zero), MapEntry('True', Rational.one)]
];

class NamedNumbersType {
  String id = Uuid().v4();
  String name = '';
  List<MapEntry<String, Rational>> list = List.empty();
}

@MappableClass(discriminatorKey: 'subclass')
abstract class Variable with VariableMappable {
  String id = Uuid().v4();
  String name = "";

  Variable();

  @MappableConstructor()
  Variable.mappableConstructor({
    required this.id,
    required this.name,
  });

  String initialValueAsString();
  String currentValueAsString();
}

@MappableClass(discriminatorValue: 'NumberVariable')
class NumberVariable extends Variable with NumberVariableMappable {
  Rational startValue = Rational.zero;
  Rational value = Rational.zero;

  NumberVariable();

  @MappableConstructor()
  NumberVariable.mappableConstructor({
    required super.id,
    required super.name,
    required this.startValue,
    required this.value,
  }) : super.mappableConstructor();

  @override
  String initialValueAsString() {
    return startValue.toString();
  }

  @override
  String currentValueAsString() {
    return value.toString();
  }
}

@MappableClass(discriminatorValue: 'NamedNumberVariable')
class NamedNumberVariable extends Variable with NamedNumberVariableMappable {
  String typeId;
  String startValue = '';
  String value = '';

  NamedNumberVariable({required this.typeId}) {
    final type = namedNumbersTypes.where((v) => v.id == typeId).firstOrNull;
    if (type != null) {
      startValue = type.list.first.key;
      value = startValue;
    }
  }

  @MappableConstructor()
  NamedNumberVariable.mappableConstructor({
    required super.id,
    required super.name,
    required this.typeId,
    required this.startValue,
    required this.value,
  }) : super.mappableConstructor();

  @override
  String initialValueAsString() {
    return startValue;
  }

  @override
  String currentValueAsString() {
    return value;
  }
}

enum VariableType {
  number(type: NumberVariable),
  namedNumber(type: NamedNumberVariable)
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