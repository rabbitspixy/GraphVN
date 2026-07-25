import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graph_vn/player/player.dart';

class AnimatedNarrativeText extends StatefulWidget {
  final VoidCallback? onTextFinished;
  const AnimatedNarrativeText({super.key, this.onTextFinished});

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
    Player.narrativeVersion.addListener(_startAnimation);
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
        widget.onTextFinished?.call();
      }
    });
  }


  @override
  void dispose() {
    Player.narrativeVersion.removeListener(_startAnimation);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Text(
        _displayedText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.normal,
          shadows: [
            Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Colors.black
            )
          ]
        ),
        textAlign: TextAlign.left,
        softWrap: true,
      ),
    );
  }
}
