part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  Uint8List? selectedFile;
  bool isUserLogin;

  AuthState({this.selectedFile,this.isUserLogin=false});
}

final class AuthInitial extends AuthState {
  AuthInitial({super.selectedFile,super.isUserLogin});
}

final class AuthLoaded extends AuthState {
  final bool isRedirect;

  AuthLoaded({this.isRedirect=false, super.selectedFile,super.isUserLogin});
}

final class AuthError extends AuthState {
  final String error;

  AuthError({required this.error, super.selectedFile,super.isUserLogin});
}

final class AuthLoading extends AuthState {
  AuthLoading({ super.selectedFile,super.isUserLogin});
}
