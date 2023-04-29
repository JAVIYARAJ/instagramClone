import 'package:flutter/material.dart';

class FollowUserCard extends StatelessWidget {
  final String userImage;
  final String username;
  final String name;
  final bool status;
  final VoidCallback onConfirm;
  final VoidCallback onReject;

  const FollowUserCard(
      {Key? key,
      required this.username,
      required this.name,
      required this.status,
      required this.userImage,
      required this.onConfirm,
      required this.onReject})
      : super(key: key);

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
                  height: 8,
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
          status ? Container(
            height: 43,
            width: 85,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10)),
            child: const Center(
                child: Text(
                  "Approved",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
          ) :
          SizedBox(
            width: 120,
            height: 60,
            child: Row(
              children: [
                GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    height: 43,
                    width: 85,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                        child: Text(
                      "confirm",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: onReject,
                  child: const Icon(
                    Icons.close,
                    size: 25,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
