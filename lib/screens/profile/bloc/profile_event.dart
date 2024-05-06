part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class ProfileUserFetchEvent extends ProfileEvent{
  final String? uid;

  ProfileUserFetchEvent(this.uid);
}