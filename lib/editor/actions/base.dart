import 'package:graph_vn/editor/actions/do_nothing.dart';
import 'package:graph_vn/editor/actions/increase_number_value.dart';
import 'package:graph_vn/editor/actions/set_named_value.dart';
import 'package:graph_vn/editor/actions/set_number_value.dart';
import 'package:uuid/uuid.dart';

abstract class BaseAction {
  String id = Uuid().v4();

  String actionText();

  void exec();
}

enum StructActionType {
  doNothing(type: DoNothing, create: DoNothing.new, title: 'Do nothing'),
  setNumberValue(type: SetNumberValue, create: SetNumberValue.new, title: 'Set number value'),
  setNamedValue(type: SetNamedValue, create: SetNamedValue.new, title: 'Set named value'),
  increaseNumberValue(type: IncreaseNumberValue, create: IncreaseNumberValue.new, title: 'Increase number value'),
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