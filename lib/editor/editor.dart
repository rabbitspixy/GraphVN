import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touch_of_the_unknown/editor/editor_state.dart';
import 'package:touch_of_the_unknown/editor/editor_node.dart';
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
  // Node dragging state
  String? _draggingNodeId;
  Offset? _nodeDragStart;
  Offset? _nodeOffsetStart;
  bool _nodeDragging = false;
  String? _linkingNodeId;
  Duration _lastClickTime = Duration.zero;
  Size? _lastSize;
  bool _sizeInitialized = false;

  void _onPointerDown(PointerDownEvent event) {
    // Double-click detection for creating a new node
    if (event.buttons & kPrimaryMouseButton != 0) {
      if (event.timeStamp - _lastClickTime < const Duration(milliseconds: 300)) {
        // Create new node at click position
        final localPos = event.position - _offset;
        final gridX = ((localPos.dx / 25).round() * 25);
        final gridY = ((localPos.dy / 25).round() * 25);
        final newNode = EditorNode()
          ..x = gridX
          ..y = gridY;
        EditorState.nodes[newNode.id] = newNode;
        setState(() {});
        _lastClickTime = event.timeStamp;
        return;
      }
      _lastClickTime = event.timeStamp;
    }

    // Handle node dragging with left mouse button
    if (event.buttons & kPrimaryMouseButton != 0) {
      // If Ctrl is pressed, start linking
      if (HardwareKeyboard.instance.isControlPressed) {
        for (final node in EditorState.nodes.values) {
          final left = node.x.toDouble() - 5 + _offset.dx;
          final top = node.y.toDouble() - 5 + _offset.dy;
          final rect = Rect.fromLTWH(left, top, 10, 10);
          if (rect.contains(event.position)) {
            _linkingNodeId = node.id;
            return;
          }
        }
      } else {
        for (final node in EditorState.nodes.values) {
          final left = node.x.toDouble() - 5 + _offset.dx;
          final top = node.y.toDouble() - 5 + _offset.dy;
          final rect = Rect.fromLTWH(left, top, 10, 10);
          if (rect.contains(event.position)) {
            _draggingNodeId = node.id;
            _nodeDragStart = event.position;
            _nodeOffsetStart = Offset(node.x.toDouble(), node.y.toDouble());
            _nodeDragging = true;
            return;
          }
        }
      }
    }
    // Handle canvas panning with middle mouse button
    if (_linkingNodeId == null && event.buttons & kMiddleMouseButton != 0) {
      _dragStart = event.position;
      _offsetStart = _offset;
      _dragging = true;
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_linkingNodeId == null && _nodeDragging && _draggingNodeId != null && _nodeDragStart != null && _nodeOffsetStart != null) {
      final delta = event.position - _nodeDragStart!;
      setState(() {
        final node = EditorState.nodes[_draggingNodeId!];
        if (node != null) {
          node.x = (((_nodeOffsetStart!.dx + delta.dx).round() + 12) ~/ 25) * 25;
          node.y = (((_nodeOffsetStart!.dy + delta.dy).round() + 12) ~/ 25) * 25;
        }
      });
    } else if (_dragging && _dragStart != null && _offsetStart != null) {
      final delta = event.position - _dragStart!;
      setState(() {
        _offset = _offsetStart! + delta;
      });
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_linkingNodeId != null) {
      // Find target node under pointer
      for (final node in EditorState.nodes.values) {
        final left = node.x.toDouble() - 5 + _offset.dx;
        final top = node.y.toDouble() - 5 + _offset.dy;
        final rect = Rect.fromLTWH(left, top, 10, 10);
        if (rect.contains(event.position) && node.id != _linkingNodeId) {
          // Create transition
          EditorState.transitions.add(EditorTransition()
            ..from = _linkingNodeId!
            ..to = node.id);
          EditorState.transitionsNotifier.value = List.from(EditorState.transitions);
          break;
        }
      }
      _linkingNodeId = null;
    } else if (_nodeDragging) {
      _nodeDragging = false;
      _draggingNodeId = null;
      _nodeDragStart = null;
      _nodeOffsetStart = null;
    } else if (_dragging) {
      _dragging = false;
      _dragStart = null;
      _offsetStart = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!_sizeInitialized) {
      // use the stored offset if we have one, otherwise centre
      _offset = EditorState.storedOffset ??
          Offset(size.width / 2, size.height / 2);
      _sizeInitialized = true;
      _lastSize = size;
    } else if (_lastSize != null && (_lastSize!.width != size.width || _lastSize!.height != size.height)) {
      final oldCenter = Offset(_lastSize!.width / 2, _lastSize!.height / 2);
      final newCenter = Offset(size.width / 2, size.height / 2);
      final delta = newCenter - oldCenter;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _offset += delta;
          _lastSize = size;
        });
      });
    }
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
  @override
  void dispose() {
    EditorState.storedOffset = _offset;
    super.dispose();
  }
}
