import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/auth_signup_method.dart';

class UserProvider extends ChangeNotifier {
  model.User? _user;
  final UserAuth userAuth = UserAuth();

  model.User get getUser => _user!;

  Future<void> refreshUser() async {
    model.User userInfo = await userAuth.getUserInfo();
    _user = userInfo;
    notifyListeners();
  }
}
