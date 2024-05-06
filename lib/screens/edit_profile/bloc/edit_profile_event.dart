part of 'edit_profile_bloc.dart';

@immutable
sealed class EditProfileEvent {}

class EditProfileInitialEvent extends EditProfileEvent{
  final UserInfo? userInfo;

  EditProfileInitialEvent(this.userInfo);
}

class EditProfileImageChangeEvent extends EditProfileEvent{
  final Uint8List image;

  EditProfileImageChangeEvent(this.image);
}

class EditProfileUpdateEvent extends EditProfileEvent{

}