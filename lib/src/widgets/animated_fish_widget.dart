import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/fish.dart';
import 'fish_avatar.dart';

class AnimatedFishWidget extends StatefulWidget {
  final Fish fish;
  final VoidCallback? onTap;
  final Size containerSize;

  const AnimatedFishWidget({
    super.key,
    required this.fish,
    this.onTap,
    required this.containerSize,
  });

  @override
  State<AnimatedFishWidget> createState() => _AnimatedFishWidgetState();
}

class _AnimatedFishWidgetState extends State<AnimatedFishWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionX;
  late Animation<double> _positionY;

  double _currentX = 0;
  double _currentY = 0;
  double _targetX = 0;
  double _targetY = 0;
  bool _facingRight = true;

  @override
  void initState() {
    super.initState();

    // Random starting position
    _currentX = math.Random().nextDouble() * (widget.containerSize.width - 60);
    _currentY = math.Random().nextDouble() * (widget.containerSize.height - 60);

    _controller = AnimationController(
      duration: Duration(seconds: 3 + math.Random().nextInt(3)),
      vsync: this,
    );

    _setupAnimation();
    _controller.repeat();
  }

  void _setupAnimation() {
    _targetX = math.Random().nextDouble() * (widget.containerSize.width - 60);
    _targetY = math.Random().nextDouble() * (widget.containerSize.height - 60);

    // Determine facing direction
    _facingRight = _targetX > _currentX;

    _positionX = Tween<double>(
      begin: _currentX,
      end: _targetX,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _positionY = Tween<double>(
      begin: _currentY,
      end: _targetY,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _currentX = _targetX;
          _currentY = _targetY;
          _setupAnimation();
        });
        _controller.forward(from: 0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _positionX.value,
          top: _positionY.value,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(_facingRight ? 1.0 : -1.0, 1.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FishAvatar(
                    species: widget.fish.species,
                    size: 50,
                    showShadow: false,
                  ),
                  // Hunger indicator
                  if (widget.fish.hunger < 50)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '🍽️',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
