part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLoginEvent extends AuthEvent{
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});
}

class AuthRegisterEvent extends AuthEvent{
  final String email;
  final String username;
  final String password;
  final String bio;

  AuthRegisterEvent({required this.email, required this.password,required this.username,required this.bio});
}


class PickImageEvent extends AuthEvent{
  Uint8List? pickedFile;

  PickImageEvent(this.pickedFile);
}

class CheckUserLogin extends AuthEvent{

}