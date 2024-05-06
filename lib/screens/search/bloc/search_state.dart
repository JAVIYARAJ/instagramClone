part of 'search_bloc.dart';

class SearchDataHolder {
  List<PostModel> allPosts = [];
  List<UserInfo> users=[];
}

@immutable
sealed class SearchState {
  final SearchDataHolder searchDataHolder;

  const SearchState({required this.searchDataHolder});
}

final class SearchInitial extends SearchState {
  const SearchInitial({required super.searchDataHolder});
}

class SearchLoadedState extends SearchState {
  const SearchLoadedState({required super.searchDataHolder});
}

class SearchLoadingState extends SearchState {
  const SearchLoadingState({required super.searchDataHolder});
}

class SearchErrorState extends SearchState {
  const SearchErrorState({required super.searchDataHolder, required this.error});

  final String error;
}
