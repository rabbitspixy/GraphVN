import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:graph_vn/editor/number_expression/constant_number_expression.dart';
import 'package:graph_vn/editor/number_expression/number_variable_value.dart';
import 'package:rational/rational.dart';

part 'number_expression.mapper.dart';

@MappableClass(
  includeSubClasses: [
    ConstantNumberExpression,
    NumberVariableValue,
  ]
)
abstract class NumberExpression with NumberExpressionMappable {

  NumberExpression();

  @MappableConstructor()
  NumberExpression.mappableConstructor();
  
  Rational evaluate();
  String asText();
  bool isValid();
  Widget widgetEditor();
}

enum NumberExpressionType {
  constant(type: ConstantNumberExpression, create: ConstantNumberExpression.new, title: 'Constant'),
  numberValue(type: NumberVariableValue, create: NumberVariableValue.new, title: 'Value of number variable')
  ;

  final Type type;
  final NumberExpression Function() create;
  final String title;

  const NumberExpressionType({
    required this.type,
    required this.create,
    required this.title,
  });
}