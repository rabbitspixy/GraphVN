import 'package:graph_vn/editor/actions/base.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:rational/rational.dart';
import 'package:uuid/uuid.dart';

class Struct {
  String id = Uuid().v4();
  String name = "";
  List<Variable> variables = List.empty(growable: true);
  List<StructProcedure> procedures = List.empty(growable: true);

  Struct();

  Variable? variableById(String id) {
    return variables.where((v) => v.id == id).firstOrNull;
  }

  StructProcedure? procedureById(String id) {
    return procedures.where((x) => x.id == id).firstOrNull;
  }

  StructProto toProto() {
    final result = StructProto();
    result.id = id;
    result.name = name;
    result.variables.addAll(variables.map((x) => x.toProto()));
    result.procedures.addAll(procedures.map((x) => x.toProto()));
    return result;
  }

  factory Struct.fromProto(StructProto proto) {
    final result = Struct();
    result.id = proto.id;
    result.name = proto.name;
    result.variables.addAll(proto.variables.map((x) => Variable.fromProto(x)));
    result.procedures.addAll(proto.procedures.map((x) => StructProcedure.fromProto(x)));
    return result;
  }
}

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

  Variable();

  void reset();
  String initialValueAsText();
  String currentValueAsText();

  VariableProto toProto();
  factory Variable.fromProto(VariableProto proto) {
    return switch (proto.whichType()) {
      VariableProto_Type.numberVariable => NumberVariable.fromProto(proto.numberVariable),
      VariableProto_Type.namedVariable => NamedVariable.fromProto(proto.namedVariable),
      _ => throw UnimplementedError()
    };
  }
}

class NumberVariable extends Variable {
  Rational initialValue = Rational.zero;
  Rational value = Rational.zero;

  NumberVariable();

  @override
  void reset() {
    value = initialValue;
  }

  @override
  String initialValueAsText() {
    return initialValue.toString();
  }

  @override
  String currentValueAsText() {
    return value.toString();
  }

  @override
  VariableProto toProto() {
    final result = NumberVariableProto();
    result.id = id;
    result.name = name;
    result.initialValue = initialValue.toString();
    result.value = value.toString();
    return VariableProto()
      ..numberVariable = result;
  }

  factory NumberVariable.fromProto(NumberVariableProto proto) {
    final result = NumberVariable();
    result.id = proto.id;
    result.name = proto.name;
    result.initialValue = Rational.parse(proto.initialValue);
    result.value = Rational.parse(proto.value);
    return result;
  }
}

class NamedVariable extends Variable {
  String typeId;
  String initialValue = '';
  String value = '';

  @override
  void reset() {
    value = initialValue;
  }

  NamedVariable({required this.typeId}) {
    final type = namedVariableTypes.where((v) => v.id == typeId).firstOrNull;
    if (type != null) {
      initialValue = type.list.first.id;
      value = initialValue;
    }
  }

  @override
  String initialValueAsText() {
    return EditorState.namedValue(initialValue)?.name ?? "?";
  }

  @override
  String currentValueAsText() {
    return EditorState.namedValue(value)?.name ?? "?";
  }

  @override
  VariableProto toProto() {
    final result = NamedVariableProto();
    result.id = id;
    result.name = name;
    result.typeId = typeId;
    result.initialValue = initialValue;
    result.value = value;
    return VariableProto()
        ..namedVariable = result;
  }

  factory NamedVariable.fromProto(NamedVariableProto proto) {
    final result = NamedVariable(typeId: proto.typeId);
    result.id = proto.id;
    result.name = proto.name;
    result.initialValue = proto.initialValue;
    result.value = proto.value;
    return result;
  }
}

enum VariableType {
  number(type: NumberVariable),
  namedNumber(type: NamedVariable)
  ;

  const VariableType({required this.type});

  final Type type;
}

class StructProcedure {
  String id = Uuid().v4();
  String name = "Unnamed procedure";
  List<BaseAction> actions = List.empty(growable: true);

  StructProcedure();

  void exec() {
    for (final action in actions) {
      action.exec();
    }
  }

  StructProcedureProto toProto() {
    final result = StructProcedureProto();
    result.id = id;
    result.name = name;
    result.actions.addAll(actions.map((x) => x.toProto()));
    return result;
  }

  factory StructProcedure.fromProto(StructProcedureProto proto) {
    final result = StructProcedure();
    result.id = proto.id;
    result.name = proto.name;
    result.actions = [ for (var a in proto.actions) BaseAction.fromProto(a) ];
    return result;
  }
}