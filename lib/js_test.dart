import 'package:flutter_js/flutter_js.dart';

void jsTest() async {
  // 1. Создаем рантайм
  final jsRuntime = getJavascriptRuntime();

  // Выполняем код
  jsRuntime.evaluate("var myState = 10;");
  print("Значение из JS: ${jsRuntime.evaluate("myState").stringResult}");
  jsRuntime.evaluate("myState += 2;");
  print("Значение из JS: ${jsRuntime.evaluate("myState").stringResult}");
}