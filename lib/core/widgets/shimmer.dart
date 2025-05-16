import 'package:flutter/material.dart';
import 'package:issue/core/extensions/context_extension.dart';

Color darkColor = const Color(0xff10122C);

final darkShimmerGradient = LinearGradient(
  colors: [
    darkColor.withValues(alpha: 0.99),
    const Color(0xFF3E3660).withValues(alpha: 0.5),
    darkColor.withValues(alpha: 0.99),
  ],
  stops: const [0.1, 0.3, 0.4],
  begin: const Alignment(-1.0, -0.3),
  end: const Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

Color lightColor = const Color(0xFFD7D7D7);
final lightShimmerGradient = LinearGradient(
  colors: [
    lightColor.withValues(alpha: 0.99),
    lightColor.withValues(alpha: 0.50),
    lightColor.withValues(alpha: 0.99),
  ],
  stops: const [0.1, 0.3, 0.4],
  begin: const Alignment(-1.0, -0.3),
  end: const Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

class CustomShimmer extends StatefulWidget {
  const CustomShimmer({
    super.key,
    this.child,
    this.isCircle = false,
    this.borderAll,
    this.borderRadius,
    required this.height,
    required this.width,
  });
  final Widget? child;
  final bool isCircle;

  final double? borderAll;
  final BorderRadiusGeometry? borderRadius;
  final double height;
  final double width;

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1200));
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
      builder: (BuildContext context, Widget? child) {
        final animationValue = _animationController.value;
        bool localChild = widget.child == null ? true : false;
        return Container(
          height: localChild ? widget.height : null,
          width: localChild ? widget.width : null,
          decoration: BoxDecoration(
            borderRadius: widget.isCircle == true
                ? null
                : widget.borderRadius ??
                    BorderRadius.circular(
                      widget.borderAll ?? 10,
                    ),
            shape: widget.isCircle == true ? BoxShape.circle : BoxShape.rectangle,
            gradient: context.isDark
                ? LinearGradient(
                    colors: darkShimmerGradient.colors,
                    stops: darkShimmerGradient.stops,
                    begin: darkShimmerGradient.begin,
                    end: darkShimmerGradient.end,
                    transform: _SlidingGradientTransform(
                      slidePercent: animationValue,
                    ),
                  )
                : LinearGradient(
                    colors: lightShimmerGradient.colors,
                    stops: lightShimmerGradient.stops,
                    begin: lightShimmerGradient.begin,
                    end: lightShimmerGradient.end,
                    transform: _SlidingGradientTransform(
                      slidePercent: animationValue,
                    ),
                  ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});
  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
