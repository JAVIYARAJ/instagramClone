part of 'edit_profile_bloc.dart';

class EditProfileDataHolder {
  Uint8List? userProfile;
  UserInfo? userInfo;
}

@immutable
sealed class EditProfileState {
  EditProfileDataHolder editProfileDataHolder;

  EditProfileState({required this.editProfileDataHolder});
}

final class EditProfileInitial extends EditProfileState {
  EditProfileInitial({required super.editProfileDataHolder});
}

class EditProfileLoadedState extends EditProfileState {
  EditProfileLoadedState({required super.editProfileDataHolder});
}

class EditProfileLoadingState extends EditProfileState {
  EditProfileLoadingState({required super.editProfileDataHolder});
}

class EditProfileErrorState extends EditProfileState {
  final String error;

  EditProfileErrorState(
      {required super.editProfileDataHolder, required this.error});
}
