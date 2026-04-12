import 'package:graph_vn/editor/actions/do_nothing.dart';
import 'package:graph_vn/editor/actions/increase_number_value.dart';
import 'package:graph_vn/editor/actions/rotate_named_value.dart';
import 'package:graph_vn/editor/actions/set_named_value.dart';
import 'package:graph_vn/editor/actions/set_number_value.dart';
import 'package:graph_vn/generated-proto/data.pb.dart';
import 'package:uuid/uuid.dart';

abstract class BaseAction {
  String id = Uuid().v4();

  BaseAction();

  String actionText();

  void exec();

  AbstractActionProto toProto();

  factory BaseAction.fromProto(AbstractActionProto proto) {
    final result = switch(proto.whichType()) {
      AbstractActionProto_Type.doNothing => DoNothing.fromProto(proto.doNothing),
      AbstractActionProto_Type.increaseNumberValue => IncreaseNumberValue.fromProto(proto.increaseNumberValue),
      AbstractActionProto_Type.rotateNamedValue => RotateNamedValue.fromProto(proto.rotateNamedValue),
      AbstractActionProto_Type.setNamedValue => SetNamedValue.fromProto(proto.setNamedValue),
      AbstractActionProto_Type.setNumberValue => SetNumberValue.fromProto(proto.setNumberValue),
      _ => throw UnimplementedError()
    };
    result.id = proto.id;
    return result;
  }
}

enum StructActionType {
  doNothing(type: DoNothing, create: DoNothing.new, title: 'Do nothing'),
  setNumberValue(type: SetNumberValue, create: SetNumberValue.new, title: 'Set number value'),
  setNamedValue(type: SetNamedValue, create: SetNamedValue.new, title: 'Set named value'),
  increaseNumberValue(type: IncreaseNumberValue, create: IncreaseNumberValue.new, title: 'Increase number value'),
  rotateNamedValue(type: RotateNamedValue, create: RotateNamedValue.new, title: 'Rotate named value'),
  ;

  final Type type;
  final BaseAction Function() create;
  final String title;

  const StructActionType({
    required this.type,
    required this.create,
    required this.title,
  });
}