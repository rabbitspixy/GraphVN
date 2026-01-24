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

abstract class Variable {
  String id = Uuid().v4();
  String name = "";
}

class NumberVariable extends Variable {
  String startValue = '0';
  Rational value = Rational.zero;
}

class StructProcedure {
  String id = Uuid().v4();
  String name = "";
  List<BaseAction> actions = List.empty(growable: true);
}