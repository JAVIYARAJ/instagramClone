import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/screens/home/model/post_model.dart';
import 'package:instagram_clone/screens/home/repository/home_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial(HomeScreenDataHolder())) {
    final homeRepo = HomeRepository();

    on<HomePostFetchEvent>((event, emit) async {
      try {
        emit(HomeLoading(state.homeData));
        state.homeData.allPosts.clear();
        final posts = await homeRepo.getAllPosts();
        state.homeData.allPosts.addAll(posts);
        emit(HomeLoaded(state.homeData));
      } catch (error) {
        emit(HomeError(state.homeData, error.toString()));
        emit(HomeLoaded(state.homeData));
      }
    });

    on<HomePostLikeEvent>((event, emit) async {
      try {
        state.homeData.allPosts[event.index].isAnimating = true;
        await homeRepo.postLike(event.uid, event.postId, event.allLikes);
        final post = await homeRepo.getSinglePost(event.postId);
        state.homeData.allPosts[event.index] = post;
        emit(HomeLoaded(state.homeData));
      } catch (error) {
        emit(HomeError(state.homeData, error.toString()));
        emit(HomeLoaded(state.homeData));
      }
    });

    on<HomeChangePostAnimation>((event, emit) {
      state.homeData.allPosts[event.index].isAnimating = false;
      emit(HomeLoaded(state.homeData));
    });

    on<HomeSavedFetchPost>((event, emit) {});

    on<HomePostTagShowEvent>((event, emit) {
      state.homeData.allPosts[event.index].isPeopleShow =
          !(state.homeData.allPosts[event.index].isPeopleShow ?? false);
      emit(HomeLoaded(state.homeData));
    });

    on<HomePostMultiImageChange>((event, emit) {
      state.homeData.allPosts[event.index].currentPage = event.page;
      emit(HomeLoaded(state.homeData));
    });
  }
}
