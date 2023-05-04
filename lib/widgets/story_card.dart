import 'package:flutter/material.dart';

import '../utils/colors.dart';

class StoryCard extends StatelessWidget {
  final String? username;
  final String? profileUrl;

  const StoryCard({Key? key, required this.username, required this.profileUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.greenAccent,
            radius: 33,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(profileUrl!),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            username!,
            style: const TextStyle(
                color: primaryColor, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
