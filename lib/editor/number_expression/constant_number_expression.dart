import 'package:flutter/material.dart';
import 'package:graph_vn/editor/number_expression/number_expression.dart';
import 'package:graph_vn/common/rational_util.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:rational/rational.dart';

class ConstantNumberExpression extends NumberExpression {

  Rational value = Rational.zero;
  bool _isValid = true;

  ConstantNumberExpression();

  @override
  Rational evaluate() {
    return value;
  }

  @override
  String asText() {
    return value.toString();
  }

  @override
  bool isValid() {
    return _isValid;
  }

  @override
  Widget widgetEditor() {
    return ConstantNumberExpressionEditor(expression: this);
  }

  @override
  NumberExpressionProto toProto() {
    final result = ConstantNumberExpressionProto();
    result.value = value.toString();
    return NumberExpressionProto()
      ..constantNumberExpression = result;
  }

  factory ConstantNumberExpression.fromProto(ConstantNumberExpressionProto proto) {
    final result = ConstantNumberExpression();
    result.value = Rational.parse(proto.value);
    return result;
  }
}

class ConstantNumberExpressionEditor extends StatefulWidget {
  final ConstantNumberExpression expression;
  const ConstantNumberExpressionEditor({
    super.key,
    required this.expression,
  });

  @override
  State<ConstantNumberExpressionEditor> createState() => _ConstantNumberExpressionEditorState();
}

class _ConstantNumberExpressionEditorState extends State<ConstantNumberExpressionEditor> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.expression.value.toString();
  }

  bool isValid() {
    return isValidNumber(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Number',
        errorText: isValidNumber(_controller.text) ? null : 'Invalid number',
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      onChanged: (value) {
        final parsed = Rational.tryParse(value);
        widget.expression._isValid = isValid();
        if (parsed != null) {
          widget.expression.value = parsed;
        }
        setState(() {});
      },
    );
  }
}
