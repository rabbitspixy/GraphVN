import 'package:flutter/material.dart';

class TooltipPositioned extends StatefulWidget {
  final Offset position;
  final Widget child;
  const TooltipPositioned({
    Key? key,
    required this.position,
    required this.child,
  }) : super(key: key);

  @override
  State<TooltipPositioned> createState() => _TooltipPositionedState();
}

class _TooltipPositionedState extends State<TooltipPositioned> {
  final GlobalKey _key = GlobalKey();
  double _height = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void _afterLayout(Duration _) {
    final context = _key.currentContext;
    if (context != null) {
      final size = context.size;
      if (size != null && size.height != _height) {
        setState(() {
          _height = size.height;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant TooltipPositioned oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - 200.0,
      top: widget.position.dy - 30.0 - _height,
      child: Material(
        key: _key,
        color: Colors.transparent,
        child: widget.child,
      ),
    );
  }
}
