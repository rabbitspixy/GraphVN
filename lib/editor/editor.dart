import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:touch_of_the_unknown/editor/editor_state.dart';
import 'package:touch_of_the_unknown/editor/editor_transition.dart';
import 'package:touch_of_the_unknown/editor/transition_painter.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  Offset _offset = Offset.zero;
  Offset? _dragStart;
  Offset? _offsetStart;
  bool _dragging = false;

  void _onPointerDown(PointerDownEvent event) {
    if (event.buttons & kMiddleMouseButton != 0) {
      _dragStart = event.position;
      _offsetStart = _offset;
      _dragging = true;
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_dragging && _dragStart != null && _offsetStart != null) {
      final delta = event.position - _dragStart!;
      setState(() {
        _offset = _offsetStart! + delta;
      });
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_dragging) {
      _dragging = false;
      _dragStart = null;
      _offsetStart = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      behavior: HitTestBehavior.translucent,
      child: SizedBox.expand(
        child: Stack(
          children: [
            ValueListenableBuilder<List<EditorTransition>>(
              valueListenable: EditorState.transitionsNotifier,
              builder: (context, _, __) => CustomPaint(
                painter: TransitionPainter(offset: _offset),
              ),
            ),
            ...EditorState.nodes.values.map((node) {
              final left = node.x.toDouble() - 5 + _offset.dx;
              final top = node.y.toDouble() - 5 + _offset.dy;
              return Positioned(
                left: left,
                top: top,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
