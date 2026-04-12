import 'package:rational/rational.dart';

class NumberVariableStringifier {
  Rational rangeStart = Rational.fromInt(0);
  Rational rangeEnd = Rational.fromInt(0);
  String template = "{}";

  NumberVariableStringifier({
    required this.rangeStart,
    required this.rangeEnd,
    required this.template,
  });

  String? evaluate(Rational value) {
    if (value <= rangeEnd && value >= rangeStart) {
      return template.replaceAll("{}", value.toDouble().toString());
    }
    return null;
  }
}