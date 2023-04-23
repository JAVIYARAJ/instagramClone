import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/edit_profile_screen.dart';
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

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getPostCount() async {
    postCount = await FireStoreMethods().postCount(widget.uid!);
    setState((){

    });
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    var response = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .get();
    userData = response.data()!;
    getPostCount();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

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
                      SvgPicture.asset(
                        "assets/ic_menu_icon.svg",
                        color: Colors.white,
                      ),
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
                          backgroundImage: NetworkImage(user.photoUrl!),
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.followers?.length.toString() ?? "0",
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.followings?.length.toString() ?? "0",
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
                          user.username!,
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
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfileScreen()));
                          },
                          child: const ReusableButton(
                            text: "Edit Profile",
                            borderColor: primaryColor,
                            textColor: Colors.white, backgroundColor:Colors.black,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: const [
                              Text(
                                "Followed by  ",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)))),
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
                  Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("posts")
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
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
                              if (posts[i]["uid"] == user.uid) {
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
                                children: List.generate(post.length, (index) {
                                  return GestureDetector(
                                    onLongPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => PostViewCard(
                                              uid: user.uid!,
                                              postUrl: post[index]["postUrl"],
                                              postId: post[index]["postId"],
                                              profileUrl: post[index]
                                                  ["profileImage"],
                                              username: post[index]["username"],
                                              postLocation: "London",
                                              postLikes: post[index]["likes"]));
                                    },
                                    onLongPressEnd: (info) {
                                      Navigator.pop(context);
                                    },
                                    child: Image(
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: MediaQuery.of(context).size.width *
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
