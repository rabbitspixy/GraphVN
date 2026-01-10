import 'dart:math';

double random(double from, double to) {
  return from + Random().nextDouble() * (to - from);
}

T randomChoise<T>(List<T> items) {
  if (items.isEmpty) {
    throw ArgumentError('Cannot choose from an empty list');
  }
  final index = Random().nextInt(items.length);
  return items[index];
}
