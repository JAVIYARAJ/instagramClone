import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/post/view/post_media_screen.dart';
import 'package:instagram_clone/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/screens/profile/view/profile_screen.dart';
import 'package:instagram_clone/screens/search/view/search_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

import 'home/view/home_screen.dart';
import 'notification_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          activeColor: primaryColor,
          inactiveColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/ic_home_icon.svg",
                    color: _page == 0 ? primaryColor : Colors.grey),
                label: "Home"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/ic_search_icon.svg",
                    color: _page == 1 ? primaryColor : Colors.grey),
                label: "Search"),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/ic_post_icon.svg",
                  color: _page == 2 ? primaryColor : Colors.grey),
              label: "Post",
            ),
             BottomNavigationBarItem(
                    icon: SvgPicture.asset("assets/ic_feed_icon.svg",
                        color: _page == 3 ? primaryColor : Colors.grey),
                    label: "Favorite"),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/ic_post_icon.svg",
                  color: _page == 4 ? primaryColor : Colors.grey),
              label: "Profile",
            ),
          ],
          onTap: navigatePage,
        ),
        body: SafeArea(
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            onPageChanged: pageChanged,
            children: [
              const HomeScreen(),
              const SearchScreen(),
              const PostMediaScreen(),
              const NotificationScreen(),
              BlocProvider(
                create: (context) => ProfileBloc(),
                child: const ProfileScreen(),
              )
            ],
          ),
        ));
  }

  void navigatePage(int page) {
    pageController.jumpToPage(page);
  }

  void pageChanged(int page) {
    setState(() {
      _page = page;
    });
  }
}
