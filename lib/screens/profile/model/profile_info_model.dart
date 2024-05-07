import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/screens/home/model/post_model.dart';
import 'package:instagram_clone/screens/profile/model/request_model.dart';

class ProfileInfoModel {
  UserInfo userInfo;
  List<PostModel>? allPosts = [];
  String? uid;
  bool isPostShow;
  bool isEditAllow;
  List<ProfileActionModel> actions = [];
  RequestModel? requestModel;

  ProfileInfoModel(
      {required this.userInfo,
      this.allPosts,
      this.uid,
      this.isPostShow = false,
      this.isEditAllow = false,
      this.requestModel,
      required this.actions});
}

class ProfileActionModel {
  String name;
  bool isDisable;

  ProfileActionModel({required this.name, this.isDisable = false});
}
