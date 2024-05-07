import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/enums.dart';
import 'package:instagram_clone/core/local_image_helper.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/resources/storage_method.dart';
import 'package:instagram_clone/screens/home/model/post_model.dart';
import 'package:instagram_clone/screens/post/repository/post_repository.dart';
import 'package:permission_handler/permission_handler.dart';

part 'post_event.dart';

part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final postRepo = PostRepository();

  final tagController = TextEditingController();

  PostBloc() : super(PostInitial(PostDataHolder())) {
    on<PostPickMedia>((event, emit) {
      if (!state.postDataHolder.isMultiSelect) {
        state.postDataHolder.selectedImages.clear();
        state.postDataHolder.selectedImages.add(event.file);
      } else {
        var index = state.postDataHolder.selectedImages.indexOf(event.file);
        if (index == -1) {
          state.postDataHolder.selectedImages.add(event.file);
        } else {
          state.postDataHolder.selectedImages.remove(event.file);
        }
      }
      emit(PostLoaded(state.postDataHolder));
    });

    on<PostGetLocalMedia>((event, emit) async {
      try {
        emit(PostLoading(state.postDataHolder));
        final status = await Permission.photos.status;
        if (status.isGranted) {
          final images = await LocalImageHelper.getLocalImages();
          state.postDataHolder.localImages.clear();
          state.postDataHolder.localImages.addAll(images);
          state.postDataHolder.selectedImages.add(images.first);
          emit(PostLoaded(state.postDataHolder));
        } else {
          await Permission.photos.request();
          add(PostGetLocalMedia());
        }
        LocalImageHelper.getLocalImages();
      } catch (error) {
        emit(PostError(state.postDataHolder, error.toString()));
        emit(PostLoaded(state.postDataHolder));
      }
    });

    on<PostMediaSelectType>((event, emit) {
      state.postDataHolder.isMultiSelect = !state.postDataHolder.isMultiSelect;
      if (state.postDataHolder.isMultiSelect) {
        state.postDataHolder.selectedImages.clear();
        state.postDataHolder.selectedImages
            .add(event.file ?? state.postDataHolder.localImages.first);
      } else {
        if (state.postDataHolder.selectedImages.isNotEmpty) {
          final lastSelectedImage = state.postDataHolder.selectedImages.last;
          state.postDataHolder.selectedImages.clear();
          state.postDataHolder.selectedImages.add(lastSelectedImage);
        }
      }
      emit(PostLoaded(state.postDataHolder));
    });

    on<PostTagSearchPeopleEvent>((event, emit) async {
      emit(PostLoading(state.postDataHolder));
      final users = await postRepo.getTagUsersWithQuery(event.query);
      state.postDataHolder.tagPeople.clear();
      state.postDataHolder.tagPeople.addAll(users);
      emit(PostLoaded(state.postDataHolder));
    });

    on<PostTagPositionChanged>((event, emit) {
      if (event.offset != null) {
        if (state.postDataHolder.tagPeopleSelected.isNotEmpty) {
          if (state.postDataHolder.tagPeopleSelected.last.user == null) {
            state.postDataHolder.tagPeopleSelected.removeLast();
          }
        }
        state.postDataHolder.tagPeopleSelected
            .add(PostTagCoordinateModel(event.offset!));
        state.postDataHolder.isTagControlShow = true;
      } else {
        state.postDataHolder.isTagControlShow = false;
      }
      emit(PostLoaded(state.postDataHolder));
    });

    on<PostTagSelectEvent>((event, emit) {
      if (event.isClear) {
        state.postDataHolder.tagPeopleSelected.clear();
      }
      state.postDataHolder.tagPeopleSelected.last?.user = event.user;
      state.postDataHolder.isTagControlShow = false;
      emit(PostLoaded(state.postDataHolder));
    });

    on<PostTagSelectPeopleRemove>((event, emit) {
      if (state.postDataHolder.tagPeopleSelected.isNotEmpty) {
        state.postDataHolder.tagPeopleSelected.removeAt(event.index);
      }
      emit(PostLoaded(state.postDataHolder));
    });

    on<PostTagClearEvent>((event, emit) {
      if (event.isRemoveLastTag) {
        state.postDataHolder.tagPeopleSelected.removeLast();
      }
      tagController.clear();
      emit(PostLoaded(state.postDataHolder));
    });

    on<PostClearEvent>((event, emit) {
      state.postDataHolder.selectedImages.clear();
      state.postDataHolder.tagPeopleSelected.clear();
      state.postDataHolder.isTagControlShow = false;
      state.postDataHolder.tagPeople.clear();
      state.postDataHolder.localImages.clear();
      state.postDataHolder.isMultiSelect = false;
      emit(PostLoaded(state.postDataHolder));
    });

    on<PostCreateEvent>((event, emit) async {
      try {
        emit(PostLoading(state.postDataHolder));
        final uploadUrls = await FirebaseStorageHelper.uploadImages(
            state.postDataHolder.selectedImages,
            FirebaseAuth.instance.currentUser?.uid ?? "");

        await FireStoreMethods().uploadPost(
            event.caption,
            uploadUrls,
            FirebaseAuth.instance.currentUser?.uid ?? "",
            state.postDataHolder.tagPeopleSelected
                .map((e) => PeopleTagModel(id: e.user?.uid??"",dx: e.offset?.dx,dy: e.offset?.dy,username: e?.user?.username))
                .toList());

        emit(PostLoaded(state.postDataHolder,isDirect: true));
      } catch (error) {
        emit(PostError(state.postDataHolder, error.toString()));
        emit(PostLoaded(state.postDataHolder));
      }
    });
  }
}
