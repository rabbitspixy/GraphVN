import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graph_vn/editor/editor_node.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:graph_vn/editor/editor_transition.dart';
import 'package:graph_vn/editor/pages/graph/node_painter.dart';
import 'package:graph_vn/editor/pages/graph/node_tooltip.dart';
import 'package:graph_vn/editor/pages/graph/transition_painter.dart';
import 'package:graph_vn/editor/pages/graph/transition_tooltip.dart';

class EditorCanvas extends StatefulWidget {
  final EditorNode? selectedNode;
  final EditorTransition? selectedTransition;
  final Function(dynamic) onSelect;

  const EditorCanvas({
    super.key,
    required this.selectedNode,
    required this.selectedTransition,
    required this.onSelect,
  });

  @override
  State<EditorCanvas> createState() => EditorCanvasState();
}

class EditorCanvasState extends State<EditorCanvas> {
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
  int _forcedRepaint = 0;

  StreamSubscription<String>? _stateUpdatedEventsSubscription;


  void _onPointerDown(PointerDownEvent event) {
    if (event.buttons & kPrimaryMouseButton != 0) {
      if (_hoveredNode != null) {
        widget.onSelect(_hoveredNode!);
      } else if (_hoveredTransition != null) {
        widget.onSelect(_hoveredTransition!);
      } else {
        widget.onSelect(null);
      }
      if (event.timeStamp - _lastClickTime < const Duration(milliseconds: 300)) {
        _createNewNodeAt(event.localPosition - _offset);
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
          if (rect.contains(event.localPosition)) {
            _linkingNodeId = node.id;
            return;
          }
        }
      } else {
        for (final node in EditorState.nodes.values) {
          final left = node.x.toDouble() - 5 + _offset.dx;
          final top = node.y.toDouble() - 5 + _offset.dy;
          final rect = Rect.fromLTWH(left, top, 10, 10);
          if (rect.contains(event.localPosition)) {
            _draggingNodeId = node.id;
            _nodeDragStart = event.localPosition;
            _nodeOffsetStart = Offset(node.x.toDouble(), node.y.toDouble());
            _nodeDragging = true;
            return;
          }
        }
      }
    }
    // Handle canvas panning with middle mouse button
    if (_linkingNodeId == null && event.buttons & kMiddleMouseButton != 0) {
      _dragStart = event.localPosition;
      _offsetStart = _offset;
      _dragging = true;
    }
  }

  void _createNewNodeAt(Offset localPos) {
    final newNode = EditorNode();
    if (EditorState.trySetNodePosition(newNode, localPos.dx.round(), localPos.dy.round())) {
      EditorState.addNode(newNode);
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_linkingNodeId == null && _nodeDragging && _draggingNodeId != null && _nodeDragStart != null && _nodeOffsetStart != null) {
      final delta = event.localPosition - _nodeDragStart!;
      setState(() {
        EditorState.trySetNodePositionById(_draggingNodeId!, (_nodeOffsetStart!.dx + delta.dx).round(), (_nodeOffsetStart!.dy + delta.dy).round());
        _forcedRepaint++;
      });
    } else if (_dragging && _dragStart != null && _offsetStart != null) {
      final delta = event.localPosition - _dragStart!;
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
        if (rect.contains(event.localPosition) && node.id != _linkingNodeId) {
          // Create transition
          EditorState.addTransition(EditorTransition()
            ..from = _linkingNodeId!
            ..to = node.id);
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
    final nearestItem = _getNearestItemAtPosition(globalPosition);
    
    setState(() {
      if (nearestItem != null && nearestItem is EditorTransition) {
        _hoveredTransition = nearestItem;
        _hoverPosition = globalPosition;
        _hoveredNode = null;
        _hoverNodePosition = null;
      } else if (nearestItem != null && nearestItem is EditorNode) {
        _hoveredNode = nearestItem;
        _hoverNodePosition = globalPosition;
        _hoveredTransition = null;
        _hoverPosition = null;
      } else {
        _hoveredTransition = null;
        _hoverPosition = null;
        _hoveredNode = null;
        _hoverNodePosition = null;
      }
    });
  }

  void resetOffset(Size size) {
    setState(() {
      _offset = Offset(size.width / 2, size.height / 2);
    });
  }

  dynamic _getNearestItemAtPosition(Offset pos) {
    const double threshold = 12.0;
    
    EditorNode? nearestNode;
    double nearestNodeDist = double.infinity;
    
    for (final node in EditorState.nodes.values) {
      final center = Offset(node.x.toDouble(), node.y.toDouble()) + _offset;
      final dist = (pos - center).distance;
      if (dist < nearestNodeDist && dist <= threshold) {
        nearestNodeDist = dist;
        nearestNode = node;
      }
    }
    
    EditorTransition? nearestTransition;
    double nearestTransitionDist = double.infinity;
    
    for (final transition in EditorState.transitions) {
      final dist = (pos - (transition.pos.center + _offset)).distance;
      if (dist < nearestTransitionDist && dist <= threshold) {
        nearestTransitionDist = dist;
        nearestTransition = transition;
      }
    }
    
    if (nearestNode == null && nearestTransition == null) {
      return null;
    }
    
    if (nearestNode == null) {
      return nearestTransition;
    }
    
    if (nearestTransition == null) {
      return nearestNode;
    }
    
    return nearestNodeDist <= nearestTransitionDist ? nearestNode : nearestTransition;
  }

  void _onHover(PointerHoverEvent event) {
    _updateHover(event.localPosition);
  }



  @override
  void initState() {
    _stateUpdatedEventsSubscription = EditorState.stateUpdatedEvents.listen((e) { 
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _stateUpdatedEventsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!_sizeInitialized) {
      _offset = Offset(size.width / 2, size.height / 2);
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
              CustomPaint(
                painter: TransitionPainter(offset: _offset, selectedTransition: widget.selectedTransition, hoveredTransition: _hoveredTransition),
              ),
              CustomPaint(
                painter: NodePainter(offset: _offset, selectedNode: widget.selectedNode, hoveredNode: _hoveredNode, forcedRepaint: _forcedRepaint),
              ),
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
