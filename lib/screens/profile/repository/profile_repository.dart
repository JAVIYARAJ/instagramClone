import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/screens/home/model/post_model.dart';

class ProfileRepository {
  final firebase = FirebaseFirestore.instance;

  Future<List<PostModel>> getUserPosts(String uid) async {
    try {
      List<PostModel> posts = [];
      QuerySnapshot snapshot =
          await firebase.collection("posts").where("uid", isEqualTo: uid).get();

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

  Future<void> requestQueue(String uid) async {
    await firebase.collection("users").doc(uid).update({
      "requested": FieldValue.arrayUnion([uid])
    });
  }
}
