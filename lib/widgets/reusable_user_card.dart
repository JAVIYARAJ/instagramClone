import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserCard extends StatelessWidget {
  final String userImage;
  final String username;
  final String name;
  final bool isFollowing;
  final VoidCallback onConfirm;
  final VoidCallback onReject;

  const UserCard({
    Key? key,
    required this.username,
    required this.name,
    required this.isFollowing,
    required this.userImage,
    required this.onConfirm,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(userImage),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
          SizedBox(
            width: 130,
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    height: 43,
                    width: 85,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      isFollowing ? "Following" : "Remove",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    )),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                isFollowing
                    ? GestureDetector(
                        onTap: onReject,
                        child: SvgPicture.asset(
                          "assets/ic_more_icon.svg",
                          color: Colors.white,
                          height: 20,
                          width: 20,
                        ))
                    : const Padding(padding: EdgeInsets.zero)
              ],
            ),
          )
        ],
      ),
    );
  }
}
