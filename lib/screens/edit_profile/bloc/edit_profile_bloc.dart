import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/models/user.dart';

part 'edit_profile_event.dart';

part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final username = TextEditingController();
  final bio = TextEditingController();
  EditProfileBloc()
      : super(EditProfileInitial(
            editProfileDataHolder: EditProfileDataHolder())) {

    on<EditProfileInitialEvent>((event, emit) {
      try {
        emit(EditProfileLoadingState(
            editProfileDataHolder: state.editProfileDataHolder));
        state.editProfileDataHolder.userInfo = event.userInfo;
        username.text = event.userInfo?.username ?? "";
        bio.text = event.userInfo?.bio ?? "";
        emit(EditProfileLoadedState(
            editProfileDataHolder: state.editProfileDataHolder));
      } catch (error) {
        emit(EditProfileErrorState(
            editProfileDataHolder: state.editProfileDataHolder,
            error: error.toString()));
        emit(EditProfileLoadedState(
            editProfileDataHolder: state.editProfileDataHolder));
      }
    });

    on<EditProfileImageChangeEvent>((event, emit){
      state.editProfileDataHolder.userProfile=event.image;
      emit(EditProfileLoadedState(
          editProfileDataHolder: state.editProfileDataHolder));
    });

    on<EditProfileUpdateEvent>((event, emit){
      try {
        emit(EditProfileLoadingState(
            editProfileDataHolder: state.editProfileDataHolder));



        emit(EditProfileLoadedState(
            editProfileDataHolder: state.editProfileDataHolder));
      } catch (error) {
        emit(EditProfileErrorState(
            editProfileDataHolder: state.editProfileDataHolder,
            error: error.toString()));
        emit(EditProfileLoadedState(
            editProfileDataHolder: state.editProfileDataHolder));
      }
    });

  }
}
