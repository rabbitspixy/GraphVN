import 'package:flutter/material.dart';
import 'package:rational/rational.dart';
import 'package:uuid/uuid.dart';

abstract class StructAction {
  String id = Uuid().v4();
  String structId = "";

  Widget edit();

  String actionText();
}

class DoNothing extends StructAction {

  @override
  Widget edit() {
    return Text("Not implemented");
  }

  @override
  String actionText() {
    return "Ничего не делать";
  }
}

class VariableSetNumberValue extends StructAction {
  String variableId = "";
  Rational newValue = Rational.zero;

  @override
  Widget edit() {
    return Text("Not implemented");
  }

  @override
  String actionText() {
    return "Установить значение";
  }
}

class IncreaseNumberValue extends StructAction {
  String variableId = "";
  Rational increaseValue = Rational.zero;

  @override
  Widget edit() {
    return Text("Not implemented");
  }

  @override
  String actionText() {
    return "Увеличить значение";
  }
}