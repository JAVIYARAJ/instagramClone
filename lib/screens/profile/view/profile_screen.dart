import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/core/routes.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/edit_profile/view/edit_profile_screen.dart';
import 'package:instagram_clone/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/screens/saved_post_screen.dart';
import 'package:instagram_clone/screens/setting_screen.dart';
import 'package:instagram_clone/screens/user_following_followers_scrren.dart';
import 'package:instagram_clone/screens/user_post_screen.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/common_widget.dart';
import 'package:instagram_clone/widgets/post_view_card.dart';
import 'package:instagram_clone/widgets/reusable_button.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      Map<String, dynamic>? data =
          ModalRoute.of(context)?.settings?.arguments as Map<String, dynamic>?;
      context.read<ProfileBloc>().add(ProfileUserFetchEvent(data?["uid"]));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*void showModal() {
      showModalBottomSheet(
          backgroundColor: Colors.black,
          context: context,
          builder: (context) {
            return Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingScreen()));
                    },
                    child: ListTile(
                      leading: SvgPicture.asset(
                        "assets/ic_setting_icon.svg",
                        color: Colors.white,
                        width: 23,
                        height: 23,
                      ),
                      title: const Text(
                        "Settings",
                        style: TextStyle(fontSize: 20, color: primaryColor),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      "assets/ic_setting_activity_icon.svg",
                      color: Colors.white,
                      width: 23,
                      height: 23,
                    ),
                    title: const Text(
                      "Your Activity",
                      style: TextStyle(fontSize: 20, color: primaryColor),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      "assets/ic_setting_archiver_icon.svg",
                      color: Colors.white,
                      width: 23,
                      height: 23,
                    ),
                    title: const Text(
                      "Archive",
                      style: TextStyle(fontSize: 20, color: primaryColor),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SavePostScreen()));
                    },
                    child: InkWell(
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "assets/ic_post_save.svg",
                          color: Colors.white,
                          width: 23,
                          height: 23,
                        ),
                        title: const Text(
                          "Saved",
                          style: TextStyle(fontSize: 20, color: primaryColor),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      "assets/ic_setting_close_friend_icon.svg",
                      color: Colors.white,
                      width: 23,
                      height: 23,
                    ),
                    title: const Text(
                      "Close Friends",
                      style: TextStyle(fontSize: 20, color: primaryColor),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.star_border_outlined,
                      size: 30,
                    ),
                    title: Text(
                      "Favorites",
                      style: TextStyle(fontSize: 20, color: primaryColor),
                    ),
                  ),
                ],
              ),
            );
          });
    }*/

    return SafeArea(
      child: Scaffold(
          body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoadingState) {
            context.loaderOverlay.show();
          } else if (state is ProfileLoadedState) {
            context.loaderOverlay.hide();
          } else if (state is ProfileErrorState) {
            showToast(state.error);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const SizedBox();
          } else {
            return Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/ic_private_icon.svg",
                            color: primaryColor,
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            state.profileDataHolder.profileInfoModel?.userInfo
                                    .username ??
                                "",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          )
                        ],
                      )),
                      GestureDetector(
                        onTap: () {
                          //showModal();
                        },
                        child: SvgPicture.asset(
                          "assets/ic_menu_icon.svg",
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  //2 profile follower and following view
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CommonImageWidget(
                        imageUrl: state.profileDataHolder.profileInfoModel
                                ?.userInfo.photoUrl ??
                            "",
                        radius: 50,
                        height: 100,
                        width: 100,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              (state.profileDataHolder.profileInfoModel
                                          ?.allPosts ??
                                      [])
                                  .length
                                  .toString(),
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Posts",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserFollowingFollowersScreen(
                                        uid: user.uid!,
                                        position: 0,
                                      )));*/
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (state.profileDataHolder.profileInfoModel
                                          ?.userInfo?.followers ??
                                      [])
                                  .length
                                  .toString(),
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Followers",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserFollowingFollowersScreen(
                                        uid: user.uid!,
                                        position: 1,
                                      )));*/
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (state.profileDataHolder.profileInfoModel
                                          ?.userInfo?.followings ??
                                      [])
                                  .length
                                  .toString(),
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Following",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.profileDataHolder.profileInfoModel?.userInfo
                                  ?.username ??
                              "",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          state.profileDataHolder.profileInfoModel?.userInfo
                                  ?.bio ??
                              "",
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: primaryColor),
                        ),
                      ],
                    ),
                  ),

                  //4 profile edit button
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      if (state.profileDataHolder.profileInfoModel
                              ?.isEditAllow ??
                          false) ...[
                        Expanded(
                          child: ReusableButton(
                            text: "Edit Profile",
                            borderColor: primaryColor,
                            textColor: secondaryColor,
                            backgroundColor: primaryColor,
                            onClick: () {
                              Navigator.pushNamed(context, Routes.editProfile,arguments: {"data":state.profileDataHolder.profileInfoModel?.userInfo});
                            },
                          ),
                        ),
                        Expanded(
                          child: ReusableButton(
                            text: "Share Profile",
                            borderColor: primaryColor,
                            textColor: secondaryColor,
                            backgroundColor: primaryColor,
                            onClick: () {

                            },
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: ReusableButton(
                            text: "Follow",
                            borderColor: primaryColor,
                            textColor: secondaryColor,
                            backgroundColor: primaryColor,
                            onClick: () {

                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Row(
                      children: [
                        Text(
                          "Followed by  ",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: primaryColor),
                        ),
                        Text(
                          "rjcoding12,meet23,virat12",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        )
                      ],
                    ),
                  ),
                  if (state.profileDataHolder.profileInfoModel?.isPostShow ??
                      false) ...[
                    Expanded(
                        child: GridView.count(
                      crossAxisSpacing: 4,
                      crossAxisCount: 3,
                      scrollDirection: Axis.vertical,
                      children: List.generate(
                          (state.profileDataHolder.profileInfoModel?.allPosts ??
                                  [])
                              .length, (index) {
                        return GestureDetector(
                          onLongPress: () {},
                          onLongPressEnd: (info) {},
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: CommonImageWidget(
                              imageUrl: (state.profileDataHolder
                                              .profileInfoModel?.allPosts ??
                                          [])[index]
                                      .postUrl
                                      ?.first ??
                                  "",
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.33,
                              radius: 5,
                            ),
                          ),
                        );
                      }),
                    )),
                  ] else ...[
                    const PrivateAccountWidget(),
                  ],
                  BlocListener<ProfileBloc, ProfileState>(
                    listener: (context, state) {
                      if (state is ProfileLoadingState) {
                        context.loaderOverlay.show();
                      } else if (state is ProfileLoadedState) {
                        context.loaderOverlay.hide();
                      } else if (state is ProfileErrorState) {
                        showToast(state.error);
                      }
                    },
                    child: const SizedBox(),
                  )
                ],
              ),
            );
          }
        },
      )),
    );
  }
}

class PrivateAccountWidget extends StatelessWidget {
  const PrivateAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: const Column(
            children: [
              Icon(
                Icons.lock,
                size: 90,
                color: primaryColor,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "This Account is private.",
                style: TextStyle(fontSize: 25, color: primaryColor),
              ),
              Text(
                "Follow this account to see their photos and videos.",
                style: TextStyle(fontSize: 20, color: primaryColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
