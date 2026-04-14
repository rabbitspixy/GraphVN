import 'package:graph_vn/editor/named_value_expression/named_value_expression.dart';

class FirstMatchConditionItem {
  NamedValueExpression expression;
  FirstMatchResult action;

  FirstMatchConditionItem({
    required this.expression,
    required this.action,
  });

  String asText() {
    return "${action.name} if ${expression.asText()}";
  }
}

enum FirstMatchResult {
  pass, fail;
}