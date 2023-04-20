import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
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
                    user.username!,
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
                children: const [
                  Text(
                    "100",
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
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
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const ShapeDecoration(
                color: secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)))),
            child: const Text(
              "Edit Profile",
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
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
                        borderRadius: BorderRadius.all(Radius.circular(40)))),
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
                stream:
                    FirebaseFirestore.instance.collection("posts").snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    //snapshot=> data => documents => data => key value pair data
                    //get all snapshot
                    var allPostsData = snapshot.data?.docs;

                    var posts = allPostsData
                        ?.map((e) => e.data().map((key, value) {
                              return MapEntry(key, value);
                            }))
                        .toList();

                    //filter only particular user post
                    var post=<Map<String,dynamic>>[];
                    var count = 0;
                    for (var i = 0; i < posts!.length; i++) {
                      if (posts[i]["uid"] == user.uid) {
                        post[count] = posts[i];
                        count++;
                      }
                    }

                    print(post);



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
                          return Image(
                            fit: BoxFit.cover,
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.33,
                            image: NetworkImage(post[index]["postUrl"]),
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
    ));
  }
}
