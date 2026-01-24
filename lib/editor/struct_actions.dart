import 'package:flutter/gestures.dart';
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
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(text: 'Set '),
          TextSpan(text: 'variable', style: TextStyle(decoration: TextDecoration.underline), recognizer: TapGestureRecognizer()..onTap = () { print('clicked'); }),
          TextSpan(text: ' to '),
          TextSpan(text: '0', style: TextStyle(decoration: TextDecoration.underline), recognizer: TapGestureRecognizer()..onTap = () { print('clicked'); })
        ]
      ),
    );
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

enum StructActionType {
  doNothing(type: DoNothing, create: DoNothing.new, title: 'DoNothing'),
  setNumberValue(type: VariableSetNumberValue, create: VariableSetNumberValue.new, title: 'VariableSetNumberValue'),
  increaseNumberValue(type: IncreaseNumberValue, create: IncreaseNumberValue.new, title: 'IncreaseNumberValue'),
  ;

  final Type type;
  final StructAction Function() create;
  final String title;
  

  const StructActionType({
    required this.type,
    required this.create,
    required this.title,
  });
}