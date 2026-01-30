import 'package:dart_mappable/dart_mappable.dart';
import 'package:graph_vn/editor/named_number_expression/compare_numbers_expression.dart';
import 'package:graph_vn/editor/named_number_expression/constant_named_number_expression.dart';

part 'named_number_expression.mapper.dart';

@MappableClass(
  includeSubClasses: [
    ConstantNamedNumberExpression,
    CompareNumbersExpression,
  ]
)
abstract class NamedNumberExpression with NamedNumberExpressionMappable {
  String namedNumbersTypeId;

  NamedNumberExpression({required this.namedNumbersTypeId});

  @MappableConstructor()
  NamedNumberExpression.mappableConstructor({
    required this.namedNumbersTypeId,
  });

  String evaluate();
  String asString();
  bool isValid();
}

enum NamedNumberExpressionType {
  constant(type: ConstantNamedNumberExpression, create: ConstantNamedNumberExpression.new, title: 'Constant'),
  compareNumbers(type: CompareNumbersExpression, create: CompareNumbersExpression.new, title: 'Compare numbers'),
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