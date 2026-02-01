import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:graph_vn/editor/named_value_expression/compare_numbers_expression.dart';
import 'package:graph_vn/editor/named_value_expression/constant_named_value_expression.dart';

part 'named_value_expression.mapper.dart';

@MappableClass(
  includeSubClasses: [
    ConstantNamedValueExpression,
    CompareNumbersExpression,
  ]
)
abstract class NamedValueExpression with NamedValueExpressionMappable {
  String namedNumbersTypeId;

  NamedValueExpression({required this.namedNumbersTypeId});

  @MappableConstructor()
  NamedValueExpression.mappableConstructor({
    required this.namedNumbersTypeId,
  });

  String evaluate();
  String asText();
  bool isValid();
  Widget widgetEditor();
}

enum NamedExpressionType {
  constant(type: ConstantNamedValueExpression, create: ConstantNamedValueExpression.new, title: 'Constant'),
  compareNumbers(type: CompareNumbersExpression, create: CompareNumbersExpression.new, title: 'Compare numbers'),
  ;

  final Type type;
  final NamedValueExpression Function({required String namedNumbersTypeId}) create;
  final String title;

  const NamedExpressionType({
    required this.type,
    required this.create,
    required this.title,
  });
}