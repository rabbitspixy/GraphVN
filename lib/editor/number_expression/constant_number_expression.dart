import 'package:flutter/material.dart';
import 'package:graph_vn/editor/number_expression/number_expression.dart';
import 'package:rational/rational.dart';

class ConstantNumberExpression extends NumberExpression {

  Rational value = Rational.zero;

  @override
  Rational evaluate() {
    return value;
  }

  @override
  String asString() {
    return value.toString();
  }
}

class ConstantNumberExpressionEditor extends StatefulWidget {
  const ConstantNumberExpressionEditor({super.key});

  @override
  State<ConstantNumberExpressionEditor> createState() => _ConstantNumberExpressionEditorState();
}

class _ConstantNumberExpressionEditorState extends State<ConstantNumberExpressionEditor> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}