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

  Future<int> postCount(dynamic uid) async {
    var response = await firestore.collection("posts").get();
    var docs = response.docs;

    var res = docs
        .map((e) => e.data().map((key, value) => MapEntry(key, value)))
        .toList();

    var count = 0;
    for (var i = 0; i < res.length; i++) {
      if (res[i]["uid"] == uid) {
        count++;
      }
    }
    return count;
  }

  Future<int> commentCount(String postId) async {
    var response = await firestore
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .get();
    return response.docs.length;
  }

  Future<void> followUser(String cuid, String followId) async {
    try {
      //cuid -> current user uid
      //followId -> person id that you want to follow or unfollow

      //get all info for current user
      var response = await firestore.collection("users").doc(cuid).get();

      var data = response.data();
      //get current user followings
      var followings = data!["followings"] ?? [];

      //if you are already follow that person
      if (followings.contains(followId)) {
        //go to follow person document and update followers info

        //and remove that person from the other person followers list
        await firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayRemove([cuid])
        });

        //and remove that current person id from the its following list
        await firestore.collection("users").doc(cuid).update({
          "followings": FieldValue.arrayRemove([followId])
        });
      }
      //if you are not follow that person
      else {
        //and add current person id into other person followers list
        await firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayUnion([cuid])
        });

        //and other person id insert into current person following list
        await firestore.collection("users").doc(cuid).update({
          "followings": FieldValue.arrayUnion([followId])
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<List<Map<String, dynamic>>?> getUserFollowersAndFollowingsData(
      String uid, bool flag) async {
    var response = await firestore.collection("users").doc(uid).get();

    var userList = [];

    List<Map<String, dynamic>> userData = [];

    if (response.exists) {
      userList = flag ? response["followers"] : response["followings"];
    }

    for (var i = 0; i < userList.length; i++) {
      var response = await firestore.collection("users").doc(userList[i]).get();

      var data = response.data();
      userData.add(data!);
    }

    return userData;
  }

  void updateAccountType(bool value, String uid) async {
    await firestore.collection("users").doc(uid).update({"isPrivate": value});
  }

  void sendFollowRequest(String userId, String currentUserId,
      String profileImage, String username) async {
    //store follow coming request into followed person account
    await firestore
        .collection("users")
        .doc(userId)
        .collection("followersRequests")
        .doc(
            currentUserId) //here follow request sender user id because only one
        // follow request send to other user from one account.
        .set({
      "uid": currentUserId,
      "username": username,
      "userPhoto": profileImage,
      "followersDate": DateTime.now(),
      "status": false
    });

    //store follow request into current user account
    await firestore
        .collection("users")
        .doc(currentUserId)
        .collection("followingRequests")
        .doc(userId)
        .set({"uid": userId, "followingDate": DateTime.now(), "status": false});
  }

  void confirmFollowRequest(String userId, String currentUserId) async {
    //change status of follow request pending into approved in follower person account and save follow request into followers account.

    await firestore
        .collection("users")
        .doc(currentUserId)
        .collection("followersRequests")
        .doc(userId)
        .delete();

    await firestore
        .collection("users")
        .doc(userId)
        .collection("followingRequests")
        .doc(currentUserId)
        .delete();

    await followUser(userId, currentUserId);
  }

  Future<bool> checkFollowRequest(String uid, String followId) async {
    var response = await firestore
        .collection("users")
        .doc(uid)
        .collection("followingRequests")
        .doc(followId)
        .get();

    var data = response.data();
    if (data != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> getRequestCount(String uid) async {
    var response = await firestore
        .collection("users")
        .doc(uid)
        .collection("followingRequests")
        .get();

    var data = response.docs;
    return data.length;
  }

  Future<List<dynamic>> getSavedPost(String uid) async {
    var response = await firestore.collection("users").doc(uid).get();
    return response["saved"] as List<dynamic>;
  }

  Future<void> savePost(String uid, String postId) async {
    var saved = await getSavedPost(uid);
    //remove saved post if exists
    if (saved.contains(postId)) {
      await firestore.collection("users").doc(uid).update({
        "saved": FieldValue.arrayRemove([postId])
      });
    } else {
      //save post
      await firestore.collection("users").doc(uid).update({
        "saved": FieldValue.arrayUnion([postId])
      });
    }
  }

  Future<List<Map<String, dynamic>>> getSavedAllPost(String uid) async {
    var savedPostId = await getSavedPost(uid);

    List<Map<String, dynamic>> postList = [];

    for (var i = 0; i < savedPostId.length; i++) {
      var response =
          await firestore.collection("posts").doc(savedPostId[i]).get();

      var postData = response.data();
      postList.add(postData!);
    }

    return postList;
  }

  Future<bool> isPostSaved(String postId, String uid) async {
    var saved = await getSavedPost(uid);
    if (saved.contains(postId)) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map> getLatLikeUserInfo(String postId) async {
    var likeInfo = {};
    var response = await firestore.collection("posts").doc(postId).get();
    var count = response['likes'] as List<dynamic>;

    if (response['likes'][0] != null) {
      var userInfo =
          await firestore.collection("users").doc(response["likes"][0]).get();

      var user=userInfo.data();
      if(user!=null){
      likeInfo = {
        "lastLikeUser": user,
        "count": count.length,
        "status":true,
      };
      }else{
        likeInfo = {
          "lastLikeUser": {},
          "count": count.length,
          "status":false,
        };
      }
    }else{
      likeInfo = {
        "lastLikeUser": {},
        "count": count.length,
      };
    }
    return likeInfo;
  }
}
