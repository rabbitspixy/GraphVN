import 'package:dart_mappable/dart_mappable.dart';
import 'package:rational/rational.dart';

class RationalMapper extends SimpleMapper<Rational> {
  const RationalMapper();
  
  @override
  Rational decode(dynamic value) {
    return Rational.parse(value as String);
  }
  
  @override
  dynamic encode(Rational self) {
    return self.toString();
  }
}