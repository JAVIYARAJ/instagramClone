import 'package:instagram_clone/models/user.dart';

class PostModel {
  String? postId;
  String? caption;
  String? datePublished;
  List<String>? likes;
  List<String>? postUrl;
  String? uid;
  bool? isAnimating;
  UserInfo? lastLikes;
  List<PeopleTagModel>? peopleTag;

  //temporary variable (use for state change)
  UserInfo? user;
  bool? isPeopleShow;
  int? currentPage;

  PostModel(
      {this.postId,
      this.caption,
      this.datePublished,
      this.likes,
      this.postUrl,
      this.uid,
      this.isAnimating = false,
      this.lastLikes,
      this.peopleTag,
      this.user,
      this.isPeopleShow = false,this.currentPage=1});

  PostModel.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    caption = json['caption'];
    datePublished = json['datePublished'];
    if (json["likes"] != null) {
      likes = json['likes'].cast<String>();
    }
    if (json["postUrl"] != null) {
      postUrl = json['postUrl'].cast<String>();
    }
    uid = json['uid'];
    if (json["peopleTag"] != null) {
      peopleTag = <PeopleTagModel>[];
      json["peopleTag"].forEach((e) {
        peopleTag?.add(PeopleTagModel.fromJson(e));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postId'] = postId;
    data['caption'] = caption;
    data['datePublished'] = datePublished;
    data['likes'] = likes;
    data['postUrl'] = postUrl;
    data['uid'] = uid;
    if (peopleTag != null) {
      data["peopleTag"] = peopleTag?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class PeopleTagModel {
  String? id;
  String? username;
  double? dx;
  double? dy;

  PeopleTagModel({this.id, this.dx, this.dy, this.username});

  PeopleTagModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dx = json['dx'];
    dy = json['dy'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['dx'] = dx;
    data['dy'] = dy;
    return data;
  }
}
