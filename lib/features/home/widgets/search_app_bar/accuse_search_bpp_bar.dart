import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/constants/app_icons.dart';
import 'package:issue/core/constants/assets_constants.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/services/services_locator.dart';
import 'package:issue/core/theme/theme.dart';
import 'package:issue/core/widgets/back_icon_button.dart';
import 'package:issue/data/models/accuse_model.dart';

import '../../../../core/helpers/shared_prefs_service.dart';
import '../../../../core/router/routes_constants.dart';
import '../../../../core/widgets/not_found_data.dart';
import '../../../../data/data_base/db_helper.dart';

/// This class is responsible for searching for accused by name
/// and displaying the search results.
/// It also displays the search history.
/// It uses the [SearchDelegate] class to implement the search functionality.
/// It uses the [HelperSharedPreferences] class to save and retrieve the search history.
/// It uses the [AccusedModel] class to display the search results.
class AccuseSearch extends SearchDelegate<String> {
  List<String> searchHistory = [];
  static const String _keyHistory = 'searchHistory';
  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          iconTheme: context.themeData.iconTheme,
          actionIconTheme: context.themeData.actionIconTheme,
          appBarTheme: context.themeData.appBarTheme.copyWith(elevation: 0),
        );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          RawMaterialButton(
            shape: const CircleBorder(),
            constraints: BoxConstraints.tight(Size(70.w, 40.h)),
            child: const Icon(
              FluentIcons.dismiss_20_regular,
              size: defaultIconSize - 4,
              color: Colors.grey,
            ),
            onPressed: () {
              query.isEmpty ? close(context, '') : query = '';
              showSuggestions(context);
            },
          ),
      ];

  Future<List<AccusedModel>> _searchAccused() async {
    return await getIt.get<DBHelper>().searchAccusedByName(query);
  }

  Future<List<String>> _getHistory() async {
    final getHistory = HelperSharedPreferences.getStringList(_keyHistory);
    searchHistory = getHistory;
    return getHistory;
  }

  Future<void> _removeHistory() async {
    await HelperSharedPreferences.remove(AccuseSearch._keyHistory);
  }

  Future<void> _saveHistory(String searchQuery) async {
    if (!searchHistory.contains(searchQuery)) {
      if (searchHistory.isNotEmpty) {
        searchHistory.insert(0, query);
      } else {
        searchHistory = [];
        searchHistory.add(query);
      }
      await HelperSharedPreferences.putStringList(_keyHistory, searchHistory);
    }
  }

  @override
  Widget buildLeading(BuildContext context) {
    return CustomBackIconButton(
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) _saveHistory(query);

    return FutureBuilder<List<AccusedModel>?>(
      future: _searchAccused(),
      builder: (context, snapshot) {
        if (query.isEmpty) return _buildHistoryList();
        if (snapshot.connectionState == ConnectionState.waiting) return _loadingIndicator();
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

        return _SuggestionList(
          query: query,
          suggestions: snapshot.data ?? [],
          onSelected: (suggestion) {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }

  Widget _buildHistoryList() {
    return FutureBuilder<List<String>>(
      future: _getHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _loadingIndicator();
        if (snapshot.hasError || snapshot.data!.isEmpty) {
          return Center(
              child: NotFoundData(
            error: 'neverSearchedAccusedBefore'.tr(),
            icon: AppIcons.personSearch,
            description: 'neverSearchedAccusedBeforeDescription'.tr(),
            descriptionPadding: EdgeInsets.symmetric(horizontal: 40.w),
          ));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.only(top: 10, right: 10, left: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchHistoryHeader(snapshot.data!, context),
              _buildSearchHistoryItems(snapshot.data!, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchHistoryHeader(List<String> history, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            history.isNotEmpty ? 'searchedForThemRecently'.tr() : '',
            style: context.textTheme.bodyMedium,
          ),
          if (history.isNotEmpty)
            RawMaterialButton(
              shape: const CircleBorder(),
              constraints: BoxConstraints.tight(Size(40.w, 40.h)),
              child: const Icon(AppIcons.delete, size: 25, color: Colors.grey),
              onPressed: () async {
                _removeHistory();
                searchHistory.clear();
                query = '';
                if (context.mounted) showSuggestions(context);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSearchHistoryItems(List<String> history, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding,
      ),
      child: Wrap(
        children: history.take(10).map((value) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  query = value;
                  showResults(context);
                },
                child: Row(
                  children: [
                    const Icon(AppIcons.history, size: 25, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        value,
                        style: context.textTheme.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildProfileImage(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: const Divider(
                  height: 10.0,
                  thickness: 0.5,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<AccusedModel>?>(
      future: _searchAccused(),
      builder: (context, snapshot) {
        if (query.isEmpty) return _buildHistoryList();
        if (snapshot.connectionState == ConnectionState.waiting) return _loadingIndicator();
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

        return _SuggestionList(
          query: query,
          suggestions: snapshot.data ?? [],
          onSelected: (suggestion) {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({required this.suggestions, required this.query, required this.onSelected});

  final List<AccusedModel> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: defaultPadding),
      itemCount: suggestions.length,
      itemBuilder: (context, i) {
        return _buildSuggestionCell(suggestions[i], onSelected, context);
      },
    );
  }

  Widget _buildSuggestionCell(
      AccusedModel accused, ValueChanged<String> tapped, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              tapped(accused.name.validate());
              Navigator.pushNamed(
                context,
                AppRoutesConstants.accusedDetailsView,
                arguments: accused,
              );
            },
            child: Row(
              children: [
                const Icon(AppIcons.history, size: 25, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    accused.name.validate(),
                    style: context.textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildProfileImage(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: const Divider(
              height: 10.0,
              thickness: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildProfileImage() {
  return const CircleAvatar(
    backgroundColor: Colors.white,
    backgroundImage: AssetImage(ImagesConstants.profileImage),
  );
}

Widget _loadingIndicator() {
  return const Center(
    child: CupertinoActivityIndicator(),
  );
}
