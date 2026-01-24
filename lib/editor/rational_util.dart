import 'package:rational/rational.dart';

bool isValidNumber(String text) {
  final parsed = Rational.tryParse(text);
  return parsed != null;
}