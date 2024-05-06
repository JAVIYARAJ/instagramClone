import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    model.UserInfo user = Provider.of<UserProvider>(context).getUser;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading:GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Privacy",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid!)
                .get(),
            builder: (context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.hasData) {
                var response = snapshot.data?.data();

                var isPrivate = response!["isPrivate"];

                return ListTile(
                  leading: const Icon(
                    Icons.lock,
                    size: 20,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "private Account",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  trailing: Switch(
                      value: isPrivate,
                      onChanged: (value) {
                        setState(() {
                          FireStoreMethods()
                              .updateAccountType(value, user.uid!);
                        });
                      }),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          const ListTile(
            leading: Icon(
              Icons.notifications,
              size: 20,
              color: Colors.white,
            ),
            title: Text(
              "Notifications",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(
                Icons.lock,
                size: 20,
                color: Colors.white,
              ),
              title: Text(
                "Privacy",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.account_box,
              size: 20,
              color: Colors.white,
            ),
            title: Text(
              "Account",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.help,
              size: 20,
              color: Colors.white,
            ),
            title: Text(
              "Help",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          )
        ],
      ),
    ));
  }
}
