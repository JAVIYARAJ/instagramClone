import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/error_type.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class PostCommentScreen extends StatefulWidget {
  final String? postId;

  const PostCommentScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _PostCommentScreenState createState() => _PostCommentScreenState();
}

class _PostCommentScreenState extends State<PostCommentScreen> {
  late final TextEditingController? _commentController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isAnimating = false;
    User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Comments',
          style: TextStyle(
            color: primaryColor,
            fontSize: 18.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .doc(widget.postId!)
                .collection("comments").orderBy("commentDate",descending: true)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const Center(
                  child: CircularProgressIndicator(),
                );
              }
              else {
                var data = snapshot.data!.docs;
                var comments = data
                    .map((e) =>
                        e.data().map((key, value) => MapEntry(key, value)))
                    .toList();
                return comments.isNotEmpty ? ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user
                              .photoUrl!), // Replace with actual user profile image URL
                        ),
                        trailing: LikeAnimation(
                          onEnd: () {
                            setState(() {
                              isAnimating = false;
                            });
                          },
                          isAnimating: isAnimating,
                          smallLike: true,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                isAnimating = true;
                              });
                              await FireStoreMethods().postCommentLike(
                                  comments[index]["commentId"],
                                  widget.postId!,
                                  user.uid!,
                                  comments[index]["likes"]);
                            },
                            child: Icon(
                              Icons.favorite_border,
                              color: FireStoreMethods().isUserLikedPost(
                                  user.uid!,
                                  comments[index]["likes"]!) ==
                                  true
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          comments[index]["username"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          comments[index]["commentText"],
                        ),
                      );
                    }) : const Text("Comment not found");
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://picsum.photos/id/11/50/50'), // Replace with actual user profile image URL
              ),
              title: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
                  border: InputBorder.none,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  String res = await FireStoreMethods().postComment(
                      user.uid!,
                      user.photoUrl!,
                      widget.postId!,
                      _commentController!.text.toString(),
                      user.username!);

                  if (res == "801") {
                    _commentController!.text = "";
                    // ignore: use_build_context_synchronously
                    showSnackBar(errorType[res]!, context, Colors.green);
                  } else {
                    // ignore: use_build_context_synchronously
                    showSnackBar(errorType[res]!, context, Colors.red);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
