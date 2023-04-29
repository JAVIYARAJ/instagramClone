import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/follow_request_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
          title: const Text(
            "Notification",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.zero,
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const FollowRequestScreen()));
                },
                child: ListTile(
                  title: const Text(
                    "Follow request",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  subtitle: const Text(
                    "Approve or ignore request",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  leading: Stack(
                    children: [
                      const CircleAvatar(
                      radius: 30,
                        backgroundImage: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
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
                            child: const Center(
                              child: Text(
                                "20",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
          ],
        ));
  }
}
