import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

class AuthBackgroundWithTitle extends StatelessWidget {
  const AuthBackgroundWithTitle({
    super.key,
    required this.child,
    required this.paddingButtonOnOpenKeyword,
  });
  final Widget child;

  final double paddingButtonOnOpenKeyword;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight + paddingButtonOnOpenKeyword;
      double maxWidth = constraints.maxWidth;
      return AnnotatedRegion(
        value: authSystemUiOverlayStyle(context),
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            child,
            Positioned(
              top: -maxHeight * 0.3,
              right: -maxWidth * 0.1,
              child: Container(
                height: maxHeight * 0.7,
                width: maxWidth * 0.7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3D5AD1),
                      Color(0xFF6291E2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -maxHeight * 0.1,
              left: -maxWidth * 0.2,
              child: Container(
                height: maxHeight * 0.43,
                width: maxWidth * 0.8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3D5AD1),
                      Color(0xFF2048E6),
                      Color(0xFF548AE7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
