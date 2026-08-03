import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:graph_vn/main.dart';

void jsTest() async {
  try {
    _test();
  } catch (e, st) {
    logger.e("JS interpreter does not work correctly", error: e, stackTrace: st);
    exit(0);
  }
}

void _test() {
  WidgetsFlutterBinding.ensureInitialized();
  final jsRuntime = getJavascriptRuntime();

  jsRuntime.evaluate("var myState = 10;");
  _mustBeTrue(jsRuntime.evaluate("myState").stringResult == "10");

  jsRuntime.evaluate("myState += 2;");
  _mustBeTrue(jsRuntime.evaluate("myState").stringResult == "12");

  final errorEvalResult = jsRuntime.evaluate('3 = a');
  _mustBeTrue(errorEvalResult.isError);

  final trueEvalResult = jsRuntime.evaluate("function returnTrue() { return true; }\nreturnTrue();");
  _mustBeTrue(trueEvalResult.stringResult == "true");
  _mustBeTrue(trueEvalResult.rawResult == true);
  _mustBeTrue(trueEvalResult.rawResult.runtimeType == bool);

  final falseEvalResult = jsRuntime.evaluate("function returnFalse() { return false; }\nreturnFalse();");
  _mustBeTrue(falseEvalResult.stringResult == "false");
  _mustBeTrue(falseEvalResult.rawResult == false);
  _mustBeTrue(falseEvalResult.rawResult.runtimeType == bool);
}

void _mustBeTrue(bool value) {
  if (!value) {
    throw Exception("JS interpreter does not work correctly");
  }
}