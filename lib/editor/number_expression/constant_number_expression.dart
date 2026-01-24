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
  final ConstantNumberExpression expression;
  final ValueChanged<bool> onValidityChanged;
  const ConstantNumberExpressionEditor({
    super.key,
    required this.expression,
    required this.onValidityChanged,
  });

  @override
  State<ConstantNumberExpressionEditor> createState() => _ConstantNumberExpressionEditorState();
}

class _ConstantNumberExpressionEditorState extends State<ConstantNumberExpressionEditor> {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.expression.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Number',
        errorText: _isValid ? null : 'Invalid number',
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      onChanged: (value) {
        try {
          final parsed = Rational.parse(value);
          widget.expression.value = parsed;
          if (!_isValid) {
            setState(() => _isValid = true);
            widget.onValidityChanged(true);
          }
        } catch (_) {
          if (_isValid) {
            setState(() => _isValid = false);
            widget.onValidityChanged(false);
          }
        }
      },
    );
  }
}
