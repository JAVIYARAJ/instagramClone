import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';

class PostCard extends StatelessWidget {
  final String? username;
  final String? userProfileUrl;
  final String? postCaption;
  final String? postPublishedDate;
  final String? postLocation;
  final String? postUrl;
  final List? likes;

  const PostCard(
      {Key? key,
      required this.username,
      required this.postCaption,
      required this.userProfileUrl,
      required this.postPublishedDate,
      required this.postLocation,
      required this.postUrl,
      required this.likes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 23,
                  backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80'),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username!,
                        style: const TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        postLocation!,
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
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    postUrl!,
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
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/ic_post_like.svg',
                  color: primaryColor,
                  width: 25,
                  height: 25,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username!,
                      style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: RichText(
                        textAlign: TextAlign.justify,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(text: postCaption!),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                const Text(
                  'View all 200 Comments',
                  style: TextStyle(
                      color: secondaryColor, fontWeight: FontWeight.normal),
                ),
                const Text(
                  '10 November 2023',
                  style: TextStyle(
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
