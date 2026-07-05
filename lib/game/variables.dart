import 'package:graph_vn/common/js_util.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:uuid/uuid.dart';

class NamedValuesType {
  String id = Uuid().v4();
  String name = '';
  List<NamedValue> values = List.empty(growable: true);

  NamedValuesType();

  void addValue(String name) {
    if (values.where((x) => x.name == name).isNotEmpty) {
      //TODO: Отобразить сообщение с ошибкой, что такое имя уже используется
      return;
    }
    values.add(NamedValue(id: Uuid().v4(), name: name, description: ''));
  }

  NamedValueTypeProto toProto() {
    final result = NamedValueTypeProto();
    result.id = id;
    result.name = name;
    result.values.addAll(values.map((x) => x.toProto()));
    return result;
  }

  factory NamedValuesType.fromProto(NamedValueTypeProto proto) {
    final result = NamedValuesType();
    result.id = proto.id;
    result.name = proto.name;
    result.values.addAll([for (var v in proto.values) NamedValue.fromProto(v)]);
    return result;
  }
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

  NamedValueProto toProto() {
    final result = NamedValueProto();
    result.id = id;
    result.name = name;
    result.description = description;
    return result;
  }

  factory NamedValue.fromProto(NamedValueProto proto) {
    return NamedValue(
      id: proto.id,
      name: proto.name,
      description: proto.description,
    );
  }
}

abstract class Variable {
  String id = Uuid().v4();
  String name = "";
  String description = "";

  Variable();

  String initialValueAsText();
  String initialValueAsJsCode(); //TODO: escape js string
  String currentValueAsText();

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

  NumberVariable();

  @override
  String initialValueAsText() {
    return initialValue.toString();
  }

  @override
  String initialValueAsJsCode() {
    return initialValue.toString();
  }

  @override
  String currentValueAsText() {
    return GameState.valueOfVariable(this);
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

  NamedVariable({
    required this.typeId,
    required this.initialValue
  });

  @override
  String initialValueAsText() {
    return GameState.namedValueTypes.findValueById(initialValue)?.name ?? "?";
  }

  @override
  String initialValueAsJsCode() {
    return toJsString(GameState.namedValueTypes.findValueById(initialValue)?.name ?? "null");
  }

  @override
  String currentValueAsText() {
    return GameState.valueOfVariable(this);
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