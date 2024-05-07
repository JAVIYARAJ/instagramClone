import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/core/enums.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/screens/home/model/post_model.dart';
import 'package:instagram_clone/screens/profile/model/request_model.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:uuid/uuid.dart';

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

  Future<void> followUser(
      String senderId, String followId, bool isPrivateProfile) async {
    if (isPrivateProfile) {
      final requestId = const Uuid().v1();
      final createdAt = dateToString(DateTime.now());

      final sendingRequest = RequestModel(
          id: requestId,
          followId: senderId,
          status: RequestType.requested.name,
          createdAt: createdAt,
          updatedAt: createdAt);

      await firebase
          .collection("users")
          .doc(followId)
          .collection("requests")
          .doc(requestId)
          .set(sendingRequest.toJson());
    } else {
      firebase.collection("users").doc(senderId).update({
        "followings": FieldValue.arrayUnion([followId])
      });
      firebase.collection("users").doc(followId).update({
        "followers": FieldValue.arrayUnion([senderId])
      });
    }
  }

  Future<List<RequestModel>> getAllRequests(String userId) async {
    QuerySnapshot snapshot = await firebase
        .collection("users")
        .doc(userId)
        .collection("requests")
        .get();
    List<RequestModel> allRequests = [];

    for (var data in snapshot.docs) {
      allRequests
          .add(RequestModel.fromJson(data.data() as Map<String, dynamic>));
    }

    allRequests
        .where((element) => element.status == RequestType.requested.name);

    return allRequests;
  }

  Future<RequestModel?> getRequestStatus(
      String userId, String profileId) async {
    QuerySnapshot snapshot = await firebase
        .collection("users")
        .doc(profileId)
        .collection("requests")
        .where("followId", isEqualTo: userId)
        .get();

    var request = snapshot?.docs?.firstOrNull?.data();
    if (request != null) {
      return RequestModel.fromJson(request as Map<String, dynamic>);
    }
  }

  Future<void> confirmRequest(String userId, String followId, String requestId,
      {bool isDeleteRequest = false}) async {
    firebase
        .collection("users")
        .doc(userId)
        .collection("requests")
        .doc(requestId)
        .delete();
    if (!isDeleteRequest) {
      firebase.collection("users").doc(userId).update({
        "followers": FieldValue.arrayUnion([followId])
      });
      firebase.collection("users").doc(followId).update({
        "followings": FieldValue.arrayUnion([userId])
      });
    }
  }
}
