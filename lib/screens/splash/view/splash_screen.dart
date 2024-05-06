import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/core/routes.dart';
import 'package:instagram_clone/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 2),(){
        Navigator.pushReplacementNamed(context,FirebaseAuth.instance.currentUser!=null ?Routes.main: Routes.login);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              Center(
                  child: SvgPicture.asset(
                "assets/ic_app_icon.svg",
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )),
              const Expanded(child: SizedBox()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/ic_meta_icon.svg",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    color: Colors.pink,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "By Meta",
                    style: GoogleFonts.roboto().copyWith(fontSize: 20,fontWeight: FontWeight.w700,color: primaryColor),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
