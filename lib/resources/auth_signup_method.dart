import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    String res = 'failed';
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty &&
          bio.isNotEmpty) {
        //create user account
        UserCredential credential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //upload image and get that url for store a url in fire store
        String imageUrl = await FirebaseStorageHelper().uploadImageToStorage(
            'userImage', file, false);

        //save all the data in fire store
        await firestore.collection('users').doc(credential.user?.uid).set({
          'username': username,
          'email': email,
          'password': password,
          'bio': bio,
          'followers': [],
          'following': [],
          'imageUrl': imageUrl
        });

        res = "Registration successfully";
      } else {
        res = "failed";
      }
    }
    on FirebaseAuthException catch (err) {
      if (err.code == 'email-already-in-use') {
        res = "email already exists";
      } else if (err.code == 'invalid-email') {
        res = "invalid email";
      } else if (err.code == 'weak-password') {
        res = "please enter strong password";
      }
    }
    catch (error) {
      res = error.toString();
    }

    return res;
  }

  Future<String> signInUser({
    required String email,
    required String password
  }) async {
    String res = "Some error occurred";

    if (email.isNotEmpty && password.isNotEmpty) {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      res = "200";
    } else {
      res = "201";
    }

    return res;
  }

}