import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/core/routes.dart';
import 'package:instagram_clone/screens/post/bloc/post_bloc.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/font_theme.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PostUploadScreen extends StatefulWidget {
  const PostUploadScreen({super.key});

  @override
  State<PostUploadScreen> createState() => _PostUploadScreenState();
}

class _PostUploadScreenState extends State<PostUploadScreen> {
  final captionController = TextEditingController();

  void showPostDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: secondaryColor),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                child: Text(
                  'Start over?',
                  style: GoogleFonts.roboto().copyWith(
                      fontSize: 18,
                      color: primaryColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: Text(
                  'If you go back now, you will lose this draft.',
                  style: GoogleFonts.roboto().copyWith(
                      fontSize: 16,
                      color: primaryColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500),
                ),
              ),
              Divider(
                color: primaryColor.withOpacity(0.7),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.main,
                        (route) => route.settings.name == Routes.main);
                  },
                  child: Text(
                    'Start over',
                    style: GoogleFonts.roboto().copyWith(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Save draft',
                  style: GoogleFonts.roboto().copyWith(
                      fontSize: 20,
                      color: primaryColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Keep editing',
                    style: GoogleFonts.roboto().copyWith(
                        fontSize: 20,
                        color: primaryColor.withOpacity(0.8),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      final state=context.read<PostBloc>().state;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          context
              .read<PostBloc>()
              .add(PostCreateEvent(captionController.text.toString()));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "Share",
              style: GoogleFonts.roboto()
                  .copyWith(fontSize: 18, color: secondaryColor),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: GestureDetector(
            onTap: () {
              final postInfo = context.read<PostBloc>();
              if (postInfo.state.postDataHolder.tagPeopleSelected.isNotEmpty ||
                  postInfo.tagController.text.isNotEmpty ||
                  (postInfo.state.postDataHolder.selectedImages.isNotEmpty &&
                      postInfo.state.postDataHolder.selectedImages.length !=
                          1)) {
                showPostDialog(context);
              } else {
                Navigator.pop(context);
              }
            },
            child: const Icon(
              Icons.close,
              size: 30,
              color: primaryColor,
            )),
        title: Text(
          'New Post',
          style: titleStyle,
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                'Next',
                style: GoogleFonts.roboto().copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.blueAccent),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: List.generate(
                            state.postDataHolder.selectedImages.length,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: BlocBuilder<PostBloc, PostState>(
                                builder: (context, state) {
                                  return SizedBox(
                                    child: Image(
                                      fit: BoxFit.fill,
                                      image: FileImage(
                                        state.postDataHolder
                                            .selectedImages[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ).toList()),
                      if (state.postDataHolder.selectedImages.length > 1) ...[
                        Positioned(
                            bottom: 10,
                            left: MediaQuery.of(context).size.width * 0.4,
                            child: SizedBox(
                              height: 15,
                              child: Center(
                                child: Row(
                                  children: List.generate(
                                      state
                                          .postDataHolder.selectedImages.length,
                                      (index) => Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 5),
                                            height: 15,
                                            width: 15,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          )),
                                ),
                              ),
                            ))
                      ]
                    ],
                  ),
                ),
                Column(
                  children: [
                    IntrinsicHeight(
                      child: TextField(
                        controller: captionController,
                        decoration: InputDecoration(
                            hintText: "Write a caption or add a poll",
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            filled: true,
                            contentPadding: const EdgeInsets.all(20),
                            hintStyle: GoogleFonts.roboto().copyWith(
                                fontSize: 20,
                                color: primaryColor.withOpacity(0.5))),
                        style: GoogleFonts.roboto()
                            .copyWith(fontSize: 20, color: primaryColor),
                        keyboardType: TextInputType.text,
                        cursorColor: primaryColor,
                        maxLines: 5,
                        minLines: 1,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.postTagScreen);
                      },
                      leading: const Icon(
                        Icons.person,
                        color: primaryColor,
                        size: 35,
                      ),
                      title: BlocBuilder<PostBloc, PostState>(
                        builder: (context, state) {
                          return Text(
                            state.postDataHolder.tagPeopleSelected.isNotEmpty
                                ? (state.postDataHolder.tagPeopleSelected
                                            .length ==
                                        1)
                                    ? '${state.postDataHolder.tagPeopleSelected.first.user?.username}'
                                    : '${state.postDataHolder.tagPeopleSelected.length} people'
                                : 'Add people',
                            style: GoogleFonts.roboto().copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: primaryColor),
                          );
                        },
                      ),
                      trailing: const Icon(
                        Icons.arrow_right,
                        color: primaryColor,
                        size: 35,
                      ),
                    )
                  ],
                ),
                BlocListener<PostBloc, PostState>(
                  listener: (context, state) {
                    if (state is PostLoaded) {
                      context.loaderOverlay.hide();
                      if (state.isDirect) {
                        Navigator.pushNamedAndRemoveUntil(context, Routes.main,
                            (route) => route.settings.name == Routes.main);
                      }
                    }
                    if (state is PostLoading) {
                      context.loaderOverlay.show();
                    }
                    if (state is PostError) {
                      showToast(state.error);
                    }
                  },
                  child: const SizedBox(),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
