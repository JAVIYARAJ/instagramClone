import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/widgets/reusable_user_card.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class UserFollowingFollowersScreen extends StatefulWidget {
  final String? uid;
  final int? position;

  const UserFollowingFollowersScreen(
      {Key? key, required this.uid, required this.position})
      : super(key: key);

  @override
  State<UserFollowingFollowersScreen> createState() =>
      _UserFollowingFollowersScreenState();
}

class _UserFollowingFollowersScreenState
    extends State<UserFollowingFollowersScreen> {
  List<Map<String, dynamic>>? followersList = [];
  List<Map<String, dynamic>>? followingsList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getFollowersList();
    setState(() {});
  }

  void getFollowersList() async {
    setState(() {
      isLoading = true;
    });
    followersList = await FireStoreMethods()
        .getUserFollowersAndFollowingsData(widget.uid!, true);
    followingsList = await FireStoreMethods()
        .getUserFollowersAndFollowingsData(widget.uid!, false);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    final List<Tab> tabs = <Tab>[
      Tab(text: '${followersList?.length.toString()} followers'),
      Tab(text: '${followingsList?.length.toString()} followings'),
    ];

    return DefaultTabController(
      initialIndex: widget.position ?? 0,
      length: tabs.length,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: tabs,
            ),
            backgroundColor: Colors.black,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.white,
              ),
            ),
            title: Text(
              user.username!,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              //for followers widget
              Column(
                children: [
                  ListTile(
                    trailing: SvgPicture.asset(
                      "assets/ic_toggle_icon.svg",
                      color: Colors.white,
                      height: 40,
                      width: 40,
                    ),
                    title: const Text(
                      "Sorted by default",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: followersList!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(uid: followingsList![index]["uid"],)));
                              },
                              child: UserCard(
                                username: followersList![index]["username"],
                                name: followersList![index]["username"],
                                isFollowing: false,
                                userImage: followersList![index]["photoUrl"],
                                onConfirm: () {},
                                onReject: () {},
                              ),
                            );
                          }))
                ],
              ),
              //for following widget
              Column(
                children: [
                  ListTile(
                    trailing: SvgPicture.asset(
                      "assets/ic_toggle_icon.svg",
                      color: Colors.white,
                      height: 40,
                      width: 40,
                    ),
                    title: const Text(
                      "Sorted by default",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: followingsList!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(uid: followingsList![index]["uid"],)));
                              },
                              child: UserCard(
                                username: followingsList![index]["username"],
                                name: followingsList![index]["username"],
                                isFollowing: true,
                                userImage: followingsList![index]["photoUrl"],
                                onConfirm: () {},
                                onReject: () {},
                              ),
                            );
                          }))
                ],
              ), //
            ],
          )),
    );
  }
}
