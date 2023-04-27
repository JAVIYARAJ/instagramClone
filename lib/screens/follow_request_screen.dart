import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

class FollowRequestScreen extends StatefulWidget {
  const FollowRequestScreen({Key? key}) : super(key: key);

  @override
  State<FollowRequestScreen> createState() => _FollowRequestScreenState();
}

class _FollowRequestScreenState extends State<FollowRequestScreen> {
  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(
          Icons.arrow_back,
          size: 25,
          color: Colors.white,
        ),
        title: const Text(
          "Follow Requests",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
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
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid!)
              .collection("requests")
              .snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
            if(snapshot.hasData){

              var response=snapshot.data!.docs;

              var requests=response.map((e) => e.data().map((key, value) => MapEntry(key, value))).toList();

              print(requests);

              return ListView.builder(
                itemBuilder: (context,index){
                return ListTile(
                  leading: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(requests[index]["userPhoto"]),
                  ),
                  title:Text("username"),
                );
              },itemCount: requests.length,);
            }else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    ));
  }
}
