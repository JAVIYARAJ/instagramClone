import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/resources/auth_signup_method.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authRepo = UserAuth();

  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit) async{
      try {
        emit(AuthLoading(selectedFile: state.selectedFile));
        final user=await authRepo.signInUser(email: event.email, password: event.password);
        emit(AuthLoaded(isRedirect: user!=null, selectedFile: state.selectedFile));
      } catch (error) {
        emit(AuthError(
            error: error.toString(), selectedFile: state.selectedFile));
        emit(AuthLoaded(selectedFile: state.selectedFile));
      }
    });

    on<AuthRegisterEvent>((event, emit) {
      try {
        emit(AuthLoading(selectedFile: state.selectedFile));
        if (state.selectedFile != null) {
          authRepo.signUpUser(
              email: event.email,
              password: event.password,
              username: event.username,
              bio: event.bio,
              file: state.selectedFile!);
          emit(AuthLoaded(isRedirect: true, selectedFile: state.selectedFile));
        } else {
          emit(AuthError(
              error: "please select profile image",
              selectedFile: state.selectedFile));
          emit(AuthLoaded(selectedFile: state.selectedFile));
        }
      } catch (error) {
        emit(AuthError(
            error: error.toString(), selectedFile: state.selectedFile));
        emit(AuthLoaded(selectedFile: state.selectedFile));
      }
    });

    on<PickImageEvent>((event, emit) {
      state.selectedFile = event.pickedFile;
      emit(AuthLoaded(selectedFile: state.selectedFile,isUserLogin: state.isUserLogin));
    });

    on<CheckUserLogin>((event, emit){
      state.isUserLogin=FirebaseAuth.instance.currentUser!=null;
      emit(AuthLoaded(selectedFile: state.selectedFile,isUserLogin: state.isUserLogin));

    });

  }
}
