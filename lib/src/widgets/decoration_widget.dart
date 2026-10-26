import 'package:flutter/material.dart';
import '../models/decoration.dart';

class AquariumDecorationWidget extends StatefulWidget {
  final AquariumDecoration decoration;
  final VoidCallback? onTap;
  final Function(double x, double y)? onDragEnd;
  final bool isPlacing;

  const AquariumDecorationWidget({
    super.key,
    required this.decoration,
    this.onTap,
    this.onDragEnd,
    this.isPlacing = false,
  });

  @override
  State<AquariumDecorationWidget> createState() =>
      _AquariumDecorationWidgetState();
}

class _AquariumDecorationWidgetState extends State<AquariumDecorationWidget> {
  late double _x;
  late double _y;

  @override
  void initState() {
    super.initState();
    _x = widget.decoration.x;
    _y = widget.decoration.y;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _x,
      bottom: _y,
      child: Draggable(
        feedback: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.cyan.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.cyan.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Text(
            widget.decoration.type.emoji,
            style: TextStyle(
              fontSize: _getSize(widget.decoration.type),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: _buildDecorationBody(),
        ),
        onDragEnd: (details) {
          // Get the position relative to screen
          final RenderBox box = context.findRenderObject() as RenderBox;
          final offset = box.globalToLocal(details.offset);

          setState(() {
            _x = offset.dx.clamp(0, 300);
            _y = offset.dy.clamp(0, 500);
          });

          widget.onDragEnd?.call(_x, _y);
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: _buildDecorationBody(),
        ),
      ),
    );
  }

  Widget _buildDecorationBody() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: widget.isPlacing
          ? BoxDecoration(
              border: Border.all(
                color: Colors.cyan.withValues(alpha: 0.5),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: Colors.cyan.withValues(alpha: 0.1),
            )
          : null,
      child: Text(
        widget.decoration.type.emoji,
        style: TextStyle(
          fontSize: _getSize(widget.decoration.type),
        ),
      ),
    );
  }

  double _getSize(AquariumDecorationType type) {
    switch (type) {
      case AquariumDecorationType.rock:
        return 30;
      case AquariumDecorationType.plant:
        return 35;
      case AquariumDecorationType.coral:
        return 32;
      case AquariumDecorationType.shell:
        return 25;
      case AquariumDecorationType.castle:
        return 50;
      case AquariumDecorationType.treasure:
        return 40;
    }
  }
}
