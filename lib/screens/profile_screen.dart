import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_signup_method.dart';
import 'package:instagram_clone/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(onPressed: () {
          UserAuth().logoutUser();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }, icon: const Icon(Icons.logout)),
      ),
    );
  }
}
