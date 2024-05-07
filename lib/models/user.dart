class UserInfo {
  String? uid;
  String? username;
  String? email;
  String? password;
  String? bio;
  String? photoUrl;
  List<String>? followers;
  List<String>? followings;
  List<String>? requested;
  bool? isPrivate;

  UserInfo(
      {uid,
      username,
      email,
      password,
      bio,
      photoUrl,
      followers,
      followings,
      isPrivate});

  UserInfo.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    bio = json['bio'];
    photoUrl = json['photoUrl'];
    if (json["followers"] != null) {
      followers=<String>[];
      json["followers"].forEach((e){
        followers?.add(e as String);
      });
    }
    if (json["requested"] != null) {
      requested=<String>[];
      json["requested"].forEach((e){
        requested?.add(e as String);
      });
    }
    if (json["followings"] != null) {
      followings=<String>[];
      json["followings"].forEach((e){
        followings?.add(e as String);
      });
    }
    isPrivate = json['isPrivate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['bio'] = bio;
    data['photoUrl'] = photoUrl;
    data['followers'] = followers;
    data['followings'] = followings;
    data['requested'] = requested;
    data['isPrivate'] = isPrivate;
    return data;
  }
}

class Accounts{

}
