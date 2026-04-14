import 'package:graph_vn/editor/named_value_expression/constant_named_value_expression.dart';
import 'package:graph_vn/editor/named_value_expression/named_value_expression.dart';

class FirstMatchConditionItem {
  NamedValueExpression expression = ConstantNamedValueExpression();
  FirstMatchResult action = FirstMatchResult.pass;
}

enum FirstMatchResult {
  pass, fail;
}