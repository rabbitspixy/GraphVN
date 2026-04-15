import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graph_vn/player/components.dart';
import 'package:graph_vn/player/player.dart';

class TransitionButtons extends StatefulWidget {
  final List<ChoiseButton> transitions;
  const TransitionButtons({super.key, required this.transitions});

  @override
  State<TransitionButtons> createState() => _TransitionButtonsState();
}

class _TransitionButtonsState extends State<TransitionButtons> {
  late List<ChoiseButton> _transitions;
  late double _opacity;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _transitions = widget.transitions;
    _opacity = 0.0;
    _startFadeIn();
  }

  @override
  void didUpdateWidget(covariant TransitionButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transitions != widget.transitions) {
      _timer?.cancel();
      // Immediately remove current buttons
      setState(() {
        _transitions = [];
        _opacity = 0.0;
      });
      // After 0.5s, show new buttons fully opaque
      _timer = Timer(const Duration(milliseconds: 450), () {
        setState(() {
          _transitions = widget.transitions;
          _opacity = 0.0;
        });
        // After another 0.5s, fade out new buttons
        _timer = Timer(const Duration(milliseconds: 100), () {
          setState(() {
            _opacity = 1.0;
          });
        });
      });
    }
  }

  void _startFadeIn() {
    _timer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_transitions.length, (index) {
        final transition = _transitions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 500),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(183, 21, 19, 43),
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color.fromARGB(223, 206, 206, 206)),
                elevation: 0,
              ),
              onPressed: () => Player.updateState(useTransition: transition.transitionId),
              child: Text(transition.text),
            ),
          ),
        );
      }),
    );
  }
}
