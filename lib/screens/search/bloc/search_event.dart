part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

class SearchFetchPostEvent extends SearchEvent{

}

class SearchUserQueryEvent extends SearchEvent{
  final String query;

  SearchUserQueryEvent({required this.query});
}

class SearchQueryClearEvent extends SearchEvent{

}