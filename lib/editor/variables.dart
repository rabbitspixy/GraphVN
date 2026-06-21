import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/named_variable_stringifier.dart';
import 'package:graph_vn/editor/number_variable_stringifier.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:uuid/uuid.dart';

class PredefinedNamedTypes {
  static const booleanTypeId = 'a16100bc-5afb-4e8c-b2c1-eb14e523e0d0';
  static final booleanFalse = NamedValue(id: '8e3cc0d8-dd9d-4062-951c-158c62b32e35', name: 'False');
  static final booleanTrue = NamedValue(id: '12bb0e0d-674f-4ce8-b03c-38cfe66f3040', name: 'True');
}

final namedVariableTypes = [
  NamedValuesType()
    ..id = PredefinedNamedTypes.booleanTypeId
    ..name = 'Boolean'
    ..list = [
      PredefinedNamedTypes.booleanFalse,
      PredefinedNamedTypes.booleanTrue,
    ]
];

class NamedValuesType {
  String id = Uuid().v4();
  String name = '';
  List<NamedValue> list = List.empty();
}

class NamedValue {
  String id;
  String name;

  NamedValue({
    required String? id,
    required this.name,
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
    return EditorState.valueOfVariable(this);
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

  NamedVariable({required this.typeId}) {
    final type = namedVariableTypes.where((v) => v.id == typeId).firstOrNull;
    if (type != null) {
      initialValue = type.list.first.id;
    }
  }

  @override
  String initialValueAsText() {
    return EditorState.namedValue(initialValue)?.name ?? "?";
  }

  @override
  String currentValueAsText() {
    return EditorState.valueOfVariable(this);
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
    final result = NamedVariable(typeId: proto.typeId);
    result.id = proto.id;
    result.name = proto.name;
    result.initialValue = proto.initialValue;
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