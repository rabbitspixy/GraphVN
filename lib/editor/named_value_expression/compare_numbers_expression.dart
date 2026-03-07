import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:graph_vn/editor/widgets/editor_rich_text.dart';
import 'package:graph_vn/editor/modals/enum_selector.dart';
import 'package:graph_vn/editor/named_value_expression/named_value_expression.dart';
import 'package:graph_vn/editor/number_expression/constant_number_expression.dart';
import 'package:graph_vn/editor/number_expression/number_expression.dart';
import 'package:graph_vn/editor/modals/number_expression_editor.dart';
import 'package:graph_vn/editor/variables.dart';

part 'compare_numbers_expression.mapper.dart';

@MappableClass()
class CompareNumbersExpression extends NamedValueExpression with CompareNumbersExpressionMappable {
  NumberExpression left = ConstantNumberExpression();
  BooleanOperator operator = BooleanOperator.equal;
  NumberExpression right = ConstantNumberExpression();

  CompareNumbersExpression();

  @MappableConstructor()
  CompareNumbersExpression.mappableConstructor({
    required this.left,
    required this.operator,
    required this.right,
  }) : super.mappableConstructor();

  @override
  String evaluate() {
    if (evaluateAsBoolean()) {
      return PredefinedNamedTypes.booleanTrue.id;
    } else {
      return PredefinedNamedTypes.booleanFalse.id;
    }
  }

  bool evaluateAsBoolean() {
    return switch(operator) {
      BooleanOperator.equal => left.evaluate() == right.evaluate(),
      BooleanOperator.notEqual => left.evaluate() != right.evaluate(),
      BooleanOperator.greater => left.evaluate() > right.evaluate(),
      BooleanOperator.greaterOrEqual => left.evaluate() >= right.evaluate(),
      BooleanOperator.less => left.evaluate() < right.evaluate(),
      BooleanOperator.lessOrEqual => left.evaluate() <= right.evaluate(),
    };
  }

  @override
  String asText() {
    return "Is ${left.asText()} ${operator.str} ${right.asText()}?";
  }

  @override
  bool isValid() {
    return true;
  }

  @override
  Widget widgetEditor() {
    return BooleanNumberExpressionEditor(expression: this);
  }
}

@MappableEnum()
enum BooleanOperator {
  equal('equal'),
  notEqual('not equal'),
  greater('greater than'),
  greaterOrEqual('greater or equal'),
  less('less than'),
  lessOrEqual('less or equal');

  final String str;

  const BooleanOperator(this.str);
}

class BooleanNumberExpressionEditor extends StatefulWidget {
  final CompareNumbersExpression expression;
  const BooleanNumberExpressionEditor({super.key, required this.expression});

  @override
  State<BooleanNumberExpressionEditor> createState() => _BooleanNumberExpressionEditorState();
}

class _BooleanNumberExpressionEditorState extends State<BooleanNumberExpressionEditor> {
  @override
  Widget build(BuildContext context) {
    return EditorRichText([
      ETextSpan(text: 'Is'),
      ETextSpan(
        text: widget.expression.left.asText(),
        tap: () async {
          final newExpression = await editNumberExpression(context, widget.expression.left);
          if (newExpression != null) {
            widget.expression.left = newExpression;
            setState(() {});
          }
        }
      ),
      ETextSpan(
        text: widget.expression.operator.str,
        tap: () async {
          final newOperator = await showEnumSelector(context, BooleanOperator.values, (v) => v.str);
          if (newOperator != null) {
            widget.expression.operator = newOperator;
            setState(() {});
          }
        }
      ),
      ETextSpan(
        text: widget.expression.right.asText(),
        tap: () async {
          final newExpression = await editNumberExpression(context, widget.expression.right);
          if (newExpression != null) {
            widget.expression.right = newExpression;
            setState(() {});
          }
        }
      ),
    ]);
  }
}