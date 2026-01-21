import 'package:graph_vn/editor/struct_actions.dart';
import 'package:rational/rational.dart';
import 'package:uuid/uuid.dart';

class Struct {
  String id = Uuid().v4();
  String name = "";
  List<Variable> variables = List.empty(growable: true);
  List<StructProcedure> procedures = List.empty(growable: true);
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
  List<StructAction> actions = List.empty(growable: true);
}