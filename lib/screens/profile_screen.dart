import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/edit_profile_screen.dart';
import 'package:instagram_clone/screens/setting_screen.dart';
import 'package:instagram_clone/screens/user_following_followers_scrren.dart';
import 'package:instagram_clone/screens/user_post_screen.dart';
import 'package:instagram_clone/widgets/post_view_card.dart';
import 'package:instagram_clone/widgets/reusable_button.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int? postCount = 0;
  var userData = {};
  bool isLoading = false;
  bool isFollowing = false;
  int followers = 0;
  int following = 0;
  String followText = "Follow";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getPostCount() async {
    postCount = await FireStoreMethods().postCount(widget.uid!);
    setState(() {});
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });

    var response = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .get();

    //get user details of current profile
    userData = response.data()!;



    //it is current profile user follow actual user account.
    isFollowing =
        userData["followers"].contains(FirebaseAuth.instance.currentUser?.uid);

    //get followers and followings of current profile user
    following = userData["followings"]?.length ?? 0;
    followers = userData["followers"]?.length ?? 0;

    //get current profile user post count
    getPostCount();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    //show setting modal
    void showModal() {
      showModalBottomSheet(
          backgroundColor: Colors.black,
          context: context,
          builder: (context) {
            return Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingScreen()));
                    },
                    child: ListTile(
                      leading: SvgPicture.asset(
                        "assets/ic_setting_icon.svg",
                        color: Colors.white,
                        width: 23,
                        height: 23,
                      ),
                      title: const Text(
                        "Settings",
                        style: TextStyle(fontSize: 20, color: primaryColor),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      "assets/ic_setting_activity_icon.svg",
                      color: Colors.white,
                      width: 23,
                      height: 23,
                    ),
                    title: const Text(
                      "Your Activity",
                      style: TextStyle(fontSize: 20, color: primaryColor),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      "assets/ic_setting_archiver_icon.svg",
                      color: Colors.white,
                      width: 23,
                      height: 23,
                    ),
                    title: const Text(
                      "Archive",
                      style: TextStyle(fontSize: 20, color: primaryColor),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      "assets/ic_post_save.svg",
                      color: Colors.white,
                      width: 23,
                      height: 23,
                    ),
                    title: const Text(
                      "Saved",
                      style: TextStyle(fontSize: 20, color: primaryColor),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      "assets/ic_setting_close_friend_icon.svg",
                      color: Colors.white,
                      width: 23,
                      height: 23,
                    ),
                    title: const Text(
                      "Close Friends",
                      style: TextStyle(fontSize: 20, color: primaryColor),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.star_border_outlined,
                      size: 30,
                    ),
                    title: Text(
                      "Favorites",
                      style: TextStyle(fontSize: 20, color: primaryColor),
                    ),
                  ),
                ],
              ),
            );
          });
    }

    return SafeArea(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              body: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //1 top profile view
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/ic_private_icon.svg",
                            color: Colors.white,
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            userData["username"],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                      GestureDetector(
                        onTap: () {
                          showModal();
                        },
                        child: SvgPicture.asset(
                          "assets/ic_menu_icon.svg",
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  //2 profile follower and following view
                  const SizedBox(
                    height: 15,
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(userData["photoUrl"]),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(postCount.toString(),
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Posts",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserFollowingFollowersScreen(
                                        uid: user.uid!,
                                      )));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              followers.toString(),
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Followers",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            following.toString(),
                            style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Following",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),

                  //3 user profile username and bio
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData["username"],
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          user.bio!,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: primaryColor),
                        ),
                      ],
                    ),
                  ),

                  //4 profile edit button
                  const SizedBox(
                    height: 10,
                  ),
                  widget.uid == user.uid
                      ? ReusableButton(
                          text: "Edit Profile",
                          borderColor: primaryColor,
                          textColor: Colors.white,
                          backgroundColor: Colors.black,
                          onClick: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfileScreen()));
                          },
                        )
                      : isFollowing
                          ? ReusableButton(
                              backgroundColor: Colors.blueAccent,
                              text: "UnFollow",
                              borderColor: Colors.white,
                              textColor: Colors.white,
                              onClick: () async {
                                await FireStoreMethods()
                                    .followUser(user.uid!, userData["uid"]);
                                setState(() {
                                  isFollowing = false;
                                  followers--;
                                });
                              },
                            )
                          : ReusableButton(
                              backgroundColor: Colors.blueAccent,
                              text: followText,
                              borderColor: Colors.white,
                              textColor: Colors.white,
                              onClick: () async {
                                if ((isFollowing == false) &&
                                    (userData["isPrivate"] == true)) {
                                  setState(() {
                                    followText = "Requested";
                                    isFollowing=false;
                                  });
                                  FireStoreMethods().sendFollowRequest(
                                      widget.uid!, FirebaseAuth.instance.currentUser!.uid);
                                } else {
                                  await FireStoreMethods()
                                      .followUser(user.uid!, userData["uid"]);
                                  setState(() {
                                    isFollowing = true;
                                    followers++;
                                  });
                                }
                              },
                            ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: const [
                        Text(
                          "Followed by  ",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.normal),
                        ),
                        Text(
                          "rjcoding12,meet23,virat12",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  //5 profile highlight view
                  const SizedBox(
                    height: 10,
                  ),
                  widget.uid != user.uid
                      ? const Padding(padding: EdgeInsets.zero)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              height: 60,
                              width: 60,
                              decoration: const ShapeDecoration(
                                  shadows: [
                                    BoxShadow(
                                      offset: Offset(1, 0),
                                      color: secondaryColor,
                                    ),
                                    BoxShadow(
                                      offset: Offset(1, -1),
                                      color: secondaryColor,
                                    ),
                                    BoxShadow(
                                      offset: Offset(-1, 0),
                                      color: secondaryColor,
                                    ),
                                    BoxShadow(
                                      offset: Offset(1, 1),
                                      color: secondaryColor,
                                    )
                                  ],
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40)))),
                              child: SvgPicture.asset(
                                "assets/ic_highlight_add_icon.svg",
                                color: primaryColor,
                              ),
                            )
                          ],
                        ),
                  //6 user post
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  (isFollowing == false && user.isPrivate == true)
                      ? Expanded(
                          child: Center(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: const [
                                  Icon(
                                    Icons.lock,
                                    size: 90,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "This Account is private.",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white),
                                  ),
                                  Text(
                                    "Follow this account to see their photos and videos.",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("posts")
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasData) {
                                  //snapshot=> data => documents => data => key value pair data
                                  //get all snapshot
                                  var allPostsData = snapshot.data?.docs;

                                  var posts = allPostsData
                                      ?.map((e) => e.data().map((key, value) {
                                            return MapEntry(key, value);
                                          }))
                                      .toList();

                                  //filter only particular user post
                                  List<Map<String, dynamic>> post = [];
                                  for (var i = 0; i < posts!.length; i++) {
                                    if (posts[i]["uid"] == widget.uid) {
                                      post.add(posts[i]);
                                    }
                                  }
                                  if (post.isEmpty) {
                                    return const Center(
                                      child: Text("No Post Available"),
                                    );
                                  } else {
                                    return GridView.count(
                                      crossAxisSpacing: 4,
                                      crossAxisCount: 3,
                                      scrollDirection: Axis.vertical,
                                      children:
                                          List.generate(post.length, (index) {
                                        return GestureDetector(
                                          onLongPress: () {
                                            showDialog(
                                                context: context,
                                                builder: (_) => PostViewCard(
                                                    uid: user.uid!,
                                                    postUrl: post[index]
                                                        ["postUrl"],
                                                    postId: post[index]
                                                        ["postId"],
                                                    profileUrl: post[index]
                                                        ["profileImage"],
                                                    username: post[index]
                                                        ["username"],
                                                    postLocation: "London",
                                                    postLikes: post[index]
                                                        ["likes"]));
                                          },
                                          onLongPressEnd: (info) {
                                            Navigator.pop(context);
                                          },
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserPostScreen(
                                                            uid: user.uid!)));
                                          },
                                          child: Image(
                                            fit: BoxFit.cover,
                                            height: 100,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.33,
                                            image: NetworkImage(
                                              post[index]["postUrl"],
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  }
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }),
                        ),
                ],
              ),
            )),
    );
  }
}
