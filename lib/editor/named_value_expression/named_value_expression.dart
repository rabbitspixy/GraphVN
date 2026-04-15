import 'package:flutter/material.dart';
import 'package:graph_vn/editor/named_value_expression/compare_named_value_expression.dart';
import 'package:graph_vn/editor/named_value_expression/compare_numbers_expression.dart';
import 'package:graph_vn/editor/named_value_expression/constant_named_value_expression.dart';
import 'package:graph_vn/editor/named_value_expression/value_of_named_value_variable_expression.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';

abstract class NamedValueExpression {
  NamedValueExpression();

  String evaluate();

  String asText();

  bool isValid();

  Widget widgetEditor();

  NamedValueExpressionProto toProto();

  factory NamedValueExpression.fromProto(NamedValueExpressionProto proto) {
    return switch(proto.whichType()) {
      NamedValueExpressionProto_Type.constantNamedValueExpression => ConstantNamedValueExpression.fromProto(proto.constantNamedValueExpression),
      NamedValueExpressionProto_Type.compareNumbersExpression => CompareNumbersExpression.fromProto(proto.compareNumbersExpression),
      NamedValueExpressionProto_Type.compareNamedValueExpression => CompareNamedValueExpression.fromProto(proto.compareNamedValueExpression),
      NamedValueExpressionProto_Type.valueOfNamedValueVariableExpression => ValueOfNamedValueVariableExpression.fromProto(proto.valueOfNamedValueVariableExpression),
      NamedValueExpressionProto_Type.notSet => throw Exception("NamedValueExpressionProto type is not set"),
    };
  }
}

enum NamedValueExpressionType {
  constant(
    type: ConstantNamedValueExpression,
    create: ConstantNamedValueExpression.new,
    title: 'Constant',
  ),
  variableValue(
    type: ValueOfNamedValueVariableExpression,
    create: ValueOfNamedValueVariableExpression.new,
    title: 'Value of variable',
  ),
  compareNumbers(
    type: CompareNumbersExpression,
    create: CompareNumbersExpression.new,
    title: 'Compare numbers',
  ),
  compareNamedValues(
    type: CompareNamedValueExpression,
    create: CompareNamedValueExpression.new,
    title: 'Compare named values',
  ),
  ;

  final Type type;
  final NamedValueExpression Function() create;
  final String title;

  const NamedValueExpressionType({
    required this.type,
    required this.create,
    required this.title,
  });

  static NamedValueExpressionType of(NamedValueExpression expression) {
    return values.singleWhere((item) => item.type == expression.runtimeType);
  }
}
