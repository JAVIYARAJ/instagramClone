import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/follow_user_card.dart';
import 'package:provider/provider.dart';

import '../resources/firestore_methods.dart';

class FollowRequestScreen extends StatefulWidget {
  const FollowRequestScreen({Key? key}) : super(key: key);

  @override
  State<FollowRequestScreen> createState() => _FollowRequestScreenState();
}

class _FollowRequestScreenState extends State<FollowRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            size: 25,
            color: primaryColor,
          ),
        ),
        title: Text(
          "Follow Requests",
          style: GoogleFonts.roboto().copyWith(
              fontSize: 20, color: primaryColor, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Manage",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
      body: /*Container(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid!)
              .collection("followersRequests")
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              var response = snapshot.data!.docs;

              var requests = response
                  .map(
                      (e) => e.data().map((key, value) => MapEntry(key, value)))
                  .toList();

              return requests.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        return FollowUserCard(
                            username: requests[index]["username"],
                            name: "rjcoding",
                            status: requests[index]["status"],
                            userImage: requests[index]["userPhoto"],
                            onConfirm: () {
                              FireStoreMethods().confirmFollowRequest(
                                  requests[index]["uid"], user.uid!);
                            },
                            onReject: () {});
                      },
                      itemCount: requests.length,
                    )
                  : const Center(
                    child: Text(
                        "requests not found",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                  );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      )*/
          SizedBox(),
    ));
  }
}
