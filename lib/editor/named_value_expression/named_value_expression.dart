import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:graph_vn/editor/named_value_expression/compare_named_value_expression.dart';
import 'package:graph_vn/editor/named_value_expression/compare_numbers_expression.dart';
import 'package:graph_vn/editor/named_value_expression/constant_named_value_expression.dart';
import 'package:graph_vn/editor/named_value_expression/named_value_of_expression.dart';

part 'named_value_expression.mapper.dart';

@MappableClass(
  includeSubClasses: [
    ConstantNamedValueExpression,
    CompareNumbersExpression,
    CompareNamedValueExpression,
    NamedValueOfExpression,
  ]
)
abstract class NamedValueExpression with NamedValueExpressionMappable {
  NamedValueExpression();

  @MappableConstructor()
  NamedValueExpression.mappableConstructor();

  String evaluate();
  String asText();
  bool isValid();
  Widget widgetEditor();
}

enum NamedExpressionType {
  constant(type: ConstantNamedValueExpression, create: ConstantNamedValueExpression.new, title: 'Constant'),
  compareNumbers(type: CompareNumbersExpression, create: CompareNumbersExpression.new, title: 'Compare numbers'),
  compareNamedValues(type: CompareNamedValueExpression, create: CompareNamedValueExpression.new, title: 'Compare named values'),
  variableValue(type: NamedValueOfExpression, create: NamedValueOfExpression.new, title: 'Value of variable'),
  ;

  final Type type;
  final NamedValueExpression Function() create;
  final String title;

  const NamedExpressionType({
    required this.type,
    required this.create,
    required this.title,
  });
}