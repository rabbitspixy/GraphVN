import 'package:rational/rational.dart';
import 'package:uuid/uuid.dart';

abstract class StructAction {
  String id = Uuid().v4();

  String actionText();
}

class VariableSetNumberValue extends StructAction {
  String structId = "";
  String variableId = "";
  Rational newValue = Rational.zero;


  @override
  String actionText() {
    return "Установить значение";
  }
}