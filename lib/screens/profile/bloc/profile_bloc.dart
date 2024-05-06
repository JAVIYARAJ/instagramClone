import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/screens/home/repository/home_repository.dart';
import 'package:instagram_clone/screens/profile/model/profile_info_model.dart';
import 'package:instagram_clone/screens/profile/repository/profile_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final homeRepo = HomeRepository();
  final profileRepo = ProfileRepository();

  ProfileBloc()
      : super(ProfileInitial(profileDataHolder: ProfileDataHolder())) {
    on<ProfileUserFetchEvent>((event, emit) async {
      try {
        emit(ProfileLoadingState(profileDataHolder: state.profileDataHolder));
        final uid = event.uid ?? FirebaseAuth.instance?.currentUser?.uid ?? "";
        final userInfo = await homeRepo.getUserById(uid);
        final posts = await profileRepo.getUserPosts(uid);

        final isPostShow = uid == FirebaseAuth.instance.currentUser?.uid ||
            ((userInfo.isPrivate ?? false)
                ? (state.profileDataHolder.profileInfoModel?.userInfo
                            ?.followers ??
                        [])
                    .contains(FirebaseAuth.instance.currentUser?.uid)
                : true);

        final profileInfo = ProfileInfoModel(
            userInfo: userInfo,
            allPosts: posts,
            uid: FirebaseAuth.instance.currentUser?.uid,
            isPostShow: isPostShow,isEditAllow: event.uid==null);

        state.profileDataHolder.profileInfoModel = profileInfo;
        emit(ProfileLoadedState(profileDataHolder: state.profileDataHolder));
      } catch (error) {
        emit(ProfileErrorState(
            profileDataHolder: state.profileDataHolder,
            error: error.toString()));
        emit(ProfileLoadedState(profileDataHolder: state.profileDataHolder));
      }
    });
  }
}
