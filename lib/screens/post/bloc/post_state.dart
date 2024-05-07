part of 'post_bloc.dart';

class PostDataHolder {
  List<File> localImages = [];
  List<File> selectedImages = [];
  List<UserInfo> tagPeople = [];
  List<PostTagCoordinateModel> tagPeopleSelected = [];
  bool isMultiSelect = false;
  int mediaCounter = 0;
  bool isTagControlShow = false;
}

class PostTagCoordinateModel {
  final Offset offset;
  UserInfo? user;

  PostTagCoordinateModel(this.offset, {this.user});
}

@immutable
sealed class PostState {
  PostDataHolder postDataHolder;

  PostState(this.postDataHolder);
}

final class PostInitial extends PostState {
  PostInitial(super.postDataHolder);
}

class PostLoading extends PostState {
  PostLoading(super.postDataHolder);
}

class PostLoaded extends PostState {
  final bool isDirect;

  PostLoaded(super.postDataHolder, {this.isDirect = false});
}

class PostError extends PostState {
  PostError(super.postDataHolder, this.error);

  final String error;
}
