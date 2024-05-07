import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/enums.dart';
import 'package:instagram_clone/screens/home/repository/home_repository.dart';
import 'package:instagram_clone/screens/profile/model/profile_info_model.dart';
import 'package:instagram_clone/screens/profile/model/request_model.dart';
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
        final currentUser = FirebaseAuth.instance.currentUser?.uid;
        final uid = event.uid ?? currentUser ?? "";
        final userInfo = await homeRepo.getUserById(uid);
        final posts = await profileRepo.getUserPosts(uid);

        List<ProfileActionModel> actions = [];
        RequestModel? requestModel;

        if (currentUser == (userInfo.uid ?? "")) {
          //for current user profile
          actions.add(ProfileActionModel(name: "Edit Profile"));
          actions.add(ProfileActionModel(name: "Share Profile"));
        } else {
          if (event.uid != null) {
            final sendingRequest = await profileRepo.getRequestStatus(
                FirebaseAuth.instance.currentUser?.uid ?? "", event.uid ?? "");

            if (sendingRequest != null) {
              if (sendingRequest?.status == RequestType.requested.name) {
                actions.add(
                    ProfileActionModel(name: "Requested", isDisable: true));
              } else if (sendingRequest?.status == RequestType.rejected.name) {
                actions
                    .add(ProfileActionModel(name: "Rejected", isDisable: true));
              } else {
                actions.add(ProfileActionModel(name: "Following"));
                actions.add(ProfileActionModel(name: "Message"));
              }
            } else {
              final isExists =
                  (userInfo?.followers?.contains(currentUser) ?? false) ||
                      (userInfo?.followings?.contains(currentUser) ?? false);
              if (isExists) {
                actions.add(ProfileActionModel(name: "Following"));
                actions.add(ProfileActionModel(name: "Message"));
              } else {
                actions.add(ProfileActionModel(name: "Follow"));
                //this for check confirm received request dialog
                final receivedRequest = await profileRepo.getRequestStatus(
                    event.uid ?? "",
                    FirebaseAuth.instance.currentUser?.uid ?? "");

                if (receivedRequest != null) {
                  if (receivedRequest?.status == RequestType.requested.name) {
                    requestModel = receivedRequest;
                  }
                }
              }
            }
          } else {
            actions.add(ProfileActionModel(name: "Follow"));
          }
        }

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
            isPostShow: isPostShow,
            isEditAllow: event.uid == null,
            actions: actions,
            requestModel: requestModel);

        state.profileDataHolder.profileInfoModel = profileInfo;
        emit(ProfileLoadedState(profileDataHolder: state.profileDataHolder));
      } catch (error) {
        emit(ProfileErrorState(
            profileDataHolder: state.profileDataHolder,
            error: error.toString()));
        emit(ProfileLoadedState(profileDataHolder: state.profileDataHolder));
      }
    });
    on<ProfileFollowRequest>((event, emit) async {
      try {
        emit(ProfileLoadingState(profileDataHolder: state.profileDataHolder));
        await profileRepo.followUser(
            event.senderId, event.followId, event.isAccountPrivate);
        add(ProfileUserFetchEvent(
            state.profileDataHolder.profileInfoModel?.userInfo?.uid));
      } catch (error) {
        emit(ProfileErrorState(
            profileDataHolder: state.profileDataHolder,
            error: error.toString()));
        emit(ProfileLoadedState(profileDataHolder: state.profileDataHolder));
      }
    });

    on<ProfileConfirmRequestEvent>((event, emit) async {
      try {
        emit(ProfileLoadingState(profileDataHolder: state.profileDataHolder));
        await profileRepo.confirmRequest(
            FirebaseAuth.instance.currentUser?.uid ?? "",
            state.profileDataHolder.profileInfoModel?.requestModel?.followId ??
                "",
            state.profileDataHolder.profileInfoModel?.requestModel?.id ?? "",
            isDeleteRequest: event.isDelete);
        add(ProfileUserFetchEvent(
            state.profileDataHolder.profileInfoModel?.userInfo?.uid));
      } catch (error) {
        emit(ProfileErrorState(
            profileDataHolder: state.profileDataHolder,
            error: error.toString()));
        emit(ProfileLoadedState(profileDataHolder: state.profileDataHolder));
      }
    });
  }
}
