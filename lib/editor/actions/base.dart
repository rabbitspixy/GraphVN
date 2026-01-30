import 'package:dart_mappable/dart_mappable.dart';
import 'package:graph_vn/editor/actions/do_nothing.dart';
import 'package:graph_vn/editor/actions/increase_number_value.dart';
import 'package:graph_vn/editor/actions/rotate_named_value.dart';
import 'package:graph_vn/editor/actions/set_named_value.dart';
import 'package:graph_vn/editor/actions/set_number_value.dart';
import 'package:uuid/uuid.dart';

part 'base.mapper.dart';

@MappableClass(
  includeSubClasses: [
    DoNothing,
    IncreaseNumberValue,
    RotateNamedValue,
    SetNamedValue,
    SetNumberValue,
  ]
)
abstract class BaseAction with BaseActionMappable {
  String id = Uuid().v4();

  BaseAction();

  @MappableConstructor()
  BaseAction.mappableConstructor({
    required this.id,
  });

  String actionText();

  void exec();
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