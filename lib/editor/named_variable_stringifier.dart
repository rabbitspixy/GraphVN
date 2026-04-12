class NamedVariableStringifier {
  String valueId = "";
  String template = "";

  String? evaluate(String valueId) {
    if (this.valueId == valueId) {
      return template;
    }
    return null;
  }
}