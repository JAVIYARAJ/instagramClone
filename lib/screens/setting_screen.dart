import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/auth_signup_method.dart';
import 'package:instagram_clone/screens/privacy_screen.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
          "Settings",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const ListTile(
            leading: Icon(
              Icons.person_add,
              size: 20,
              color: Colors.white,
            ),
            title: Text(
              "Follow and invite friends",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrivacyScreen()));
            },
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
          ),
          InkWell(
            onTap: (){
              UserAuth().logoutUser();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            },
            child: const ListTile(
              leading: Icon(
                Icons.logout,
                size: 20,
                color: Colors.white,
              ),
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
