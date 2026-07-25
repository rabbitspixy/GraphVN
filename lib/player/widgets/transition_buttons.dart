import 'package:flutter/material.dart';
import 'package:graph_vn/player/player_models.dart';

class TransitionButtons extends StatefulWidget {
  final List<ChoiseButton> transitions;
  final int selectedIndex;
  final bool show;
  final ValueChanged<int> onHover;
  final ValueChanged<int> onSubmit;

  const TransitionButtons({
    super.key,
    required this.transitions,
    required this.selectedIndex,
    required this.show,
    required this.onHover,
    required this.onSubmit,
  });

  @override
  State<TransitionButtons> createState() => _TransitionButtonsState();
}

class _TransitionButtonsState extends State<TransitionButtons>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = _controller;
    if (widget.show) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(TransitionButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _controller.forward();
    } else if (!widget.show && oldWidget.show) {
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.transitions.length, (index) {
          final isSelected = index == widget.selectedIndex;
          final transition = widget.transitions[index];
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            onHover: (_) => widget.onHover(index),
            child: GestureDetector(
              onTap: () => widget.onSubmit(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '> ${transition.text}',
                  style: TextStyle(
                    color: isSelected ? Colors.lightBlue : Colors.white70,
                    fontSize: 20,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.black
                      )
                    ]
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
