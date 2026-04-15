import 'package:graph_vn/editor/named_value_expression/named_value_expression.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';

class FirstMatchConditionItem {
  NamedValueExpression expression;
  FirstMatchResult result;

  FirstMatchConditionItem({
    required this.expression,
    required this.result,
  });

  String asText() {
    return "${result.name} if\n${expression.asText()}";
  }

  FirstMatchConditionItemProto toProto() {
    final result = FirstMatchConditionItemProto();
    result.expression = expression.toProto();
    result.result = this.result.name;
    return result;
  }

  factory FirstMatchConditionItem.fromProto(FirstMatchConditionItemProto proto) {
    return FirstMatchConditionItem(
      expression: NamedValueExpression.fromProto(proto.expression),
      result: FirstMatchResult.values.byName(proto.result),
    );
  }
}

enum FirstMatchResult {
  pass, fail;
}