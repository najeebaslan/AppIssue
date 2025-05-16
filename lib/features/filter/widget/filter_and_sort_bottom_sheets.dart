import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/theme/app_colors.dart';
import 'package:issue/core/theme/theme.dart';
import 'package:issue/core/widgets/base_bottom_sheet.dart';
import 'package:issue/core/widgets/base_divider.dart';
import 'package:issue/core/widgets/custom_button.dart';
import 'package:issue/features/filter/filter_cubit/filter_cubit.dart';

class FilterAndSortBottomSheets {
  final FilterCubit filterCubit;
  FilterAndSortBottomSheets({required this.filterCubit});

  void showSortBottomSheet(BuildContext context) {
    BaseBottomSheet().show(
      context: context,
      centerTitle: false,
      useDraggable: false,
      headerTitle: 'sortBy',
      child: (controller) {
        return StatefulBuilder(
          builder: (context, setState) {
            int initialSortIndex = filterCubit.sortSelectedIndex;
            return ListView.separated(
              controller: controller,
              shrinkWrap: true,
              itemCount: filterCubit.listSortTypes.length + 1,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: index == (filterCubit.listSortTypes.length - 1)
                      ? const SizedBox.shrink()
                      : const BaseDivider(thickness: 0.25),
                );
              },
              itemBuilder: (context, index) {
                if (index == filterCubit.listSortTypes.length) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: defaultPadding.h,
                      bottom: (context.mediaQuery.padding.bottom + 15).h,
                    ),
                    child: CustomButton(
                      onPressed: () async {
                        filterCubit.onSelectedSort(
                          SortTypes.values[filterCubit.sortSelectedIndex],
                        );
                        Navigator.pop(context);
                      },
                      label: 'continue',
                    ),
                  );
                }
                return RadioListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  title: Text(
                    filterCubit.listSortTypes[index].name.tr(),
                    style: context.textTheme.bodyLarge,
                  ),
                  activeColor: AppColors.kPrimaryColor,
                  value: filterCubit.listSortTypes[index].index,
                  groupValue: initialSortIndex,
                  onChanged: (value) {
                    filterCubit.sortSelectedIndex = value ?? 0;
                    setState(() => initialSortIndex = value ?? 0);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void showFilterBottomSheet(BuildContext context) {
    BaseBottomSheet().show(
      context: context,
      centerTitle: false,
      useDraggable: false,
      headerTitle: 'filterBy',
      child: (controller) {
        return StatefulBuilder(
          builder: (context, setState) {
            int initialFilterIndex = filterCubit.filterSelectedIndex;
            return ListView.separated(
              controller: controller,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: index == (filterCubit.listFilterTypes.length - 1)
                    ? const SizedBox.shrink()
                    : const BaseDivider(thickness: 0.25),
              ),
              itemCount: filterCubit.listFilterTypes.length + 1,
              itemBuilder: (context, index) {
                if (index == filterCubit.listFilterTypes.length) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: defaultPadding.h,
                      bottom: (context.mediaQuery.padding.bottom + 15).h,
                    ),
                    child: CustomButton(
                      onPressed: () async {
                        filterCubit.onSelectedFilter(
                          FilterTypes.values[filterCubit.filterSelectedIndex],
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      label: 'continue',
                    ),
                  );
                }
                return RadioListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  title: Text(
                    filterCubit.listFilterTypes[index].name.tr(),
                    style: context.textTheme.bodyLarge,
                  ),
                  activeColor: AppColors.kPrimaryColor,
                  value: filterCubit.listFilterTypes[index].index,
                  groupValue: initialFilterIndex,
                  onChanged: (value) {
                    filterCubit.filterSelectedIndex = value ?? 0;
                    setState(() => initialFilterIndex = value ?? 0);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
