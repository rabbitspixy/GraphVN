import 'package:dart_mappable/dart_mappable.dart';

String toJsString(String str) {
  return MapperContainer.globals.toJson(str);
}