import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? uid;
  final String? email;
  final String? username;
  final String? photoUrl;
  final String? password;
  final String? bio;
  final List? followers;
  final List? followings;

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.photoUrl,
    required this.password,
    required this.bio,
    required this.followers,
    required this.followings,
  });

  //this method use for convert object into json
  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "password": password,
        "bio": bio,
        "photoUrl": photoUrl,
        "followers": followers,
        "followings": followings
      };

  //this method use for convert snapshot object into user object
  static User fromSnapshot(DocumentSnapshot<dynamic> snapshot) {
    var data = snapshot.data() as Map<String,dynamic>;

    return User(
        uid: data['uid'],
        username: data['username'],
        email: data['email'],
        photoUrl: data['photoUrl'],
        password: data['password'],
        bio: data['bio'],
        followers: data['followers'],
        followings: data['following']);
  }
}
