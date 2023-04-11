import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/storage_method.dart';

class UserAuth{

  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List file,
  }) async{
    final FirebaseAuth auth=FirebaseAuth.instance;
    final FirebaseFirestore firestore=FirebaseFirestore.instance;
    String res='failed';
    try{
      if(username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && bio.isNotEmpty){

        UserCredential credential=await auth.createUserWithEmailAndPassword(email: email, password: password);

        String imageUrl= await FirebaseStorageHelper().uploadImageToStorage('userImage', file, false);

        await firestore.collection('users').doc(credential.user?.uid).set({
          'username':username,
          'email':email,
          'password':password,
          'bio':bio,
          'followers':[],
          'following':[],
          'imageUrl':imageUrl
        });

        res="success";
        
      }else{
          res="failed";
      }
    }catch(error){
      res=error.toString();
    }

    return res;
  }

}