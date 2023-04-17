import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart' as post;
import 'package:instagram_clone/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String caption, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = "404";
    try {
      String photoUrl = await FirebaseStorageHelper()
          .uploadImageToStorage('post', file, true);

      String postId = const Uuid().v1();

      post.UserPost userPost = post.UserPost(
          uid: uid,
          username: username,
          profileImage: profileImage,
          caption: caption,
          postId: postId,
          postUrl: photoUrl,
          datePublished: DateTime.now(),
          likes: []);

      await firestore.collection('posts').doc(postId).set(userPost.toJson());
      res = "601";
    } catch (error) {
      res = "404";
    }
    return res;
  }

  Future<void> postLike(String uid, String postId, List likes) async {

    try {
      if (likes.contains(uid)) {
        await firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  bool isUserLikedPost(
    String uid,
    List likes,
  ) {
    if (likes.contains(uid)) {
      return true;
    } else {
      return false;
    }
  }
}
