import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AnimatedCircleDialog extends StatefulWidget {
  const AnimatedCircleDialog({
    super.key,
    required this.imageUri,
    required this.backgroundCircleColor,
  });
  final String imageUri;
  final Color backgroundCircleColor;
  @override
  State<AnimatedCircleDialog> createState() => _AnimatedCircleDialogState();
}

class _AnimatedCircleDialogState extends State<AnimatedCircleDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    scaleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        curve: Curves.easeOutBack,
        parent: _animationController,
      ),
    );

    Future.delayed(
      const Duration(milliseconds: 200),
      () => _animationController.forward(),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: CircleAvatar(
              backgroundColor: widget.backgroundCircleColor,
              radius: 45.h,
              child: SvgPicture.asset(
                widget.imageUri,
                height: 50.h,
                width: 50.w,
              )),
        );
      },
    );
  }
}
