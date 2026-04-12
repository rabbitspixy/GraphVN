import 'package:flutter/material.dart';
import 'package:graph_vn/editor/number_expression/constant_number_expression.dart';
import 'package:graph_vn/editor/number_expression/number_variable_value.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:rational/rational.dart';

abstract class NumberExpression {

  NumberExpression();
  
  Rational evaluate();
  String asText();
  bool isValid();
  Widget widgetEditor();

  NumberExpressionProto toProto();

  factory NumberExpression.fromProto(NumberExpressionProto proto) {
    return switch(proto.whichType()) {
      NumberExpressionProto_Type.constantNumberExpression => ConstantNumberExpression.fromProto(proto.constantNumberExpression),
      NumberExpressionProto_Type.numberVariableValue => NumberVariableValue.fromProto(proto.numberVariableValue),
      _ => throw UnimplementedError()
    };
  }
}

enum NumberExpressionType {
  constant(type: ConstantNumberExpression, create: ConstantNumberExpression.new, title: 'Constant'),
  variableValue(type: NumberVariableValue, create: NumberVariableValue.new, title: 'Value of variable'),
  ;

  final Type type;
  final NumberExpression Function() create;
  final String title;

  const NumberExpressionType({
    required this.type,
    required this.create,
    required this.title,
  });

  static NumberExpressionType of(NumberExpression expression) {
    return values.singleWhere((item) => item.type == expression.runtimeType);
  }
}