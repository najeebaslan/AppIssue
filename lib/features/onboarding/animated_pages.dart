import 'package:flutter/material.dart';

typedef ChildBuilder = Widget Function(int index, BuildContext context);
typedef OnPageChangeCallback = void Function(int index);

class AnimatedPages extends StatelessWidget {
  final PageController pageController;
  final ValueNotifier<double> pageValueNotifier;
  final ChildBuilder child;
  final int pageCount;
  final OnPageChangeCallback onPageChangeCallback;

  const AnimatedPages({
    super.key,
    required this.pageController,
    required this.pageValueNotifier,
    required this.child,
    required this.pageCount,
    required this.onPageChangeCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: pageValueNotifier,
        builder: (context, pageValue, _) {
          return PageView.builder(
            onPageChanged: onPageChangeCallback,
            physics: const ClampingScrollPhysics(),
            controller: pageController,
            itemCount: pageCount,
            itemBuilder: (context, index) {
              if (index == pageValue.floor() + 1 || index == pageValue.floor() + 2) {
                /// Right
                return Transform.translate(
                  offset: Offset(0.0, 300 * (index - pageValue)),
                  child: child(index, context),
                );
              } else if (index == pageValue.floor() || index == pageValue.floor() - 1) {
                /// Left
                return Transform.translate(
                  offset: Offset(0.0, 300 * (pageValue - index)),
                  child: child(index, context),
                );
              } else {
                /// Middle
                return child(index, context);
              }
            },
          );
        });
  }
}
