import 'package:graph_vn/editor/struct.dart';
import 'package:graph_vn/editor/struct_actions/do_nothing.dart';
import 'package:graph_vn/editor/struct_actions/increase_number_value.dart';
import 'package:graph_vn/editor/struct_actions/set_number_value.dart';
import 'package:uuid/uuid.dart';

abstract class StructAction {
  String id = Uuid().v4();
  Struct struct;

  StructAction({required this.struct});

  String actionText();
}

enum StructActionType {
  doNothing(type: DoNothing, create: DoNothing.new, title: 'Do nothing'),
  setNumberValue(type: SetNumberValue, create: SetNumberValue.new, title: 'Set number value'),
  increaseNumberValue(type: IncreaseNumberValue, create: IncreaseNumberValue.new, title: 'Increase number value'),
  ;

  final Type type;
  final StructAction Function(Struct struct) create;
  final String title;

  const StructActionType({
    required this.type,
    required this.create,
    required this.title,
  });
}