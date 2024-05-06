import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as userModel;
import 'package:instagram_clone/resources/storage_method.dart';

class UserAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> signUpUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    try {
      //create user account
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //upload image and get that url for store a url in fire store
      String imageUrl = await FirebaseStorageHelper()
          .uploadImageToStorage('userImage', file, false);

      userModel.UserInfo user = userModel.UserInfo(
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
    } on FirebaseAuthException catch (err) {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future<UserCredential?> signInUser(
      {required String email, required String password}) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (err) {
      print("error code ${err.code}");
      if (err.code == 'email-already-in-use') {
        rethrow;
      } else if (err.code == 'invalid-email') {
        rethrow;
      } else if (err.code == 'weak-password') {
        rethrow;
      }else{
        rethrow;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Void?> logoutUser() async {
    await auth.signOut();
    return null;
  }

  Future<userModel.UserInfo> getUserInfo() async {
    //get current firebase user
    User? currentUser = auth.currentUser;

    //then get fire store data using uid
    DocumentSnapshot snapshot =
        await firestore.collection('users').doc(currentUser?.uid).get();

    return userModel.UserInfo.fromJson(snapshot.data() as Map<String,dynamic>);
  }
}
