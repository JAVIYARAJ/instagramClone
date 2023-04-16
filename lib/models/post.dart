import 'package:cloud_firestore/cloud_firestore.dart';

class UserPost {
  final String? uid;
  final String? username;
  final String? profileImage;
  final String? caption;
  final String? postId;
  final String? postUrl;
  final DateTime? datePublished;
  final List? likes;

  UserPost(
      {required this.uid,
      required this.username,
      required this.profileImage,
      required this.caption,
      required this.postId,
      required this.postUrl,
      required this.datePublished,
      required this.likes});

  //this method use for convert object into json
  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "profileImage": profileImage,
        "caption": caption,
        "postId": postId,
        "postUrl": postUrl,
        "datePublished": datePublished,
        "likes": likes
      };

  //this method use for convert snapshot object into user object
  static UserPost fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return UserPost(
        uid: data['uid'],
        username: data['username'],
        profileImage: data['profileImage'],
        caption: data['caption'],
        postUrl: data['postUrl'],
        postId: data['postId'],
        datePublished: data['datePublished'],
        likes: data['likes']);
  }
}
