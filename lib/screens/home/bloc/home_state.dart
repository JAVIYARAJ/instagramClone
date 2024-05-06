part of 'home_bloc.dart';

class HomeScreenDataHolder {
  List<PostModel> allPosts = [];
  bool isAnimating=false;
  List<String> savedPost=[];
}

@immutable
sealed class HomeState {
  final HomeScreenDataHolder homeData;

  const HomeState(this.homeData);
}

final class HomeInitial extends HomeState {
  HomeInitial(super.homeData);
}

class HomeLoaded extends HomeState {
  HomeLoaded(super.homeData);
}

class HomeLoading extends HomeState {
  HomeLoading(super.homeData);
}

class HomeError extends HomeState {
  final String error;

  HomeError(super.homeData, this.error);
}
