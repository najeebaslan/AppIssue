import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/widgets/custom_text_field.dart';
import 'package:issue/features/filter/widget/filter_and_sort_bottom_sheets.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/theme/theme.dart';
import '../filter_cubit/filter_cubit.dart';

class FilterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FilterAppBar({
    super.key,
    required this.size,
    required this.filterCubit,
    required this.searchController,
  });

  final Size size;
  final FilterCubit filterCubit;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final bottomSheets = FilterAndSortBottomSheets(filterCubit: filterCubit);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding.w,
        vertical: 10.h,
      ),
      child: BlocBuilder<FilterCubit, FilterState>(
        buildWhen: (previous, current) => current is SuccessFilteredAccusedState,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _sortButton(context, bottomSheets),
              SizedBox(width: 10.w),
              Flexible(
                fit: FlexFit.loose,
                child: CustomTextField(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.customColors!.blackAndWhite!,
                      width: 0.2,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  onChanged: (query) {
                    context.read<FilterCubit>().searchAccusedList(query);
                  },
                  fillColor: context.customColors?.backgroundTextField,
                  controller: searchController,
                  borderRadius: BorderRadius.circular(10),
                  placeholder: 'placeholderFilterSearch'.tr(),
                  hintStyle: context.textTheme.bodyMedium?.copyWith(
                    color: context.textTheme.bodySmall?.color,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  maxLength: 32,
                ),
              ),
              SizedBox(width: 10.w),
              _filterButton(context, bottomSheets),
            ],
          );
        },
      ),
    );
  }

  AspectRatio _sortButton(BuildContext context, FilterAndSortBottomSheets bottomSheets) {
    return AspectRatio(
      aspectRatio: 1.9 / 2,
      child: RawMaterialButton(
        onPressed: () => bottomSheets.showSortBottomSheet(context),
        elevation: 0,
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: context.customColors!.blackAndWhite!,
            width: 0.2,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        fillColor: context.customColors?.backgroundTextField,
        constraints: BoxConstraints.tight(Size(20.w, 20.h)),
        child: Icon(
          AppIcons.sort,
          size: defaultIconSize - 4,
          color: context.customColors!.blackAndWhite?.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  AspectRatio _filterButton(BuildContext context, FilterAndSortBottomSheets bottomSheets) {
    return AspectRatio(
      aspectRatio: 1.9 / 2,
      child: RawMaterialButton(
        onPressed: () => bottomSheets.showFilterBottomSheet(context),
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: context.customColors!.blackAndWhite!,
            width: 0.2,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        fillColor: context.customColors?.backgroundTextField,
        constraints: BoxConstraints.tight(Size(40.w, 40.h)),
        child: Icon(
          AppIcons.filter,
          size: defaultIconSize,
          color: context.customColors!.blackAndWhite?.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => size;
}
