class NumberVariableStringifier {
  int rangeStart = 0;
  int rangeEnd = 0;
  String template = "{}";

  NumberVariableStringifier({
    required this.rangeStart,
    required this.rangeEnd,
    required this.template,
  });

  String? evaluate(int value) {
    if (value <= rangeEnd && value >= rangeStart) {
      return template.replaceAll("{}", value.toDouble().toString());
    }
    return null;
  }
}