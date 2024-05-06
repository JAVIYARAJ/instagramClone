import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart';

class PostRepository {
  final firebase = FirebaseFirestore.instance;

  Future<List<UserInfo>> getTagUsersWithQuery(String query) async {
    List<UserInfo> users = [];
    QuerySnapshot snapshot = await firebase
        .collection("users")
        .where("username", isGreaterThanOrEqualTo: query)
        .get();
    for (var doc in snapshot.docs) {
      final userInfo = UserInfo.fromJson(doc.data() as Map<String,dynamic>);
      if (userInfo.uid != FirebaseAuth.instance.currentUser?.uid) {
        users.add(userInfo);
      }
    }
    return users;
  }
}
