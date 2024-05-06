part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomePostFetchEvent extends HomeEvent{

}
class HomePostLikeEvent extends HomeEvent{
  final String uid;
  final String postId;
  final List<String> allLikes;
  final int index;

  HomePostLikeEvent({required this.uid, required this.postId, required this.allLikes,required this.index});
}

class HomeChangePostAnimation extends HomeEvent{
  final int index;

  HomeChangePostAnimation(this.index);
}

class HomeSavedFetchPost extends HomeEvent{

}

class HomePostTagShowEvent extends HomeEvent{
  final int index;

  HomePostTagShowEvent({required this.index});
}

class HomePostMultiImageChange extends HomeEvent{
  final int page;
  final int index;

  HomePostMultiImageChange({required this.page,required this.index});
}