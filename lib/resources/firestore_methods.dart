import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> postCommentLike(
      String commentId, String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (error) {}
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

  Future<String> updateProfile(String uid, String username, String bio,
      Uint8List profileImage, bool isUpdateImage) async {
    String res = "404";
    try {
      await firestore
          .collection("users")
          .doc(uid)
          .update({"username": username, "bio": bio});

      if (isUpdateImage) {
        //update profile with image and data
        final FirebaseAuth auth = FirebaseAuth.instance;
        String updatedImageUrl = await FirebaseStorageHelper()
            .uploadImageToStorage("userImage", profileImage, false);

        await firestore
            .collection("users")
            .doc(uid)
            .update({"profileImage": updatedImageUrl});
        res = "701";
      }
    } catch (error) {
      res = "404";
    }

    return res;
  }

  Future<String> postComment(String uid, String profileUrl, String postId,
      String commentText, String username) async {
    String commentId = const Uuid().v1();
    String res = "404";
    try {
      await firestore
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .set({
        "uid": uid,
        "username": username,
        "profileUrl": profileUrl,
        "postId": postId,
        "commentId": commentId,
        "commentText": commentText,
        "commentDate": DateTime.now(),
        "likes": [],
      });
      res = "801";
    } catch (error) {
      res = "404";
    }
    return res;
  }
}
