import 'package:flutter/material.dart';
import 'package:graph_vn/editor/number_expression/number_expression.dart';
import 'package:graph_vn/editor/rational_util.dart';
import 'package:rational/rational.dart';

class ConstantNumberExpression extends NumberExpression {

  Rational value = Rational.zero;
  bool _isValid = true;

  @override
  Rational evaluate() {
    return value;
  }

  @override
  String asString() {
    return value.toString();
  }

  @override
  bool isValid() {
    return _isValid;
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
