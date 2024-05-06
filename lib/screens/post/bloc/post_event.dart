part of 'post_bloc.dart';

@immutable
sealed class PostEvent {}

class PostPickMedia extends PostEvent{
  File file;
  PostPickMedia(this.file);
}

class PostGetLocalMedia extends PostEvent{

}

class PostMediaSelectType extends PostEvent{
  File? file;

  PostMediaSelectType({this.file});
}


class PostTagSearchPeopleEvent extends PostEvent{
  final String query;

  PostTagSearchPeopleEvent(this.query);
}

class PostTagPositionChanged extends PostEvent{
  final Offset? offset;

  PostTagPositionChanged(this.offset);
}

class PostTagSelectEvent extends PostEvent{
  final UserInfo user;
  final bool isClear;
  PostTagSelectEvent(this.user,{this.isClear=false});
}

class PostTagSelectPeopleRemove extends PostEvent{
  final int index;

  PostTagSelectPeopleRemove(this.index);
}

class PostTagClearEvent extends PostEvent{
  final bool isRemoveLastTag;

  PostTagClearEvent({this.isRemoveLastTag=false});
}

class PostClearEvent extends PostEvent{

}

class PostCreateEvent extends PostEvent{
  final String caption;

  PostCreateEvent(this.caption);
}