import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/game/named_variable_stringifier.dart';
import 'package:graph_vn/game/number_variable_stringifier.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:uuid/uuid.dart';

class NamedValuesType {
  String id = Uuid().v4();
  String name = '';
  List<NamedValue> list = List.empty(growable: true);
}

class NamedValue {
  String id;
  String name;
  String description;

  NamedValue({
    required String? id,
    required this.name,
    required this.description,
  }) : id = id ?? Uuid().v4();
}

abstract class Variable {
  String id = Uuid().v4();
  String name = "";
  String description = "";

  Variable();

  String initialValueAsText();
  String currentValueAsText();
  String? currentValueAsTextForPlayer();

  VariableProto toProto();
  factory Variable.fromProto(VariableProto proto) {
    return switch (proto.whichType()) {
      VariableProto_Type.numberVariable => NumberVariable.fromProto(proto.numberVariable),
      VariableProto_Type.namedVariable => NamedVariable.fromProto(proto.namedVariable),
      VariableProto_Type.notSet => throw Exception("VariableProto type is not set"),
    };
  }
}

class NumberVariable extends Variable {
  int initialValue = 0;
  List<NumberVariableStringifier> stringifiers = [];

  NumberVariable();

  @override
  String initialValueAsText() {
    return initialValue.toString();
  }

  @override
  String currentValueAsText() {
    return GameState.valueOfVariable(this);
  }

  @override
  String? currentValueAsTextForPlayer() {
    for (final stringifier in stringifiers) {
      final result = stringifier.evaluate(int.parse(currentValueAsText()));
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  @override
  VariableProto toProto() {
    final result = NumberVariableProto();
    result.id = id;
    result.name = name;
    result.initialValue = initialValue.toString();
    result.description = description;
    return VariableProto()
      ..numberVariable = result;
  }

  factory NumberVariable.fromProto(NumberVariableProto proto) {
    final result = NumberVariable();
    result.id = proto.id;
    result.name = proto.name;
    result.initialValue = int.parse(proto.initialValue);
    result.description = proto.description;
    return result;
  }
}

class NamedVariable extends Variable {
  String typeId;
  String initialValue = '';
  List<NamedVariableStringifier> stringifiers = [];

  NamedVariable({
    required this.typeId,
    required this.initialValue
  });

  @override
  String initialValueAsText() {
    return GameState.namedValueTypes.findValueById(initialValue)?.name ?? "?";
  }

  @override
  String currentValueAsText() {
    return GameState.valueOfVariable(this);
  }

  @override
  String? currentValueAsTextForPlayer() {
    // TODO: implement
    // for (final stringifier in stringifiers) {
    //   final result = stringifier.evaluate(value);
    //   if (result != null) {
    //     return result;
    //   }
    // }
    return null;
  }

  @override
  VariableProto toProto() {
    final result = NamedVariableProto();
    result.id = id;
    result.name = name;
    result.typeId = typeId;
    result.initialValue = initialValue;
    result.description = description;
    return VariableProto()
        ..namedVariable = result;
  }

  factory NamedVariable.fromProto(NamedVariableProto proto) {
    final result = NamedVariable(
        typeId: proto.typeId,
        initialValue: proto.initialValue
    );
    result.id = proto.id;
    result.name = proto.name;
    result.description = proto.description;
    return result;
  }
}

enum VariableType {
  number(type: NumberVariable),
  namedValue(type: NamedVariable)
  ;

  const VariableType({required this.type});

  final Type type;
}