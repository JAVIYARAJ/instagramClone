import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserCard extends StatelessWidget {
  final String? userImage;
  final String? username;
  final String? nickname;
  final bool? isFollowingCard;

  const UserCard(
      {Key? key,
      required this.username,
      required this.nickname,
      required this.userImage,
      required this.isFollowingCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(
        "https://cdn-icons-png.flaticon.com/512/149/149071.png",
        ),
      ),
      title: Text(
        username!,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      subtitle: Text(
        username!,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.normal, color: Colors.white),
      ),
      trailing: Row(
        children: [
          Container(
            height: 50,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.grey),
            child: Center(
              child: Text(
                isFollowingCard! ? "Following" : "Remove",
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          isFollowingCard!
              ? SvgPicture.asset(
                  "assets/ic_more_icon.svg",
                  color: Colors.white,
                )
              : const Padding(padding: EdgeInsets.zero)
        ],
      ),
    );
  }
}
