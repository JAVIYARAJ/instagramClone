import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/like_animation.dart';

class PostViewCard extends StatefulWidget {
  final String? uid;
  final String? postUrl;
  final String? postId;
  final String? profileUrl;
  final String? username;
  final String? postLocation;
  final List? postLikes;

  const PostViewCard(
      {Key? key,
      required this.uid,
      required this.postUrl,
      required this.postId,
      required this.profileUrl,
      required this.username,
      required this.postLocation,
      required this.postLikes})
      : super(key: key);

  @override
  State<PostViewCard> createState() => _PostViewCardState();
}

class _PostViewCardState extends State<PostViewCard> {

  bool isAnimating=false;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(5)),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.55,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        backgroundImage: NetworkImage(widget.profileUrl!)),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.username!,
                          style: const TextStyle(
                              color: mobileBackgroundColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          widget.postLocation!,
                          style: const TextStyle(
                              color: secondaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Divider(
                color: secondaryColor,
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.postUrl!,
                  ),
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: double.infinity,
                ),
              ),
              const Divider(
                color: secondaryColor,
                height: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async{
                        await FireStoreMethods()
                            .postLike(widget.uid!, widget.postId!, widget.postLikes!);
                        setState(() {
                          isAnimating = true;
                        });
                      },
                      child: AnimatedOpacity(
                        opacity: isAnimating ? 1: 1,
                        duration: const Duration(milliseconds: 200),
                        child: LikeAnimation(
                          isAnimating: isAnimating,
                          onEnd: (){
                            setState(() {
                              isAnimating = false;
                            });
                          },
                          smallLike: true,
                          child: Icon(
                            size: 33,
                            Icons.favorite,
                            color: FireStoreMethods().isUserLikedPost(
                                        widget.uid!, widget.postLikes!) ==
                                    true
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/ic_post_comment.svg",
                      color: secondaryColor,
                      width: 27,
                      height: 27,
                    ),
                    SvgPicture.asset(
                      "assets/ic_messanger.svg",
                      color: secondaryColor,
                      width: 27,
                      height: 27,
                    ),
                    SvgPicture.asset(
                      "assets/ic_more_icon.svg",
                      color: secondaryColor,
                      width: 27,
                      height: 27,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
