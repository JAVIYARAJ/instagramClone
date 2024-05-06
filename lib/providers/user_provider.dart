import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/auth_signup_method.dart';

class UserProvider extends ChangeNotifier {
  model.UserInfo? _user;
  final UserAuth userAuth = UserAuth();

  model.UserInfo get getUser => _user!;

  Future<void> refreshUser() async {
    model.UserInfo userInfo = await userAuth.getUserInfo();
    _user = userInfo;
    notifyListeners();
  }
}
