import 'package:graph_vn/editor/number_expression/constant_number_expression.dart';
import 'package:rational/rational.dart';

abstract class NumberExpression {
  Rational evaluate();
  String asString();
}

enum NumberExpressionType {
  constant(type: ConstantNumberExpression, create: ConstantNumberExpression.new, title: 'Constant'),
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