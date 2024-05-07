part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class ProfileUserFetchEvent extends ProfileEvent {
  final String? uid;

  ProfileUserFetchEvent(this.uid);
}

class ProfileFollowRequest extends ProfileEvent {
  final String senderId;
  final String followId;
  final bool isAccountPrivate;

  ProfileFollowRequest(
      {required this.senderId,
      required this.followId,
      required this.isAccountPrivate});
}

class ProfileConfirmRequestEvent extends ProfileEvent{
  final bool isDelete;

  ProfileConfirmRequestEvent({this.isDelete=false});
}