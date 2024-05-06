import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/screens/home/model/post_model.dart';

class ProfileInfoModel {
  UserInfo userInfo;
  List<PostModel>? allPosts = [];
  String? uid;
  bool isPostShow;
  bool isEditAllow;

  ProfileInfoModel({required this.userInfo, this.allPosts,this.uid,this.isPostShow=false,this.isEditAllow=false});
}
