import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graph_vn/player/player.dart';

class AnimatedNarrativeText extends StatefulWidget {
  const AnimatedNarrativeText({super.key});

  @override
  State<AnimatedNarrativeText> createState() => _AnimatedNarrativeTextState();
}

class _AnimatedNarrativeTextState extends State<AnimatedNarrativeText> {
  String _displayedText = '';
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer?.cancel();
    _displayedText = '';
    _currentIndex = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      final fullText = Player.narrativeText.value;
      if (_currentIndex < fullText.length) {
        setState(() {
          _displayedText += fullText[_currentIndex];
          _currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedNarrativeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (Player.narrativeText.value != _displayedText) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
      softWrap: true,
    );
  }
}
