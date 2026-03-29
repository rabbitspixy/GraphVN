import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:graph_vn/editor/widgets/editor_rich_text.dart';
import 'package:graph_vn/editor/modals/enum_selector.dart';
import 'package:graph_vn/editor/named_value_expression/constant_named_value_expression.dart';
import 'package:graph_vn/editor/modals/named_number_expression_editor.dart';
import 'package:graph_vn/editor/named_value_expression/named_value_expression.dart';
import 'package:graph_vn/editor/variables.dart';

part 'package:graph_vn/generated/editor/named_value_expression/compare_named_value_expression.mapper.dart';

@MappableClass()
class CompareNamedValueExpression extends NamedValueExpression with CompareNamedValueExpressionMappable {
  NamedValueExpression left = ConstantNamedValueExpression();
  CompareNamedValueOperator operator = CompareNamedValueOperator.equal;
  NamedValueExpression right = ConstantNamedValueExpression();
  
  
  CompareNamedValueExpression();

  @MappableConstructor()
  CompareNamedValueExpression.mappableConstructor({
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
      CompareNamedValueOperator.equal => left.evaluate() == right.evaluate(),
      CompareNamedValueOperator.notEqual => left.evaluate() != right.evaluate(),
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
    return BooleanNamedValueExpressionEditor(expression: this);
  }
}

@MappableEnum()
enum CompareNamedValueOperator {
  equal('equal'),
  notEqual('not equal');

  final String str;

  const CompareNamedValueOperator(this.str);
}

class BooleanNamedValueExpressionEditor extends StatefulWidget {
  final CompareNamedValueExpression expression;
  const BooleanNamedValueExpressionEditor({super.key, required this.expression});

  @override
  State<BooleanNamedValueExpressionEditor> createState() => _BooleanNamedValueExpressionEditorState();
}

class _BooleanNamedValueExpressionEditorState extends State<BooleanNamedValueExpressionEditor> {
  @override
  Widget build(BuildContext context) {
    return EditorRichText([
      ETextSpan(text: 'Is'),
      ETextSpan(
        text: widget.expression.left.asText(),
        tap: () async {
          final newExpression = await editNamedValueExpression(context, widget.expression.left);
          if (newExpression != null) {
            widget.expression.left = newExpression;
            setState(() {});
          }
        }
      ),
      ETextSpan(
        text: widget.expression.operator.str,
        tap: () async {
          final newOperator = await showEnumSelector(context, CompareNamedValueOperator.values, (v) => v.str);
          if (newOperator != null) {
            widget.expression.operator = newOperator;
            setState(() {});
          }
        }
      ),
      ETextSpan(
        text: widget.expression.right.asText(),
        tap: () async {
          final newExpression = await editNamedValueExpression(context, widget.expression.right);
          if (newExpression != null) {
            widget.expression.right = newExpression;
            setState(() {});
          }
        }
      ),
    ]);
  }
}