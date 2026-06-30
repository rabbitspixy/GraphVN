import 'package:flutter/material.dart';

class TransitionPosition {
  Offset start;
  Offset end;
  Offset control;
  Offset center;
  double direction;

  TransitionPosition({
    required this.start,
    required this.end,
    required this.control,
    required this.center,
    required this.direction,
  });
}