import 'package:graph_vn/editor/actions/base.dart';
import 'package:rational/rational.dart';
import 'package:uuid/uuid.dart';

class Struct {
  String id = Uuid().v4();
  String name = "";
  List<Variable> variables = List.empty(growable: true);
  List<StructProcedure> procedures = List.empty(growable: true);

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

abstract class Variable {
  String id = Uuid().v4();
  String name = "";

  String initialValueAsString();
  String currentValueAsString();
}

class NumberVariable extends Variable {
  Rational startValue = Rational.zero;
  Rational value = Rational.zero;

  @override
  String initialValueAsString() {
    return startValue.toString();
  }

  @override
  String currentValueAsString() {
    return value.toString();
  }
}

class NamedNumberVariable extends Variable {
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

class StructProcedure {
  String id = Uuid().v4();
  String name = "Unnamed procedure";
  List<BaseAction> actions = List.empty(growable: true);

  void exec() {
    for (final action in actions) {
      action.exec();
    }
  }
}