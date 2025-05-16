part of 'filter_cubit.dart';

enum FilterStates { initial, loading, loaded, error }

class FilterState {}

final class FilterInitial extends FilterState {}

final class LoadingFilteredAccusedState extends FilterState {}

final class SuccessFilteredAccusedState extends FilterState {
  final List<AccusedModel> listAccused;

  SuccessFilteredAccusedState({required this.listAccused});
}

final class ErrorFilteredAccusedState extends FilterState {
  final String error;
  ErrorFilteredAccusedState(this.error);
}

final class RefreshFilterView extends FilterState {}

final class CompletedOrSoonCompletedSelected extends FilterState {
  final List<AccusedModel> listAccused;

  CompletedOrSoonCompletedSelected({required this.listAccused});
}

final class FilterByIssueNumber extends FilterState {
  final List<AccusedModel> listAccused;

  FilterByIssueNumber({required this.listAccused});
}

final class SearchAccusedByNameOrIssueNumber extends FilterState {
  final List<AccusedModel> listAccused;

  SearchAccusedByNameOrIssueNumber({required this.listAccused});
}

final class EmptyGetAccusedState extends FilterState {}
