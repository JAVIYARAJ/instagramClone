import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/notification_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;
  late PageController pageController;
  bool isLoading = true;

  @override
  void initState() {
    getData();
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        isLoading = false;
      });
    });
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  getData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    return isLoading == false
        ? Scaffold(
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: mobileBackgroundColor,
              activeColor: primaryColor,
              inactiveColor: secondaryColor,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home,
                        color: _page == 0 ? primaryColor : secondaryColor),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search,
                        color: _page == 1 ? primaryColor : secondaryColor),
                    label: "Search"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outlined,
                      color: _page == 2 ? primaryColor : secondaryColor),
                  label: "Post",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite,
                        color: _page == 3 ? primaryColor : secondaryColor),
                    label: "Favorite"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person,
                      color: _page == 4 ? primaryColor : secondaryColor),
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
                children: const [
                  HomeScreen(),
                  SearchScreen(),
                  AddPostScreen(),
                  NotificationScreen(),
                  ProfileScreen(),
                ],
              ),
            ))
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
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
