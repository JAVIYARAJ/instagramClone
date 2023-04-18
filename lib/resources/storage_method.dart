import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageHelper {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    //ref is null because at this time user don't have an user details.
    Reference reference =
        storage.ref().child(childName).child(auth.currentUser!.uid);

    //if is post then add child and in that child add post image
    if (isPost) {
      String id = const Uuid().v1();  //here v1 method generate random id based on current time.
      reference = reference.child(id);
    }

    UploadTask uploadTask = reference.putData(file);

    //this line use for convert callback in async function
    TaskSnapshot snapshot = await uploadTask;

    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
