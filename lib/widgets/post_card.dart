import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class PostCard extends StatefulWidget {
  final String? postId;
  final String? uid;
  final String? username;
  final String? userProfileUrl;
  final String? postCaption;
  final Timestamp? postPublishedDate;
  final String? postLocation;
  final String? postUrl;
  final List? likes;

  const PostCard(
      {Key? key,
      required this.postId,
      required this.uid,
      required this.username,
      required this.postCaption,
      required this.userProfileUrl,
      required this.postPublishedDate,
      required this.postLocation,
      required this.postUrl,
      required this.likes})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundImage: NetworkImage(widget.userProfileUrl!),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.username!,
                        style: const TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.postLocation!,
                        style: const TextStyle(
                            color: primaryColor, fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                )),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz_outlined),
                )
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () async {
                  await FireStoreMethods()
                      .postLike(user.uid!, widget.postId!, widget.likes!);
                  setState(() {
                    isAnimating = true;
                  });
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.postUrl!,
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isAnimating ? 1 : 0,
                child: LikeAnimation(
                  duration: const Duration(milliseconds: 400),
                  isAnimating: isAnimating,
                  onEnd: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 100,
                  ),
                ),
              ),
              Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    height: 35,
                    width: 60,
                    decoration: BoxDecoration(
                        color: mobileBackgroundColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                        child: Text(
                      '1/3',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    )),
                  ))
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LikeAnimation(
                isAnimating: widget.likes?.contains(user.uid),
                smallLike: true,
                onEnd: () {
                  setState(() {
                    isAnimating = false;
                  });
                },
                child: IconButton(
                  onPressed: () async{
                    await FireStoreMethods()
                        .postLike(user.uid!, widget.postId!, widget.likes!);
                    setState(() {
                      isAnimating = true;
                    });
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: FireStoreMethods()
                            .isUserLikedPost(user.uid!, widget.likes!)
                        ? Colors.red
                        : Colors.white,
                    size: 30,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/ic_post_comment.svg',
                    color: primaryColor,
                    width: 25,
                    height: 25,
                  )),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/ic_messanger.svg',
                  color: primaryColor,
                  width: 25,
                  height: 25,
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(50)),
                  )
                ],
              )),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/ic_post_save.svg',
                  color: primaryColor,
                  width: 25,
                  height: 25,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    CircleAvatar(
                      radius: 10,
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        'Liked by ',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Text(
                      'LastLikedUser',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Text(
                  widget.username!,
                  softWrap: true,
                  style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                RichText(
                  textAlign: TextAlign.justify,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(text: widget.postCaption!),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  widget.likes!.length.toString()+" likes"
                ),
                const SizedBox(
                  height: 3,
                ),
                const Text(
                  'View all 200 Comments',
                  style: TextStyle(
                      color: secondaryColor, fontWeight: FontWeight.normal),
                ),
                Text(
                  convertDate(widget.postPublishedDate!),
                  style: const TextStyle(
                      color: secondaryColor, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
