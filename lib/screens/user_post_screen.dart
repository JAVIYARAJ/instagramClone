import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class UserPostScreen extends StatefulWidget {
  final String? uid;
  
  const UserPostScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserPostScreen> createState() => _UserPostScreenState();
}

class _UserPostScreenState extends State<UserPostScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child:const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
          ),
          title: const Text(
            "Posts",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
          child: Expanded(
            child: StreamBuilder(
              stream:
              FirebaseFirestore.instance.collection("posts").snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  var response = snapshot.data?.docs;

                  var posts = response
                      ?.map((e) =>
                      e.data().map((key, value) => MapEntry(key, value)))
                      .toList();

                  List<Map<String, dynamic>> post = [];

                  for (var i = 0; i < posts!.length; i++) {
                    if (posts[i]["uid"] == widget.uid) {
                      post.add(posts[i]);
                    }
                  }

                  return ListView.builder(
                      itemCount: post.length,
                      itemBuilder: (context, index) {
                        return PostCard(
                            postId: post[index]["postId"],
                            uid: post[index]["uid"],
                            username: post[index]["username"],
                            postCaption: post[index]["caption"],
                            userProfileUrl: post[index]["profileImage"],
                            postPublishedDate: post[index]["datePublished"],
                            postLocation: "London",
                            postUrl: post[index]["postUrl"],
                            likes: post[index]["likes"]);
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
