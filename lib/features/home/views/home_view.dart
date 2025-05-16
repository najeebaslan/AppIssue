import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/widgets/not_found_data.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/assets_constants.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/base_divider.dart';
import '../../accused/accused_cubit/accused_cubit.dart';
import '../widgets/accused_details_card.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/trial_mode_overlay.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AutomaticKeepAliveClientMixin {
  late final AccusedCubit _accusedCubit;

  @override
  void initState() {
    super.initState();
    _accusedCubit = context.read<AccusedCubit>();
    _accusedCubit.getAccused();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen for locale changes
    final newLocale = EasyLocalization.of(context)!.locale;
    if (context.locale != newLocale) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return HomeAppBar(
      child: BlocBuilder<AccusedCubit, AccusedState>(
        bloc: _accusedCubit,
        buildWhen: _shouldUpdate,
        builder: (context, state) {
          if (state is EmptyGetAccused) {
            return _buildNotFoundView();
          } else if (state is SuccessGetAccused || state is SetState) {
            return _buildAccusedListView();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAccusedListView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 3.h),
          child: const BaseDivider(),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding.w - 10,
            ),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 14.h),
              itemCount: _accusedCubit.listAccused.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: AccusedDetailsCard(index: index),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotFoundView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NotFoundData(
          error: 'notFoundAccused'.tr(),
          radius: 100.r,
          customIcon: Lottie.asset(ImagesConstants.noFoundUsers),
          description: 'notFoundAccusedDescription'.tr(),
        ),
        SizedBox(height: defaultPadding.h),
        const TrialModeOverlay(),
      ],
    );
  }

  bool _shouldUpdate(AccusedState previous, AccusedState current) {
    return current is LoadingGetAccused ||
        current is SuccessGetAccused ||
        current is ErrorGetAccused ||
        current is EmptyGetAccused ||
        current is SetState;
  }

  @override
  bool get wantKeepAlive => true;
}
