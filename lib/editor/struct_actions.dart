import 'package:graph_vn/editor/editor_rich_text.dart';
import 'package:rational/rational.dart';
import 'package:uuid/uuid.dart';

abstract class StructAction {
  String id = Uuid().v4();
  String structId = "";

  EditorRichText edit();

  String actionText();
}

class DoNothing extends StructAction {

  @override
  edit() {
    return EditorRichText([
      ETextSpan(text: 'Do nothing')
    ]);
  }

  @override
  String actionText() {
    return edit().toSimpleText();
  }
}

class SetNumberValue extends StructAction {
  String variableId = "";
  Rational newValue = Rational.zero;

  @override
  edit() {
    return EditorRichText([
      ETextSpan(text: 'Set'),
      ETextSpan(text: 'variable', tap: () {}),
      ETextSpan(text: 'to'),
      ETextSpan(text: '0', tap: () {})
    ]);
  }

  @override
  String actionText() {
    return edit().toSimpleText();
  }
}

class IncreaseNumberValue extends StructAction {
  String variableId = "";
  Rational increaseValue = Rational.zero;

  @override
  edit() {
    return EditorRichText([
      ETextSpan(text: 'Increase'),
      ETextSpan(text: 'variable', tap: () {}),
      ETextSpan(text: 'by'),
      ETextSpan(text: '0', tap: () {})
    ]);
  }

  @override
  String actionText() {
    return edit().toSimpleText();
  }
}

enum StructActionType {
  doNothing(type: DoNothing, create: DoNothing.new, title: 'Do nothing'),
  setNumberValue(type: SetNumberValue, create: SetNumberValue.new, title: 'Set number value'),
  increaseNumberValue(type: IncreaseNumberValue, create: IncreaseNumberValue.new, title: 'Increase number value'),
  ;

  final Type type;
  final StructAction Function() create;
  final String title;
  

  const StructActionType({
    required this.type,
    required this.create,
    required this.title,
  });
}