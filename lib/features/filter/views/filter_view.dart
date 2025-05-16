import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/constants/app_icons.dart';
import 'package:issue/core/constants/assets_constants.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/iterable_extension.dart';
import 'package:issue/data/models/accuse_model.dart';
import 'package:issue/features/filter/widget/filter_body.dart';
import 'package:lottie/lottie.dart';

import '../../../core/widgets/not_found_data.dart';
import '../filter_cubit/filter_cubit.dart';
import '../widget/filter_app_bar.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  late final FilterCubit _filterCubit;
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _filterCubit = BlocProvider.of<FilterCubit>(context);
    _filterCubit.getAccusedFiltered();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FilterAppBar(
        searchController: _searchController,
        size: Size(context.width, 70.h),
        filterCubit: _filterCubit,
      ),
      body: SafeArea(
        child: BlocBuilder<FilterCubit, FilterState>(
          bloc: _filterCubit,
          buildWhen: (previous, current) {
            return _shouldRebuild(previous, current);
          },
          builder: (context, state) {
            return _buildStateContent(state);
          },
        ),
      ),
    );
  }

  bool _shouldRebuild(FilterState previous, FilterState current) {
    return current is LoadingFilteredAccusedState ||
        current is ErrorFilteredAccusedState ||
        current is SuccessFilteredAccusedState ||
        current is CompletedOrSoonCompletedSelected ||
        current is FilterByIssueNumber ||
        current is EmptyGetAccusedState ||
        current is SearchAccusedByNameOrIssueNumber ||
        current is RefreshFilterView;
  }

  Widget _buildStateContent(FilterState state) {
    if (state is LoadingFilteredAccusedState) {
      return const Center(child: CupertinoActivityIndicator());
    } else if (state is ErrorFilteredAccusedState) {
      return NotFoundData(error: state.error);
    } else if (state is EmptyGetAccusedState) {
      return _noResultWidget(state, 'notFoundAccusedDescription'.tr());
    } else if (_shouldRenewListAccused(state)) {
      List<AccusedModel> listAccused = _getListAccusedFromState(state);
      return listAccused.isEmptyOrNull
          ? _noResultWidget(state, null)
          : _buildFilterBodyContent(listAccused);
    }
    return _buildFilterBodyContent(_filterCubit.listAccused);
  }

  NotFoundData _noResultWidget(FilterState state, String? description) {
    return NotFoundData(
      error: state is SearchAccusedByNameOrIssueNumber
          ? 'notFoundAccusedByThisName'.tr()
          : 'notFoundResultsForThisSearch'.tr(),
      radius: 100.r,
      customIcon: Lottie.asset(ImagesConstants.noFoundUsers),
      icon: state is SearchAccusedByNameOrIssueNumber ? AppIcons.notFoundUser : null,
      description: description,
    );
  }

  bool _shouldRenewListAccused(FilterState state) {
    return state is CompletedOrSoonCompletedSelected ||
        state is FilterByIssueNumber ||
        state is SearchAccusedByNameOrIssueNumber;
  }

  List<AccusedModel> _getListAccusedFromState(FilterState state) {
    final listAccused = state is CompletedOrSoonCompletedSelected
        ? state.listAccused
        : state is FilterByIssueNumber
            ? state.listAccused
            : (state as SearchAccusedByNameOrIssueNumber).listAccused;
    return listAccused;
  }

  Widget _buildFilterBodyContent(List<AccusedModel> listAccused) {
    return FilterBodyContent(
      customContext: context,
      listAccused: listAccused,
      filterCubit: _filterCubit,
      scrollController: _scrollController,
    );
  }
}
