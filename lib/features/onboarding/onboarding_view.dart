import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/widgets/custom_button.dart';
import 'package:issue/features/onboarding/change_language_icon_button.dart';

import '../../core/helpers/helper_user.dart';
import '../../core/router/routes_constants.dart';
import '../../core/services/services_locator.dart';
import 'animated_pages.dart';
import 'animation_circular_indicator.dart';
import 'on_boarding_data.dart';
import 'on_boarding_item.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  final ValueNotifier<double> _pageValue = ValueNotifier(0.0);
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool showSignInButton = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex)
      ..addListener(() => _pageValue.value = _pageController.page!);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Page Navigation Methods
  void _changeIndex(int newIndex) {
    if ((_currentIndex == 3) && showSignInButton == true) {
      _startAnimationButtonListener(newIndex);
    }
    setState(() => _currentIndex = newIndex);
  }

  void _nextPage() async {
    if (_currentIndex < OnBoardingData.onBoardingList.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      await _goToSignInView();
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  Future<void> _goToSignInView() async {
    Navigator.pushNamed(context, AppRoutesConstants.signInView);
    await getIt.get<UserHelper>().seenOnboarding(true);
  }

  // Animation Logic
  void _startAnimationButtonListener(int newIndex) {
    if (newIndex > OnBoardingData.onBoardingList.length - 2) {
      _animationController.forward().whenCompleteOrCancel(() {
        showSignInButton = true;
        _animationController.reverse();
      });
    } else {
      if (showSignInButton) {
        _animationController.forward().whenCompleteOrCancel(() {
          showSignInButton = false;
          _animationController.reverse();
        });
      } else {
        showSignInButton = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColors?.bottomSheetColor,
      body: Stack(
        children: <Widget>[
          _buildPageView(),
          _buildBodyContent(),
          const ChangeLanguageIconButton(),
        ],
      ),
    );
  }

  Positioned _buildBodyContent() {
    return Positioned(
      bottom: 32.0,
      left: 0.0,
      right: 0.0,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! < 0) {
            _previousPage();
          } else if (details.primaryDelta! > 0) {
            _nextPage();
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OnBoardingTitles(currentIndex: _currentIndex),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    tileMode: TileMode.decal,
                    sigmaX: (1 - _scaleAnimation.value) * 20.0,
                    sigmaY: (1 - _scaleAnimation.value) * 20.0,
                  ),
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scale: _scaleAnimation.value,
                    child: SizedBox(
                      height: 100.h,
                      child: showSignInButton
                          ? _nextButton()
                          : AnimationCircularIndicator(
                              onAnimationEnd: () {
                                _startAnimationButtonListener(_currentIndex);
                              },
                              nextPage: _nextPage,
                              pageIndex: _currentIndex,
                            ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  AnimatedPages _buildPageView() {
    return AnimatedPages(
      pageValueNotifier: _pageValue,
      pageController: _pageController,
      pageCount: OnBoardingData.onBoardingList.length,
      onPageChangeCallback: _changeIndex,
      child: (index, _) => OnBoardingImage(
        imageUri: OnBoardingData.onBoardingList[index].image,
      ),
    );
  }

  Widget _nextButton() {
    return Center(
      child: InkWell(
        onTap: _nextPage,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 100.0),
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                alignment: Alignment.center,
                child: CustomButton(
                  onPressed: _goToSignInView,
                  label: 'signIn',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
