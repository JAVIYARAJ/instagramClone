import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/routes.dart';
import 'package:instagram_clone/screens/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:instagram_clone/screens/edit_profile/view/edit_profile_screen.dart';
import 'package:instagram_clone/screens/home/view/home_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/main_scrren.dart';
import 'package:instagram_clone/screens/post/view/post_media_screen.dart';
import 'package:instagram_clone/screens/post/view/post_tag_screen.dart';
import 'package:instagram_clone/screens/post/view/post_upload_screen.dart';
import 'package:instagram_clone/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/screens/profile/view/profile_screen.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import 'package:instagram_clone/screens/splash/view/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.login:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        );

      case Routes.register:
        return MaterialPageRoute(
          builder: (context) {
            return const SignUpScreen();
          },
        );

      case Routes.splash:
        return MaterialPageRoute(
          builder: (context) {
            return const SplashScreen();
          },
        );

      case Routes.home:
        return MaterialPageRoute(
          builder: (context) {
            return const HomeScreen();
          },
        );

      case Routes.main:
        return MaterialPageRoute(
          builder: (context) {
            return const MainScreen();
          },
        );

      case Routes.postMedia:
        return MaterialPageRoute(
          builder: (context) {
            return const PostMediaScreen();
          },
        );

      case Routes.postUpload:
        return MaterialPageRoute(
          builder: (context) {
            return const PostUploadScreen();
          },
        );

      case Routes.postTagScreen:
        return MaterialPageRoute(
          builder: (context) {
            return const PostTagScreen();
          },
        );

      case Routes.profile:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                  create: (context) => ProfileBloc(),
                  child: const ProfileScreen());
            },
            settings: RouteSettings(
                arguments: routeSettings.arguments, name: Routes.profile));

      case Routes.editProfile:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                  create: (context) => EditProfileBloc(),
                  child: const EditProfileScreen());
            },
            settings: RouteSettings(
                arguments: routeSettings.arguments, name: Routes.editProfile));

      default:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        );
    }
  }
}
