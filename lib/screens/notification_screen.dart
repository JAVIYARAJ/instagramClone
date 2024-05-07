import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/follow_request_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int requestCount = 0;

  @override
  void initState() {
    super.initState();
    getTotalRequestCount();
  }

  void getTotalRequestCount() async {
    requestCount = await FireStoreMethods()
        .getRequestCount(FirebaseAuth.instance.currentUser!.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          leading: const Icon(
            Icons.arrow_back,
            size: 30,
            color: primaryColor,
          ),
          title: Text(
            "Notification",
            style: GoogleFonts.roboto().copyWith(
                fontSize: 20, color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.zero,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FollowRequestScreen()));
                },
                child: ListTile(
                  title: const Text(
                    "Follow request",
                    style: TextStyle(fontSize: 16, color: primaryColor),
                  ),
                  subtitle: const Text(
                    "Approve or ignore request",
                    style: TextStyle(fontSize: 16, color: primaryColor),
                  ),
                  leading: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          "assets/ic_profile_icon.png",
                          height: 60,
                          width: 60,
                        ),
                      ),
                      Positioned(
                          top: 0,
                          left: 35,
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(100)),
                            child: Center(
                              child: Text(
                                requestCount.toString(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
