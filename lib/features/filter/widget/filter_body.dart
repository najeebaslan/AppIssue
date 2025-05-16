import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:issue/core/constants/app_icons.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/router/routes_constants.dart';
import 'package:issue/core/theme/theme.dart';
import 'package:issue/core/widgets/adaptive_them_container.dart';
import 'package:issue/data/models/accuse_model.dart';
import 'package:issue/features/accused/accused_cubit/accused_cubit.dart';
import 'package:issue/features/filter/filter_cubit/filter_cubit.dart';
import 'package:issue/features/filter/widget/filter_list_tile.dart';
import 'package:issue/features/filter/widget/list_issue_numbers.dart';

class FilterBodyContent extends StatelessWidget {
  const FilterBodyContent({
    super.key,
    required this.customContext,
    required this.listAccused,
    required this.filterCubit,
    required this.scrollController,
  });
  final BuildContext customContext;
  final List<AccusedModel> listAccused;
  final ScrollController scrollController;

  final FilterCubit filterCubit;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: context.textTheme.bodyMedium!,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding.w,
            ),
            child: const ListIssueNumbers(),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: defaultPadding.w,
              ),
              itemCount: listAccused.length,
              itemBuilder: (context, index) {
                final accused = listAccused[index];

                return GestureDetector(
                  onTap: () async => await _navigatorToDetailsAccused(accused, context),
                  child: AdaptiveThemeContainer(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    child: FilterListTile(
                      accused: accused,
                      index: index,
                      title: accused.name.validate(),
                      subtitle: intl.DateFormat(
                        'yyyy/MM/dd  h a',
                        context.locale.languageCode,
                      ).format(DateTime.parse(accused.date!)),
                      leading: CircleAvatar(
                        backgroundColor: context.themeData.primaryColor.withValues(alpha: 0.13),
                        child: Icon(
                          AppIcons.person,
                          color: context.themeData.primaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigatorToDetailsAccused(AccusedModel accused, BuildContext context) async {
    final oldAccused = accused;
    context.read<AccusedCubit>().updatedAccused = null;
    await Navigator.pushNamed(
      context,
      AppRoutesConstants.accusedDetailsView,
      arguments: oldAccused,
    ).then((onValue) {
      if (context.mounted) {
        final updatedAccused = context.read<AccusedCubit>().updatedAccused;
        if (updatedAccused != null) {
          if (updatedAccused != oldAccused) filterCubit.getAccusedFiltered();
        }
      }
    });
  }
}
