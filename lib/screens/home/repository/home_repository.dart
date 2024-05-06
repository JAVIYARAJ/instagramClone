import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/screens/home/model/post_model.dart';

class HomeRepository {
  final firebase = FirebaseFirestore.instance;

  Future<List<PostModel>> getAllPosts() async {
    try {
      List<PostModel> posts = [];
      QuerySnapshot snapshot = await firebase
          .collection("posts")
          //.where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();
      for (var doc in snapshot.docs) {
        PostModel model =
            PostModel.fromJson(doc.data() as Map<String, dynamic>);

        if (model.uid != null) {
          UserInfo user = await getUserById((model.uid ?? ""));
          if (user != null) {
            model.user = user;
          }
        }

        //get last likes user info
        if ((model.likes ?? []).isNotEmpty) {
          UserInfo user = await getUserById((model.likes ?? []).last);
          if (user != null) {
            model.lastLikes = user;
          }
        }
        posts.add(model);
      }
      return posts;
    } catch (error) {
      rethrow;
    }
  }

  Future<UserInfo> getUserById(String id) async {
    DocumentSnapshot user = await firebase.collection("users").doc(id).get();
    return UserInfo.fromJson(user.data() as Map<String, dynamic>);
  }

  Future<void> postLike(String uid, String postId, List likes) async {
    try {
      await firebase.collection("posts").doc(postId).update({
        "likes": likes.contains(uid)
            ? FieldValue.arrayRemove([uid])
            : FieldValue.arrayUnion([uid]),
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<PostModel> getSinglePost(String postId) async {
    DocumentSnapshot querySnapshot =
        await firebase.collection("posts").doc(postId).get();

    PostModel post =
        PostModel.fromJson(querySnapshot.data() as Map<String, dynamic>);
    if ((post.likes ?? []).isNotEmpty) {
      UserInfo user = await getUserById((post.likes ?? []).last);
      if (user != null) {
        post.lastLikes = user;
      }
    }
    return post;
  }

  Future<List<UserInfo>> getAllUsers() async {
    List<UserInfo> userInfo = [];
    QuerySnapshot querySnapshot = await firebase
        .collection("users")
        .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    for (var doc in querySnapshot.docs) {
      userInfo.add(UserInfo.fromJson(doc.data() as Map<String, dynamic>));
    }
    return userInfo;
  }
}
