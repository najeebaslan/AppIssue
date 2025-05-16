import 'dart:math' as math;

import 'package:flutter/material.dart';

class BaseHeroFlipAnimation extends StatelessWidget {
  const BaseHeroFlipAnimation({
    super.key,
    required this.child,
    required this.heroTag,
    required this.addMaterial,
  });
  final Widget child;
  final String heroTag;
  final bool addMaterial;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      flightShuttleBuilder: (_, Animation<double> animation, __, ___, ____) {
        final rotationAnimation = Tween<double>(
          begin: 0.0, // This value should match the first Hero
          end: 2.0, // This value should match the second Hero
        ).animate(animation);

        if (addMaterial) {
          return Material(
            child: _animatedBuilder(rotationAnimation),
          );
        } else {
          return Material(child: _animatedBuilder(rotationAnimation));
        }
      },
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.003)
          ..rotateX(0),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  AnimatedBuilder _animatedBuilder(Animation<double> rotationAnimation) {
    return AnimatedBuilder(
      animation: rotationAnimation,
      child: child,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003)
            ..rotateX(rotationAnimation.value * math.pi),
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }
}
