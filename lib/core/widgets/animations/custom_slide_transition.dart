import 'dart:async';

import 'package:flutter/material.dart';

enum SlideDirection { left, up }

class CustomSlideTransition extends StatefulWidget {
  final Widget child;
  final int delay;
  final SlideDirection direction;
  final Curve? curve;
  final double? startFromBottom;
  final double? startFromLift;

  final int? milliseconds;
  const CustomSlideTransition({
    super.key,
    this.curve,
    this.milliseconds,
    required this.child,
    required this.delay,
    this.startFromLift,
    this.startFromBottom,
    required this.direction,
  });

  @override
  State<CustomSlideTransition> createState() => _CustomSlideTransitionState();
}

class _CustomSlideTransitionState extends State<CustomSlideTransition>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.milliseconds ?? 800),
    );
    final curve = CurvedAnimation(
      curve: widget.curve ?? Curves.decelerate,
      parent: _controller,
    );

    if (widget.direction == SlideDirection.left) {
      _animOffset = Tween<Offset>(
        begin: Offset(widget.startFromLift ?? 0.35, 0.0),
        end: Offset.zero,
      ).animate(curve);
    } else {
      _animOffset = Tween<Offset>(
        begin: Offset(0.0, widget.startFromBottom ?? 0.35),
        end: Offset.zero,
      ).animate(curve);
    }

    Timer(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}

class ConstantsDelayAnimations {
  static int delay10ms = 10;
  static int delay30ms = 30;
  static int delay50ms = 50;
  static int delay100ms = 100;
  static int delay300ms = 300;
  static int delay400ms = 400;
  static int delay500ms = 500;
  static int delay800ms = 800;
  static int delay1200ms = 1200;
}
