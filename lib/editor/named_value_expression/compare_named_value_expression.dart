import 'package:flutter/material.dart';
import 'package:graph_vn/editor/widgets/editor_rich_text.dart';
import 'package:graph_vn/editor/modals/enum_selector.dart';
import 'package:graph_vn/editor/named_value_expression/constant_named_value_expression.dart';
import 'package:graph_vn/editor/modals/named_value_expression_editor.dart';
import 'package:graph_vn/editor/named_value_expression/named_value_expression.dart';
import 'package:graph_vn/editor/variables.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';

class CompareNamedValueExpression extends NamedValueExpression {
  NamedValueExpression left = ConstantNamedValueExpression();
  CompareNamedValueOperator operator = CompareNamedValueOperator.equal;
  NamedValueExpression right = ConstantNamedValueExpression();
  
  
  CompareNamedValueExpression();

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
    return "${left.asText()} ${operator.str} ${right.asText()}";
  }

  @override
  bool isValid() {
    return true;
  }

  @override
  Widget widgetEditor() {
    return BooleanNamedValueExpressionEditor(expression: this);
  }

  @override
  NamedValueExpressionProto toProto() {
    final result = CompareNamedValueExpressionProto();
    result.left = left.toProto();
    result.operator = operator.name;
    result.right = right.toProto();
    return NamedValueExpressionProto()
      ..compareNamedValueExpression = result;
  }

  factory CompareNamedValueExpression.fromProto(CompareNamedValueExpressionProto proto) {
    final result = CompareNamedValueExpression();
    result.left = NamedValueExpression.fromProto(proto.left);
    result.operator = CompareNamedValueOperator.values.byName(proto.operator);
    result.right = NamedValueExpression.fromProto(proto.right);
    return result;
  }
}

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