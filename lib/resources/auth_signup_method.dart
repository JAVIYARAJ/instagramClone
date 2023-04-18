import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as userModel;
import 'package:instagram_clone/resources/storage_method.dart';

class UserAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String res = '404';
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty) {
        if (file != null) {
          //create user account
          UserCredential credential = await auth.createUserWithEmailAndPassword(
              email: email, password: password);

          //upload image and get that url for store a url in fire store
          String imageUrl = await FirebaseStorageHelper()
              .uploadImageToStorage('userImage', file, false);

          userModel.User user = userModel.User(
              uid: credential.user?.uid,
              username: username,
              email: email,
              photoUrl: imageUrl,
              password: password,
              bio: bio,
              followers: [],
              followings: []);

          //save all the data in fire store
          await firestore
              .collection('users')
              .doc(credential.user?.uid)
              .set(user.toJson());

          res = "301";
        } else {
          res = "102";
        }
      } else {
        res = "101";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'email-already-in-use') {
        res = "401";
      } else if (err.code == 'invalid-email') {
        res = "402";
      } else if (err.code == 'weak-password') {
        res = "403";
      }
    } catch (error) {
      res = "404";
    }
    return res;
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    String res = "404";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        res = "201";
      } else {
        res = "101";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        res = "501";
      } else if (err.code == 'invalid-email') {
        res = "402";
      } else if (err.code == 'wrong-password') {
        res = "502";
      } else if (err.code == 'user-disabled') {
        res = "503";
      }
    } catch (error) {
      res = "404";
    }
    return res;
  }

  Future<Void?> logoutUser() async {
    await auth.signOut();
    return null;
  }

  Future<userModel.User> getUserInfo() async {

    //get current firebase user
    User? currentUser = auth.currentUser;

    //then get fire store data using uid
    DocumentSnapshot snapshot =
        await firestore.collection('users').doc(currentUser?.uid).get();

    return userModel.User.fromSnapshot(snapshot);
  }
}
