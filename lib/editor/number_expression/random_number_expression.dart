import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:graph_vn/editor/modals/number_expression_editor.dart';
import 'package:graph_vn/editor/number_expression/constant_number_expression.dart';
import 'package:graph_vn/editor/number_expression/number_expression.dart';
import 'package:graph_vn/editor/widgets/editor_rich_text.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:indent/indent.dart';
import 'package:rational/rational.dart';

class RandomNumberExpression extends NumberExpression {
  NumberExpression from = ConstantNumberExpression.withInitialValue(Rational.fromInt(1));
  NumberExpression to = ConstantNumberExpression.withInitialValue(Rational.fromInt(20));
  NumberExpression diceCount = ConstantNumberExpression.withInitialValue(Rational.one);
  NumberExpression stepBy = ConstantNumberExpression.withInitialValue(Rational.one);

  RandomNumberExpression();

  @override
  Rational evaluate() {
    var sum = Rational.zero;
    var fromEvaluated = from.evaluate();
    var toEvaluated = to.evaluate();
    var stepByEvaluated = stepBy.evaluate();

    var maxSteps = ((toEvaluated - fromEvaluated) / stepByEvaluated).floor().toInt();

    var repeatCount = diceCount.evaluate().round().toInt();
    for (var i = 0; i < repeatCount; i++) {
      sum += fromEvaluated + Rational.fromInt(Random().nextInt(maxSteps + 1)) * stepByEvaluated;
    }

    return sum / Rational.fromInt(repeatCount);
  }

  @override
  String asText() {
    return "roll ${diceCount.asText()} dices from ${from.asText()} to ${to.asText()} divisible by ${stepBy.asText()}";
  }

  @override
  bool isValid() {
    return diceCount.evaluate() >= Rational.one && stepBy.evaluate() > Rational.zero;
  }

  @override
  Widget widgetEditor() {
    return RandomNumberExpressionEditor(expression: this);
  }

  @override
  NumberExpressionProto toProto() {
    final result = RandomNumberExpressionProto();
    result.from = from.toProto();
    result.to = to.toProto();
    result.diceCount = diceCount.toProto();
    result.stepBy = stepBy.toProto();
    return NumberExpressionProto()
      ..randomNumberExpression = result;
  }

  factory RandomNumberExpression.fromProto(RandomNumberExpressionProto proto) {
    final result = RandomNumberExpression();
    result.from = NumberExpression.fromProto(proto.from);
    result.to = NumberExpression.fromProto(proto.to);
    result.diceCount = NumberExpression.fromProto(proto.diceCount);
    result.stepBy = NumberExpression.fromProto(proto.stepBy);
    return result;
  }
}

class RandomNumberExpressionEditor extends StatefulWidget {
  final RandomNumberExpression expression;
  const RandomNumberExpressionEditor({
    super.key,
    required this.expression,
  });

  @override
  State<StatefulWidget> createState() => _RandomNumberExpressionEditorState();
}

class _RandomNumberExpressionEditorState extends State<RandomNumberExpressionEditor> {

  @override
  Widget build(BuildContext context) {
    return EditorRichText([
      ETextSpan(text: "roll"),
      ETextSpan(
        text: widget.expression.diceCount.asText(),
        tap: () async {
          final edited = await editNumberExpression(context, widget.expression.diceCount);
          if (edited != null) {
            widget.expression.diceCount = edited;
            setState(() {});
          }
        }
      ),
      ETextSpan(text: "dices from"),
      ETextSpan(
          text: widget.expression.from.asText(),
          tap: () async {
            final edited = await editNumberExpression(context, widget.expression.from);
            if (edited != null) {
              widget.expression.from = edited;
              setState(() {});
            }
          }
      ),
      ETextSpan(text: "to"),
      ETextSpan(
          text: widget.expression.to.asText(),
          tap: () async {
            final edited = await editNumberExpression(context, widget.expression.to);
            if (edited != null) {
              widget.expression.to = edited;
              setState(() {});
            }
          }
      ),
      ETextSpan(text: "divisible by"),
      ETextSpan(
          text: widget.expression.stepBy.asText(),
          tap: () async {
            final edited = await editNumberExpression(context, widget.expression.stepBy);
            if (edited != null) {
              widget.expression.stepBy = edited;
              setState(() {});
            }
          }
      ),
    ],
    tooltip: """
      from 0 to 1 step by 1 possible values - 0, 1
      from 0 to 1 step by 0.25 possible values - 0, 0.25, 0.5, 0.75, 1
      from 1 to 6 step by 2 possible values - 1, 3, 5
    """.unindent(),
    );
  }
}