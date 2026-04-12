class NamedVariableStringifier {
  String valueId = "";
  String template = "";

  NamedVariableStringifier({
    required this.valueId,
    required this.template,
  });

  String? evaluate(String valueId) {
    if (this.valueId == valueId) {
      return template;
    }
    return null;
  }
}