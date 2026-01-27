import 'dart:math';

import 'package:graph_vn/editor/editor_transition.dart';

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

EditorTransition? selectRandomTransition(List<EditorTransition> transitions) {
  if (transitions.isEmpty) {
    return null;
  }
  final totalWeight = transitions.fold(0, (sum, t) => sum + t.weight);
  if (totalWeight <= 0) {
    return null;
  }
  final rand = Random().nextDouble() * totalWeight;
  double cumulative = 0;
  for (final t in transitions) {
    cumulative += t.weight;
    if (rand < cumulative) {
      return t;
    }
  }
  return transitions.last;
}
