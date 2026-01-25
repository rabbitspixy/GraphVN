import 'package:graph_vn/editor/named_number_expression/constant_named_number_expression.dart';

abstract class NamedNumberExpression {
  String namedNumbersTypeId;

  NamedNumberExpression({required this.namedNumbersTypeId});

  String evaluate();
  String asString();
  bool isValid();
}

enum NamedNumberExpressionType {
  constant(type: ConstantNamedNumberExpression, create: ConstantNamedNumberExpression.new, title: 'Constant')
  ;

  final Type type;
  final NamedNumberExpression Function({required String namedNumbersTypeId}) create;
  final String title;

  const NamedNumberExpressionType({
    required this.type,
    required this.create,
    required this.title,
  });
}