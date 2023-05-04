import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/notification_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

//bug here(render error.)
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
    super.initState();
    getData();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    model.User user = Provider.of<UserProvider>(context).getUser;

    return isLoading ? const Center(child: CircularProgressIndicator(),)
        :
         Scaffold(
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: mobileBackgroundColor,
              activeColor: primaryColor,
              inactiveColor: secondaryColor,
              items: [
                BottomNavigationBarItem(
                    icon: SvgPicture.asset("assets/ic_home_icon.svg",
                        color: _page == 0 ? primaryColor : secondaryColor),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset("assets/ic_search_icon.svg",
                        color: _page == 1 ? primaryColor : secondaryColor),
                    label: "Search"),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/ic_post_icon.svg",
                      color: _page == 2 ? primaryColor : secondaryColor),
                  label: "Post",
                ),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset("assets/ic_feed_icon.svg",
                        color: _page == 3 ? primaryColor : secondaryColor),
                    label: "Favorite"),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/ic_profile_icon.svg",
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
                children: [
                  const HomeScreen(),
                  const SearchScreen(),
                  const AddPostScreen(),
                  const NotificationScreen(),
                  ProfileScreen(
                    uid: user.uid!,
                  ),
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
