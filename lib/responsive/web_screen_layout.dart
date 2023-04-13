import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SignUpScreen()
    );
  }
}
