class NamedVariableStringifier {
  String typeId = "";
  String valueId = "";
  String template = "";

  NamedVariableStringifier({
    required this.valueId,
    required this.template,
    required this.typeId,
  });

  String? evaluate(String valueId) {
    if (this.valueId == valueId) {
      return template;
    }
    return null;
  }
}