import 'package:rational/rational.dart';
import 'package:uuid/uuid.dart';

class Struct {
  String id = Uuid().v4();
  String name = "";
  List<Variable> variables = List.empty(growable: true);
}

class Variable {
  String id = Uuid().v4();
  String name = "";
  Rational startValue = Rational.zero;
  Rational value = Rational.zero;
}