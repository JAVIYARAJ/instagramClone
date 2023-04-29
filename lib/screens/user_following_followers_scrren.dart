import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/widgets/reusable_user_card.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class UserFollowingFollowersScreen extends StatefulWidget {
  final String? uid;

  const UserFollowingFollowersScreen({Key? key, required this.uid})
      : super(key: key);

  @override
  State<UserFollowingFollowersScreen> createState() =>
      _UserFollowingFollowersScreenState();
}

class _UserFollowingFollowersScreenState
    extends State<UserFollowingFollowersScreen> {
  List<Map<String, dynamic>>? followersList = [];
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
    followersList = await FireStoreMethods().getUserFollowers(widget.uid!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    final List<Tab> tabs = <Tab>[
      const Tab(text: 'Followers'),
      const Tab(text: 'Followings'),
    ];

    return DefaultTabController(
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
              ListView.builder(
                  itemCount: followersList!.length,
                  itemBuilder: (context, index) {

                    return UserCard(
                        username: followersList![index]
                        ["username"],
                        nickname: followersList![index]
                        ["username"],
                        userImage: followersList![index]
                        ["profileImage"],
                        isFollowingCard: false);
                  }),

              // Column(
              //   children: [
              //     const ListTile(
              //       trailing: Icon(
              //         Icons.sort,
              //         size: 30,
              //         color: Colors.white,
              //       ),
              //       title: Text(
              //         "Sorted by default",
              //         style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.normal,
              //             color: Colors.white),
              //       ),
              //     ),
              //     const SizedBox(
              //       height: 5,
              //     ),
              //   ],
              // ),
              Container(
                color: Colors.green,
              ),
            ],
          )),
    );
  }
}
