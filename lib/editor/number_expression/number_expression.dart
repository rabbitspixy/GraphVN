import 'package:dart_mappable/dart_mappable.dart';
import 'package:graph_vn/editor/number_expression/constant_number_expression.dart';
import 'package:rational/rational.dart';

part 'number_expression.mapper.dart';

@MappableClass(
  discriminatorKey: 'subclass',
  includeSubClasses: [
    ConstantNumberExpression,
  ]
)
abstract class NumberExpression with NumberExpressionMappable {

  NumberExpression();

  @MappableConstructor()
  NumberExpression.mappableConstructor();
  
  Rational evaluate();
  String asString();
  bool isValid();
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