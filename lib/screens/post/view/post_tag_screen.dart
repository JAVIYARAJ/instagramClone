import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/core/debounce_helper.dart';
import 'package:instagram_clone/screens/post/bloc/post_bloc.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../../../utils/font_theme.dart';

class PostTagScreen extends StatefulWidget {
  const PostTagScreen({super.key});

  @override
  State<PostTagScreen> createState() => _PostTagScreenState();
}

class _PostTagScreenState extends State<PostTagScreen> {
  final dBounce = DeBouncerHelper(milliseconds: 900);

  final focusNode = FocusNode();

  void showTooltip(BuildContext context, Offset position) {
    final screenSize = MediaQuery.of(context).size;
    double x = position.dx;
    double y = position.dy;

    // Adjust the tooltip position if it's too close to the screen boundaries
    const tooltipWidth = 130; // Tooltip width estimate
    const tooltipHeight = 50; // Tooltip height estimate

    if (x + tooltipWidth > screenSize.width) {
      x = (screenSize.width - tooltipWidth) - screenSize.width * 0.02;
    }

    if (y + tooltipHeight > screenSize.height) {
      y = (screenSize.height - tooltipHeight) - screenSize.height * 2;
    }

    if (!focusNode.hasFocus) {
      focusNode.requestFocus();
    }

    context.read<PostBloc>().add(PostTagPositionChanged(Offset(x, y)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            leadingWidth: state.postDataHolder.isTagControlShow
                ? 0
                : MediaQuery.of(context).size.width * 0.1,
            leading: state.postDataHolder.isTagControlShow
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.clear,
                        color: primaryColor,
                        size: 35,
                      ),
                    ),
                  ),
            title: state.postDataHolder.isTagControlShow
                ? TextField(
                    controller: context.read<PostBloc>().tagController,
                    cursorColor: primaryColor,
                    focusNode: focusNode,
                    style: GoogleFonts.roboto()
                        .copyWith(fontSize: 18, color: primaryColor),
                    onChanged: (value) {
                      dBounce.run(() {
                        if (value.isNotEmpty) {
                          context
                              .read<PostBloc>()
                              .add(PostTagSearchPeopleEvent(value));
                        }
                      });
                    },
                    onSubmitted: (value) {},
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.3),
                        contentPadding: const EdgeInsets.all(5),
                        hintText: "Search for a user",
                        hintStyle: GoogleFonts.roboto().copyWith(
                            fontSize: 18, color: primaryColor.withOpacity(0.7)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(color: Colors.grey)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(color: Colors.grey)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(color: Colors.grey)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(color: Colors.grey)),
                        suffixIcon: context
                                .read<PostBloc>()
                                .tagController
                                .text
                                .isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  context.read<PostBloc>().add(
                                      PostTagClearEvent(isRemoveLastTag: true));
                                },
                                child: Icon(
                                  Icons.close,
                                  color: primaryColor.withOpacity(0.7),
                                  size: 30,
                                ),
                              )
                            : const SizedBox(),
                        prefixIcon: Icon(
                          Icons.search,
                          color: primaryColor.withOpacity(0.7),
                          size: 30,
                        )),
                  )
                : Text(
                    'Tag people',
                    style: titleStyle,
                  ),
            actions: [
              if (!state.postDataHolder.isTagControlShow) ...[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    "assets/ic_success_icon.svg",
                    color: Colors.blueAccent,
                    height: 35,
                    width: 35,
                  ),
                ),
                const SizedBox(
                  width: 10,
                )
              ]
            ],
          ),
          body: SingleChildScrollView(
            child: context.read<PostBloc>().tagController.text.isNotEmpty
                ? state.postDataHolder.tagPeople.isEmpty
                    ? Center(
                        child: Text(
                          "User not found",
                          style: GoogleFonts.roboto().copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                      )
                    : (Column(
                        children: List.generate(
                            state.postDataHolder.tagPeople.length,
                            (index) => ListTile(
                                  onTap: () {
                                    context.read<PostBloc>().add(
                                        PostTagSelectEvent(state
                                            .postDataHolder.tagPeople[index]));
                                    context
                                        .read<PostBloc>()
                                        .add(PostTagClearEvent());
                                  },
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(state
                                            .postDataHolder
                                            .tagPeople[index]
                                            .photoUrl ??
                                        ""),
                                  ),
                                  title: Text(
                                    state.postDataHolder.tagPeople[index]
                                            .username ??
                                        "",
                                    style: GoogleFonts.roboto().copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                  ),
                                  subtitle: Text(
                                    state.postDataHolder.tagPeople[index].bio ??
                                        "",
                                    style: GoogleFonts.roboto().copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: primaryColor),
                                  ),
                                )).toList(),
                      ))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: double.infinity,
                          child: BlocBuilder<PostBloc, PostState>(
                            builder: (context, state) {
                              return GestureDetector(
                                onTapDown: (details) {
                                  showTooltip(context, details.localPosition);
                                },
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    SizedBox(
                                      child: Image(
                                        fit: BoxFit.fill,
                                        image: FileImage(
                                          state.postDataHolder.selectedImages
                                              .last,
                                        ),
                                      ),
                                    ),
                                    if (state.postDataHolder.tagPeopleSelected
                                        .isNotEmpty) ...[
                                      Stack(
                                        children: List.generate(
                                            state.postDataHolder
                                                .tagPeopleSelected.length,
                                            (index) => Positioned(
                                                left: state
                                                    .postDataHolder
                                                    .tagPeopleSelected[index]
                                                    ?.offset
                                                    .dx,
                                                top: state
                                                    .postDataHolder
                                                    .tagPeopleSelected[index]
                                                    ?.offset
                                                    .dy,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (state
                                                            .postDataHolder
                                                            .tagPeopleSelected[
                                                                index]
                                                            .user !=
                                                        null) {}
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius
                                                            .only(
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    5),
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
                                                        color: Colors.black
                                                            .withOpacity(0.4)),
                                                    child: Center(
                                                      child: Text(
                                                        state
                                                                .postDataHolder
                                                                .tagPeopleSelected[
                                                                    index]
                                                                ?.user
                                                                ?.username ??
                                                            "Who's this?",
                                                        style: GoogleFonts
                                                                .roboto()
                                                            .copyWith(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                ))).toList(),
                                      )
                                    ]
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state
                              .postDataHolder.tagPeopleSelected.isNotEmpty) ...[
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                "Tag people",
                                style: GoogleFonts.roboto().copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                          Column(
                            children: List.generate(
                                state.postDataHolder.tagPeopleSelected.length,
                                (index) {
                              var tag =
                                  state.postDataHolder.tagPeopleSelected[index];
                              if (tag.user != null) {
                                return ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(state
                                              .postDataHolder
                                              .tagPeopleSelected[index]
                                              .user
                                              ?.photoUrl ??
                                          ""),
                                    ),
                                    title: Text(
                                      state
                                              .postDataHolder
                                              .tagPeopleSelected[index]
                                              .user
                                              ?.username ??
                                          "",
                                      style: GoogleFonts.roboto().copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor),
                                    ),
                                    trailing: GestureDetector(
                                        onTap: () {
                                          context.read<PostBloc>().add(
                                              PostTagSelectPeopleRemove(index));
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 30,
                                          color: Colors.grey,
                                        )),
                                    subtitle: Text(
                                      state
                                              .postDataHolder
                                              .tagPeopleSelected[index]
                                              .user
                                              ?.bio ??
                                          "",
                                      style: GoogleFonts.roboto().copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: primaryColor),
                                    ));
                              } else {
                                return const SizedBox();
                              }
                            }).toList(),
                          ),
                        ],
                      )
                    ],
                  ),
          ),
        );
      },
    );
  }
}
