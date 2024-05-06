import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/core/routes.dart';
import 'package:instagram_clone/screens/home/bloc/home_bloc.dart';
import 'package:instagram_clone/screens/post/bloc/post_bloc.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      context.read<HomeBloc>().add(HomePostFetchEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const Icon(
            Icons.camera_alt_outlined,
            color: primaryColor,
            size: 30,
          ),
          backgroundColor: mobileBackgroundColor,
          title: SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: primaryColor,
            height: 32,
          ),
          actions: [
            SvgPicture.asset(
              'assets/ic_igtv.svg',
              color: primaryColor,
              height: 32,
            ),
            const SizedBox(
              width: 15,
            ),
            SvgPicture.asset(
              'assets/ic_messanger.svg',
              color: primaryColor,
              height: 32,
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeLoading) {
              context.loaderOverlay.show();
            }
            if (state is HomeLoaded) {
              context.loaderOverlay.hide();
            }
            if (state is HomeError) {
              showToast(state.error);
            }
          },
          builder: (context, state) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final post = state.homeData.allPosts[index];
                return PostCard(
                  postModel: post,
                  onPageChange: (page) {
                    context.read<HomeBloc>().add(
                        HomePostMultiImageChange(page: page + 1, index: index));
                  },
                  postLike: () {
                    context.read<HomeBloc>().add(HomePostLikeEvent(
                        uid: FirebaseAuth.instance.currentUser?.uid ?? "",
                        postId: post.postId ?? "",
                        allLikes: post.likes ?? [],
                        index: index));
                  },
                  isAnimating: post.isAnimating ?? false,
                  alreadyLikes: (post.likes ?? [])
                      .contains(FirebaseAuth.instance.currentUser?.uid ?? ""),
                  postLikeAnimationEnd: () {
                    context
                        .read<HomeBloc>()
                        .add(HomeChangePostAnimation(index));
                  },
                  isTagShow: post.isPeopleShow ?? false,
                  showTagTap: () {
                    context
                        .read<HomeBloc>()
                        .add(HomePostTagShowEvent(index: index));
                  },
                  profileTap: () {
                    Navigator.pushNamed(context, Routes.profile, arguments: {
                      "uid": state.homeData.allPosts[index].uid ?? ""
                    });
                  },
                );
              },
              itemCount: state.homeData.allPosts.length,
            );
          },
        ));
  }
}
