import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/screens/home/model/post_model.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  final PostModel postModel;
  final VoidCallback? postLike;
  final VoidCallback? postLikeAnimationEnd;
  final VoidCallback? postCommentTap;
  final VoidCallback? profileTap;
  final VoidCallback? postMoreActionTap;
  final VoidCallback? showTagTap;
  final Function(int page)? onPageChange;
  final bool isAnimating;
  final bool alreadyLikes;
  final bool alreadySaved;
  final bool isTagShow;

  const PostCard({
    Key? key,
    required this.postModel,
    this.postLike,
    this.postCommentTap,
    this.profileTap,
    this.showTagTap,
    this.postMoreActionTap,
    this.postLikeAnimationEnd,
    this.onPageChange,
    this.isAnimating = false,
    this.alreadyLikes = false,
    this.alreadySaved = false,
    this.isTagShow = false,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    height: 50,
                    width: 50,
                    fadeInCurve: Curves.ease,
                    filterQuality: FilterQuality.high,
                    placeholderFadeInDuration: const Duration(seconds: 2),
                    fadeOutCurve: Curves.ease,
                    fit: BoxFit.cover,
                    imageUrl: widget.postModel?.user?.photoUrl ?? "",
                    placeholder: (context, url) =>
                        Image.asset("assets/ic_placeholder_icon.png"),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/ic_error_placeholder_icon.png"),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () {
                      widget.profileTap?.call();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.postModel?.user?.username ?? "",
                          style: const TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Location",
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                )),
                IconButton(
                  onPressed: () {
                    widget.postMoreActionTap?.call();
                  },
                  icon: const Icon(
                    Icons.more_horiz_outlined,
                    color: primaryColor,
                  ),
                )
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  widget.postLike?.call();
                },
                child: (widget.postModel.postUrl ?? []).length > 1
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: PageView(
                          onPageChanged: (value) {
                            widget.onPageChange?.call(value);
                          },
                          children: List.generate(
                              (widget.postModel.postUrl ?? []).length,
                              (index) => IntrinsicHeight(
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            fadeInCurve: Curves.ease,
                                            filterQuality: FilterQuality.high,
                                            placeholderFadeInDuration: const Duration(seconds: 2),
                                            fadeOutCurve: Curves.ease,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                            imageUrl: widget.postModel
                                                    ?.postUrl?[index] ??
                                                "",
                                            placeholder: (context, url) =>
                                                Image.asset(
                                              "assets/ic_placeholder_icon.png",
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              "assets/ic_error_placeholder_icon.png",
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        /* SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Image(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              widget.postModel
                                                      ?.postUrl?[index] ??
                                                  "",
                                            ),
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const SizedBox();
                                            },
                                          ),
                                        ),*/
                                        if ((widget.postModel.peopleTag ?? [])
                                                .isNotEmpty &&
                                            widget.isTagShow) ...[
                                          PostPeopleTagWidget(
                                              peopleTagModel:
                                                  widget.postModel.peopleTag ??
                                                      [])
                                        ]
                                      ],
                                    ),
                                  )),
                        ),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: IntrinsicHeight(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(fadeInCurve: Curves.ease,
                                  filterQuality: FilterQuality.high,
                                  placeholderFadeInDuration: const Duration(seconds: 2),
                                  fadeOutCurve: Curves.ease,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      widget.postModel?.postUrl?.first ?? "",
                                  placeholder: (context, url) => Image.asset(
                                    "assets/ic_placeholder_icon.png",
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    "assets/ic_error_placeholder_icon.png",
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              if ((widget.postModel.peopleTag ?? [])
                                      .isNotEmpty &&
                                  widget.isTagShow) ...[
                                PostPeopleTagWidget(
                                    peopleTagModel:
                                        widget.postModel.peopleTag ?? [])
                              ]
                            ],
                          ),
                        ),
                      ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: widget.isAnimating ? 1 : 0,
                child: LikeAnimation(
                  duration: const Duration(milliseconds: 400),
                  isAnimating: widget.isAnimating,
                  onEnd: () {
                    widget.postLikeAnimationEnd?.call();
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 100,
                  ),
                ),
              ),
              if ((widget.postModel.postUrl ?? []).length > 1) ...[
                Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      height: 35,
                      width: 60,
                      decoration: BoxDecoration(
                          color: mobileBackgroundColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        '${widget.postModel.currentPage ?? 1}/${(widget.postModel.postUrl ?? []).length}',
                        style: const TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      )),
                    ))
              ],
              if ((widget.postModel.peopleTag ?? []).isNotEmpty) ...[
                Positioned(
                    bottom: 10,
                    left: 10,
                    child: GestureDetector(
                      onTap: () {
                        widget.showTagTap?.call();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                            child: Icon(
                          Icons.person,
                          color: secondaryColor,
                        )),
                      ),
                    ))
              ]
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LikeAnimation(
                isAnimating: widget.postModel?.likes?.contains("test"),
                smallLike: true,
                onEnd: () {
                  widget.postLikeAnimationEnd?.call();
                },
                child: IconButton(
                  onPressed: () async {
                    widget?.postLike?.call();
                  },
                  icon: Icon(
                    widget.alreadyLikes
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: widget.alreadyLikes ? Colors.red : primaryColor,
                    size: 30,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostCommentScreen(
                                  postId: widget.postId,
                                )));*/
                  },
                  icon: SvgPicture.asset(
                    'assets/ic_post_comment.svg',
                    color: primaryColor,
                    width: 25,
                    height: 25,
                  )),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/ic_messanger.svg',
                  color: primaryColor,
                  width: 25,
                  height: 25,
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(50)),
                  )
                ],
              )),
              IconButton(
                onPressed: () {
                  /*FireStoreMethods().savePost(
                      FirebaseAuth.instance.currentUser!.uid, widget.postId!);*/
                  widget.postCommentTap?.call();
                },
                icon: SvgPicture.asset(
                  'assets/ic_post_save.svg',
                  color: widget.alreadySaved ? Colors.green : primaryColor,
                  width: 25,
                  height: 25,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if ((widget.postModel?.likes ?? []).isNotEmpty) ...[
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          fadeInCurve: Curves.ease,
                          filterQuality: FilterQuality.high,
                          placeholderFadeInDuration: const Duration(seconds: 2),
                          fadeOutCurve: Curves.ease,
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                          imageUrl:  widget.postModel.lastLikes?.photoUrl ?? "",
                          placeholder: (context, url) =>
                              Image.asset(
                                "assets/ic_placeholder_icon.png"),
                          errorWidget:
                              (context, url, error) =>
                              Image.asset(
                                "assets/ic_error_placeholder_icon.png",
                                fit: BoxFit.fill,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Text(
                          'Liked by ',
                          style: GoogleFonts.roboto().copyWith(
                              color: primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        widget.postModel.lastLikes?.username ?? "",
                        style: GoogleFonts.roboto().copyWith(
                            color: primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                RichText(
                  textAlign: TextAlign.justify,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      text: widget.postModel?.caption ?? "",
                      style:
                          GoogleFonts.roboto().copyWith(color: primaryColor)),
                ),
                const SizedBox(
                  height: 3,
                ),
                if ((widget.postModel?.likes ?? []).isNotEmpty) ...[
                  Text(
                    "${(widget.postModel.likes ?? []).length} likes",
                    style: GoogleFonts.roboto().copyWith(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                ],
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View all 4 Comments',
                    style: GoogleFonts.roboto().copyWith(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Text(
                  formatInstagramPostDate(widget.postModel.datePublished ?? ""),
                  style: GoogleFonts.roboto().copyWith(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PostPeopleTagWidget extends StatelessWidget {
  final List<PeopleTagModel> peopleTagModel;

  const PostPeopleTagWidget({super.key, required this.peopleTagModel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
          peopleTagModel.length,
          (index) => Positioned(
              left: peopleTagModel[index].dx ?? 0,
              top: peopleTagModel[index].dy ?? 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.black.withOpacity(0.4)),
                child: Center(
                  child: Text(
                    peopleTagModel[index]?.username ?? "",
                    style: GoogleFonts.roboto()
                        .copyWith(fontSize: 18, color: Colors.white),
                  ),
                ),
              ))).toList(),
    );
  }
}
