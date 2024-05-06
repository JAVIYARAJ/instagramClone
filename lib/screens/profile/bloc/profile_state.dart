part of 'profile_bloc.dart';

class ProfileDataHolder {
  ProfileInfoModel? profileInfoModel;
}

@immutable
sealed class ProfileState {
  final ProfileDataHolder profileDataHolder;

  ProfileState({required this.profileDataHolder});
}

final class ProfileInitial extends ProfileState {
  ProfileInitial({required super.profileDataHolder});
}

class ProfileLoadingState extends ProfileState {
  ProfileLoadingState({required super.profileDataHolder});
}

class ProfileLoadedState extends ProfileState {
  ProfileLoadedState({required super.profileDataHolder});
}

class ProfileErrorState extends ProfileState {
  final String error;

  ProfileErrorState({required super.profileDataHolder, required this.error});
}
