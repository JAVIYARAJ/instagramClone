import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../widgets/post_card.dart';
import '../widgets/story_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const Icon(Icons.camera_alt_outlined),
          backgroundColor: mobileBackgroundColor,
          title: SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: primaryColor,
            height: 32,
          ),
          actions: [
            SvgPicture.asset(
              'assets/ic_igtv.svg',
              color: primaryColor,
              height: 27,
            ),
            const SizedBox(
              width: 15,
            ),
            SvgPicture.asset(
              'assets/ic_messanger.svg',
              color: primaryColor,
              height: 27,
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: double.infinity,
                height: 90,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return StoryCard(
                          username: "sample", profileUrl: user.photoUrl);
                    })),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('posts').orderBy("datePublished",descending: true).snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final data = snapshot.data?.docs[index];

                        return PostCard(
                          postId: data!['postId'],
                          uid: data['uid'],
                          username: data['username'],
                          userProfileUrl: data['profileImage'],
                          postCaption: data['caption'],
                          postLocation: 'London',
                          postPublishedDate: data['datePublished'],
                          postUrl: data['postUrl'],
                          likes: data['likes'],
                        );
                      },
                      itemCount: snapshot.data?.docs.length,
                    );
                  }
                },
              ),
            )
          ],
        ));
  }
}
