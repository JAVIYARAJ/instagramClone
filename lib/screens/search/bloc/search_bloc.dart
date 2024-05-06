import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/screens/home/model/post_model.dart';
import 'package:instagram_clone/screens/home/repository/home_repository.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final homeRepo = HomeRepository();
  final searchController = TextEditingController();

  SearchBloc() : super(SearchInitial(searchDataHolder: SearchDataHolder())) {
    on<SearchFetchPostEvent>((event, emit) async {
      try {
        emit(SearchLoadingState(searchDataHolder: state.searchDataHolder));
        state.searchDataHolder.allPosts.clear();
        final posts = await homeRepo.getAllPosts();
        state.searchDataHolder.allPosts.addAll(posts);
        emit(SearchLoadedState(searchDataHolder: state.searchDataHolder));
      } catch (error) {
        emit(SearchErrorState(
            searchDataHolder: state.searchDataHolder, error: error.toString()));
        emit(SearchLoadedState(searchDataHolder: state.searchDataHolder));
      }
    });

    on<SearchUserQueryEvent>((event, emit) async {
      try {
        emit(SearchLoadingState(searchDataHolder: state.searchDataHolder));
        state.searchDataHolder.users.clear();
        final users = await homeRepo.getAllUsers();
        state.searchDataHolder.users.addAll(users);
        emit(SearchLoadedState(searchDataHolder: state.searchDataHolder));
      } catch (error) {
        emit(SearchErrorState(
            searchDataHolder: state.searchDataHolder, error: error.toString()));
        emit(SearchLoadedState(searchDataHolder: state.searchDataHolder));
      }
    });
    on<SearchQueryClearEvent>((event, emit) {
      searchController.clear();
      emit(SearchLoadedState(searchDataHolder: state.searchDataHolder));
    });
  }
}
