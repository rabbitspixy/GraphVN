import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touch_of_the_unknown/editor/editor_node.dart';
import 'package:touch_of_the_unknown/editor/editor_state.dart';
import 'package:touch_of_the_unknown/editor/editor_transition.dart';
import 'package:touch_of_the_unknown/editor/node_tooltip.dart';
import 'package:touch_of_the_unknown/editor/transition_painter.dart';
import 'package:touch_of_the_unknown/editor/transition_tooltip.dart';

class EditorCanvas extends StatefulWidget {
  final Function(EditorNode) startNodeEdit;
  final Function(EditorTransition) startTransitionEdit;
  const EditorCanvas({
    super.key,
    required this.startNodeEdit,
    required this.startTransitionEdit,
  });

  @override
  State<EditorCanvas> createState() => _EditorCanvasState();
}

class _EditorCanvasState extends State<EditorCanvas> {
  Offset _offset = Offset.zero;
  Offset? _dragStart;
  Offset? _offsetStart;
  bool _dragging = false;
  String? _draggingNodeId;
  Offset? _nodeDragStart;
  Offset? _nodeOffsetStart;
  bool _nodeDragging = false;
  String? _linkingNodeId;
  Duration _lastClickTime = Duration.zero;
  Size? _lastSize;
  bool _sizeInitialized = false;
  EditorTransition? _hoveredTransition;
  Offset? _hoverPosition;
  EditorNode? _hoveredNode;
  Offset? _hoverNodePosition;

  void _onPointerDown(PointerDownEvent event) {
    if (event.buttons & kPrimaryMouseButton != 0) {
      if (_hoveredNode != null) {
        widget.startNodeEdit(_hoveredNode!);
      }
      if (_hoveredTransition != null) {
        widget.startTransitionEdit(_hoveredTransition!);
      }
      if (event.timeStamp - _lastClickTime < const Duration(milliseconds: 300)) {
        _createNewNodeAt(event.position - _offset);
        _lastClickTime = Duration(milliseconds: 0);
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

  void _createNewNodeAt(Offset localPos) {
    final gridX = ((localPos.dx / 25).round() * 25);
    final gridY = ((localPos.dy / 25).round() * 25);
    final newNode = EditorNode()
      ..x = gridX
      ..y = gridY;
    EditorState.nodes[newNode.id] = newNode;
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

  void _updateHover(Offset globalPosition) {
    EditorTransition? nearestTransition = _getTransitionAtPosition(globalPosition);
    EditorNode? nearestNode = _getNodeAtPosition(globalPosition);
    setState(() {
      if (nearestTransition != null) {
        _hoveredTransition = nearestTransition;
        _hoverPosition = globalPosition;
      } else {
        _hoveredTransition = null;
        _hoverPosition = null;
      }
      if (nearestNode != null) {
        _hoveredNode = nearestNode;
        _hoverNodePosition = globalPosition;
      } else {
        _hoveredNode = null;
        _hoverNodePosition = null;
      }
    });
  }

  void _onHover(PointerHoverEvent event) {
    _updateHover(event.position);
  }

  EditorNode? _getNodeAtPosition(Offset pos) {
    for (final node in EditorState.nodes.values) {
      final center = Offset(node.x.toDouble(), node.y.toDouble()) + _offset;
      if ((pos - center).distance <= 5.0) {
        return node;
      }
    }
    return null;
  }

  EditorTransition? _getTransitionAtPosition(Offset pos) {
    const double threshold = 5.0;
    EditorTransition? nearest;
    double nearestDist = double.infinity;
    final Map<String, int> pairCount = {};
    for (final transition in EditorState.transitions) {
      final fromNode = EditorState.nodes[transition.from];
      final toNode = EditorState.nodes[transition.to];
      if (fromNode == null || toNode == null) continue;
      final start = Offset(
        fromNode.x.toDouble(),
        fromNode.y.toDouble(),
      ) + _offset;
      final end = Offset(
        toNode.x.toDouble(),
        toNode.y.toDouble(),
      ) + _offset;
      final key = '${transition.from}->${transition.to}';
      final keyReversed = '${transition.to}->${transition.from}';
      final index = (pairCount.update(key, (v) => v + 1, ifAbsent: () => 1) + pairCount.update(keyReversed, (v) => v + 1, ifAbsent: () => 1)) / 2;
      Offset center;
      if (index == 1) {
        center = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
      } else {
        final mid = Offset(
          (start.dx + end.dx) / 2,
          (start.dy + end.dy) / 2,
        );
        final sign = (index % 2 == 0) ? 1 : -1;
        final d = end - start;
        final perp = Offset(-d.dy, d.dx);
        final perpLength = perp.distance;
        final magnitude = 50.0 * (((index - 2) ~/ 2) + 1);
        final unitPerp = perpLength == 0 ? Offset.zero : Offset(perp.dx / perpLength, perp.dy / perpLength);
        final control = mid + unitPerp * (sign.toDouble() * magnitude);
        center = Offset(
          0.25 * start.dx + 0.5 * control.dx + 0.25 * end.dx,
          0.25 * start.dy + 0.5 * control.dy + 0.25 * end.dy,
        );
      }
      final dist = (pos - center).distance;
      if (dist < nearestDist && dist <= threshold) {
        nearestDist = dist;
        nearest = transition;
      }
    }
    return nearest;
  }

  @override
  void dispose() {
    EditorState.storedOffset = _offset;
    super.dispose();
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
    return MouseRegion(
          onHover: _onHover,
          child: Listener(
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
                        decoration: BoxDecoration(
                          color: node.isStart ? const Color.fromARGB(255, 37, 224, 43) : Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }).toList(),
                  if (_hoveredNode != null && _hoverNodePosition != null && !_nodeDragging)
                    NodeTooltip(
                      position: _hoverNodePosition!,
                      node: _hoveredNode!,
                    ),
                  if (_hoveredTransition != null && _hoverPosition != null)
                    TransitionTooltip(
                      position: _hoverPosition!,
                      transition: _hoveredTransition!,
                    ),
                ],
              ),
            ),
          ),
        );
  }
}